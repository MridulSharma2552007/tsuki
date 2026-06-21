const { getYoutube } = require("../services/youtube");

exports.search = async (event) => {
  try {
    const query = event.queryStringParameters?.q;

    if (!query) {
      return {
        statusCode: 400,
        body: JSON.stringify({
          message: "Query parameter q is required",
        }),
      };
    }

    const yt = await getYoutube();

    const results = await yt.music.search(query, {
      type: "song",
    });

    return {
      statusCode: 200,
      body: JSON.stringify(results),
    };
  } catch (error) {
    console.error("[SEARCH ERROR]", error);

    return {
      statusCode: 500,
      body: JSON.stringify({
        message: error.message,
      }),
    };
  }
};
