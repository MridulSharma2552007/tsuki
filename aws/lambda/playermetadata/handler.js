const { search } = require("./utils/search");
const { home } = require("./utils/home");
const tsuki_featured = require("./utils/tsuki_featured");

exports.handler = async (event) => {
  const path = event.rawPath;
  const method = event.requestContext.http.method;

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
    return await search(event);
  }
  if (path === "/metadata/home" && method === "GET") {
    return await home(event);
  }
  if (path === "/metadata/featured" && method === "GET") {
    return await tsuki_featured(event);
  }

  return {
    statusCode: 404,
    body: JSON.stringify({
      message: "Route not found",
    }),
  };
};
