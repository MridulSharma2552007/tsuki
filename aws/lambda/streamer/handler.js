const { playable } = require("./utils/playable_url");
exports.handler = async (event) => {
  const path = event.rawPath;
  const method = event.requestContext.http.method;

  if (path === "/playable" && method === "POST") {
    const { videoId } = JSON.parse(event.body);
    return await playable(videoId);
  }
};
