const { search } = require("./utils/search");

exports.handler = async (event) => {
  const path = event.rawPath;
  const method = event.requestContext.http.method;
  console.log("[HANDLER] Path:", path, "| Method:", method);
  console.log(
    "[HANDLER] Query params:",
    JSON.stringify(event.queryStringParameters),
  );

  if (path === "/metadata/health" && method === "GET") {
    return {
      statusCode: 200,
      body: JSON.stringify({
        message: "Tsuki Metadata API Online",
      }),
    };
  }

  if (path === "/metadata/search" && method === "GET") {
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
