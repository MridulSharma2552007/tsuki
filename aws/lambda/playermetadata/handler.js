exports.handler = async (event) => {
  const path = event.rawPath;
  const method = event.requestContext.http.method;

  if (path === "/metadata/health" && method === "GET") {
    return {
      statusCode: 200,
      body: JSON.stringify({ message: "Tsuki MetadataApi API Online" }),
    };
  }
};
