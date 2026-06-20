const { register } = require("./auth/register");
const { login } = require("./auth/login");
const { verify } = require("./auth/verify");

exports.handler = async (event) => {
  const path = event.rawPath;
  const method = event.requestContext.http.method;
  console.log("[HANDLER] Incoming event:", JSON.stringify(event, null, 2));
  console.log("[HANDLER] Path:", path, "| Method:", method);
  console.log("[HANDLER] Headers:", JSON.stringify(event.headers));
  console.log("[HANDLER] Body raw:", event.body);
  console.log("[HANDLER] Query params:", JSON.stringify(event.queryStringParameters));
  console.log("[HANDLER] Stage variables:", JSON.stringify(event.stageVariables));
  console.log("[HANDLER] Request context:", JSON.stringify(event.requestContext));
  console.log("[HANDLER] Identity source IP:", event.requestContext?.http?.sourceIp);
  console.log("[HANDLER] User agent:", event.requestContext?.http?.userAgent);
  console.log("[HANDLER] ENV CLIENT_ID:", process.env.CLIENT_ID);
  console.log("[HANDLER] ENV USER_POOL_ID:", process.env.USER_POOL_ID);
  console.log("[HANDLER] ENV REGION:", process.env.REGION);

  if (path === "/health" && method === "GET") {
    console.log("[HANDLER] Health check hit");
    return {
      statusCode: 200,
      body: JSON.stringify({ message: "Tsuki API Online" }),
    };
  }

  if (path === "/auth/register" && method === "POST") {
    console.log("[HANDLER] Routing to register handler");
    return register(event);
  }

  if (path === "/auth/login" && method === "POST") {
    console.log("[HANDLER] Routing to login handler");
    return login(event);
  }

  if (path === "/auth/verify" && method === "POST") {
    console.log("[HANDLER] Routing to verify handler");
    return verify(event);
  }

  console.log("[HANDLER] No matching route — returning 404");
  return {
    statusCode: 404,
    body: JSON.stringify({ message: "Route not found" }),
  };
};
