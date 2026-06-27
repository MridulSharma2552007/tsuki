const { playable } = require("../utils/playable_url");
exports.handler = async (event) => {
  const path = event.rawPath;
  const method = event.requestContext.http.method;

  if (path === "/playable" && method === "POST") {
    return await playable(event);
  }
};
