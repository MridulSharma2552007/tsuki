const { search } = require("./utils/search");

exports.handler = async (event) => {
  const path = event.rawPath;
  const method = event.requestContext.http.method;
  console.log("[HANDLER] Incoming event:", JSON.stringify(event, null, 2));
  console.log("[HANDLER] Path:", path, "| Method:", method);
  console.log("[HANDLER] Headers:", JSON.stringify(event.headers));
  console.log("[HANDLER] Body raw:", event.body);
  console.log(
    "[HANDLER] Query params:",
    JSON.stringify(event.queryStringParameters),
  );
  console.log(
    "[HANDLER] Stage variables:",
    JSON.stringify(event.stageVariables),
  );
  console.log(
    "[HANDLER] Request context:",
    JSON.stringify(event.requestContext),
  );
  console.log(
    "[HANDLER] Identity source IP:",
    event.requestContext?.http?.sourceIp,
  );
  console.log("[HANDLER] User agent:", event.requestContext?.http?.userAgent);

  if (path === "/metadata/health" && method === "GET") {
    console.log("[HANDLER] Health check hit");
    return {
      statusCode: 200,
      body: JSON.stringify({
        message: "Tsuki Metadata API Online",
      }),
    };
  }

  if (path === "/metadata/search" && method === "GET") {
    console.log("[HANDLER] Routing to search handler");
    return await search(event);
  }

  console.log("[HANDLER] No matching route — returning 404");
  return {
    statusCode: 404,
    body: JSON.stringify({
      message: "Route not found",
    }),
  };
};
