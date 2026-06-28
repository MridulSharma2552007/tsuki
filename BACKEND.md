# Backend

Tsuki's backend runs on AWS — Lambda functions behind an API Gateway HTTP API, deployed via Serverless Framework and GitHub Actions.

---

## Architecture

```
                        ┌──────────────────────────────────────┐
                        │     API Gateway (HTTP API v2.0)      │
                        │     ap-south-1  |  api-id: mjcxtv3yse │
                        └──────┬──────┬──────┬─────────────────┘
                               │      │      │
              ┌────────────────┘      │      └────────────────┐
              ▼                       ▼                       ▼
   ┌──────────────────┐   ┌──────────────────┐   ┌──────────────────┐
   │ tsuki-            │   │ tsuki-            │   │ tsuki-           │
   │ usermanagement    │   │ playermetadata    │   │ streamer         │
   │ (Node 18)         │   │ (Node 18)         │   │ (Python 3.12)    │
   ├──────────────────┤   ├──────────────────┤   ├──────────────────┤
   │ /health          │   │ /metadata/health │   │ /stream/playable │
   │ /auth/register   │   │ /metadata/search │   │ yt-dlp extraction│
   │ /auth/login      │   │ /metadata/home   │   └──────────────────┘
   │ /auth/verify     │   │ /metadata/featured│
   ├──────────────────┤   ├──────────────────┤
   │ Cognito          │   │ youtubei.js      │
   │ (User Pools)     │   │ (Innertube API)  │
   └──────────────────┘   └──────────────────┘
```

The API Gateway forwards all requests as **POST** to Lambda (even for GET endpoints). Each Lambda inspects `event.rawPath` and `event.requestContext.http.method` to route internally.

---

## Project layout

```
aws/
├── api/
│   ├── api.yml           # OpenAPI 3.0.1 spec — route → Lambda mappings
│   ├── deploy.sh         # Resolves ${VAR} placeholders & re-imports spec
│   └── env/.env          # Region, API ID, Lambda function names
│
└── lambda/
    ├── playermetadata/   # Node 18 — YouTube Music search & featured data
    ├── streamer/         # Python 3.12 — yt-dlp audio extraction
    └── usermanagement/   # Node 18 — Cognito auth (register, login, verify)
```

The Flutter app in `lib/` hits `$BASE_URL` (set in `.env/.env.dev`), which points to the API Gateway endpoint.

---

## Lambda patterns

### Node.js pattern (playermetadata & usermanagement)

Each Node Lambda has the same structure:

```
lambda/<name>/
├── handler.js            # Entry point — routes by rawPath + method
├── serverless.yml        # Serverless Framework config
├── deploy.sh             # npm install → npx serverless deploy
├── package.json
├── utils/                # Route handlers
├── services/             # Shared services (e.g. youtube.js)
├── data/                 # Static/seed data
├── auth/                 # Auth-specific handlers (usermanagement only)
└── test/                 # Local test scripts
```

**Handler pattern** (`handler.js`):

```js
const { search } = require("./utils/search");
const { home } = require("./utils/home");

exports.handler = async (event) => {
  const path = event.rawPath;
  const method = event.requestContext.http.method;

  if (path === "/metadata/search" && method === "GET") {
    return await search(event);
  }

  return {
    statusCode: 404,
    body: JSON.stringify({ message: "Route not found" }),
  };
};
```

The event from API Gateway v2 looks like:

```json
{
  "rawPath": "/metadata/search",
  "requestContext": { "http": { "method": "GET" } },
  "queryStringParameters": { "q": "something" },
  "headers": { ... },
  "body": null
}
```

The response must follow the Lambda proxy format:

```js
{
  statusCode: 200,
  body: JSON.stringify({ songs: [...] }),
}
```

### Python pattern (streamer)

```
lambda/streamer/
├── handler.py            # Entry point + logic (single file)
├── serverless.yml
├── deploy.sh
├── package.json
├── requirements.txt
└── test/
```

Same routing by `rawPath` + method. Returns `{ statusCode, headers, body }` where body is `json.dumps(...)`.

---

## Adding a new Lambda

### Step 1: Scaffold the directory

Copy the pattern from an existing Lambda:

```
aws/lambda/<your-service>/
├── handler.js
├── serverless.yml
├── deploy.sh
├── package.json
└── utils/
    └── your_handler.js
```

### Step 2: Write the handler

`handler.js` — imports your logic, routes by path + method:

```js
const { yourHandler } = require("./utils/your_handler");

exports.handler = async (event) => {
  const path = event.rawPath;
  const method = event.requestContext.http.method;

  if (path === "/your/route" && method === "GET") {
    return await yourHandler(event);
  }

  return { statusCode: 404, body: JSON.stringify({ message: "Not found" }) };
};
```

### Step 3: Deploy with Serverless Framework

`serverless.yml`:

```yaml
service: tsuki-your-service

frameworkVersion: "3"

provider:
  name: aws
  runtime: nodejs18.x
  region: ap-south-1

functions:
  api:
    name: tsuki-your-service
    handler: handler.handler
    timeout: 30
    memorySize: 1024
```

`deploy.sh`:

```bash
#!/bin/bash
set -e
cd "$(dirname "$0")"
npm install
npx serverless deploy
```

`package.json`:

```json
{
  "name": "your-service",
  "version": "1.0.0",
  "main": "handler.js",
  "dependencies": {},
  "devDependencies": {
    "serverless": "^3.38.0"
  }
}
```

Deploy once manually:

```bash
cd aws/lambda/your-service
chmod +x deploy.sh
./deploy.sh
```

After first deploy, note the Lambda function name (it will be `tsuki-your-service`). You'll need it for API Gateway.

---

## Adding routes to API Gateway

### Step 1: Add the Lambda ARN to `aws/api/env/.env`

```env
LAMBDA_FUNCTION_NAME_YOUR_SERVICE=tsuki-your-service
```

The deploy script automatically builds the full Lambda ARN from the function name.

### Step 2: Add the route to `aws/api/api.yml`

```yaml
/your/route:
  get:
    operationId: yourOperation
    x-amazon-apigateway-integration:
      httpMethod: POST
      type: aws_proxy
      payloadFormatVersion: "2.0"
      uri: ${LAMBDA_URI_YOUR_SERVICE}
    responses:
      "200":
        description: OK
```

The `${LAMBDA_URI_YOUR_SERVICE}` placeholder is resolved at deploy time by `api/deploy.sh` using the `LAMBDA_FUNCTION_NAME_YOUR_SERVICE` env var from `.env`.

### Step 3: Deploy the API

```bash
cd aws/api
chmod +x deploy.sh
./deploy.sh
```

This re-imports the spec, grants Lambda invoke permission for API Gateway, and creates a `$default` stage deployment.

---

## Deploy scripts

### Lambda deploy scripts

Every Lambda has a `deploy.sh` that runs `npm install` then `npx serverless deploy`:

```bash
#!/bin/bash
set -e
cd "$(dirname "$0")"
npm install
npx serverless deploy
```

For Python Lambdas, it also installs Python deps via `serverless-python-requirements` with `dockerizePip: true`.

### API deploy script (`aws/api/deploy.sh`)

This script:

1. Loads `env/.env`
2. Fetches the AWS account ID
3. Builds Lambda ARN URIs from `LAMBDA_FUNCTION_NAME_*` env vars:
   - `LAMBDA_FUNCTION_NAME_PLAYERMETADATA=tsuki-playermetadata`
     → `arn:aws:lambda:ap-south-1:<account>:function:tsuki-playermetadata`
     → stored as `LAMBDA_URI_PLAYERMETADATA`
4. Copies `api.yml` to a temp file
5. Replaces `${LAMBDA_URI_*}` placeholders with the full ARNs
6. Re-imports the API spec: `aws apigatewayv2 reimport-api`
7. Grants `lambda:InvokeFunction` permission for API Gateway to each Lambda
8. Creates a deployment on the `$default` stage
9. Prints the API endpoint URL

---

## CI/CD (GitHub Actions)

Each Lambda has its own workflow. All follow the same pattern:

```yaml
# .github/workflows/<name>.yml
name: YourServiceLambda

on:
  push:
    branches: [main, master]
    paths:
      - "aws/lambda/your-service/**"

jobs:
  deploy:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: aws/lambda/your-service
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 18
      - uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.SECRET_ACCESS_KEY }}
          aws-region: ap-south-1
      - run: chmod +x deploy.sh && ./deploy.sh
```

Workflows are triggered only when files in the Lambda's directory change, and only on `main` or `master`.

### Adding CI/CD for a new Lambda

1. Create `.github/workflows/<name>.yml`
2. Follow the pattern above — set `working-directory` to `aws/lambda/<name>` and `paths` to `aws/lambda/<name>/**`
3. The `deploy.sh` script handles the rest

For the API Gateway workflow (`.github/workflows/api-deploy.yml`), the trigger path is `aws/api/**` and credentials are configured once without `setup-node`.

### Required GitHub secrets

| Secret | Used by |
|---|---|
| `AWS_ACCESS_KEY_ID` | All workflows |
| `SECRET_ACCESS_KEY` | All workflows |

---

## Local testing

Each Lambda has test scripts in its `test/` directory. They simulate the API Gateway v2 event shape:

```js
// test/test.search.js
const { handler } = require("../handler");

const event = {
  rawPath: "/metadata/search",
  requestContext: { http: { method: "GET" } },
  queryStringParameters: { q: "never gonna give you up" },
};

handler(event).then(console.log);
```

Run with:

```bash
cd aws/lambda/playermetadata
node test/test.search.js
```
