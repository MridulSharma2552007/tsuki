const { search } = require("./utils/search");

exports.handler = async (event) => {
  const path = event.rawPath;
  const method = event.requestContext.http.method;

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

  return {
    statusCode: 404,
    body: JSON.stringify({
      message: "Route not found",
    }),
  };
};
