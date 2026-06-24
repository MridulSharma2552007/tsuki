const { handler } = require("../handler");

(async () => {
  const response = await handler({
    rawPath: "/metadata/home",
    requestContext: {
      http: {
        method: "GET",
      },
    },
  });

  console.log(response);
})();
