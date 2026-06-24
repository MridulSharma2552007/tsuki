const { handler } = require("../handler");

(async () => {
  const response = await handler({
    rawPath: "/metadata/search",
    queryStringParameters: {
      q: "come on eileen",
    },
    requestContext: {
      http: {
        method: "GET",
      },
    },
  });

  console.log(response);
})();
