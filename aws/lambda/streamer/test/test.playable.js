const { handler } = require("../handler");

(async () => {
  const response = await handler({
    rawPath: "/playable",
    requestContext: { http: { method: "POST" } },
    body: JSON.stringify({ videoId: "dQw4w9WgXcQ" }),
  });

  console.log(JSON.stringify(response, null, 2));
})();
