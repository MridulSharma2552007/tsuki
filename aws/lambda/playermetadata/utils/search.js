const { getYoutube } = require("../services/youtube");

exports.search = async (event) => {
  try {
    const query = event.queryStringParameters?.q;
    console.log("[SEARCH] Query:", query);

    if (!query) {
      console.log("[SEARCH] Missing query — returning 400");
      return {
        statusCode: 400,
        body: JSON.stringify({
          message: "Query parameter q is required",
        }),
      };
    }

    const yt = await getYoutube();

    console.log("[SEARCH] Searching for:", query);
    const results = await yt.music.search(query, {
      type: "song",
    });
    console.log(
      "[SEARCH] Results count:",
      results?.length || results?.contents?.length || "unknown",
    );
    console.log(
      "[SEARCH] Results keys:",
      results ? Object.keys(results) : "null",
    );

    return {
      statusCode: 200,
      body: JSON.stringify(results),
    };
  } catch (error) {
    console.log("[SEARCH] ERROR:", error);
    console.log("[SEARCH] Error name:", error.name);
    console.log("[SEARCH] Error message:", error.message);

    return {
      statusCode: 500,
      body: JSON.stringify({
        message: error.message,
      }),
    };
  }
};
