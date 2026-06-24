const { getYoutube } = require("../services/youtube");

exports.home = async () => {
  try {
    const yt = await getYoutube();

    const results = await yt.music.search("metallica");
    const songs = results.contents[0].contents.slice(0, 3).map((song) => ({
      id: song.id,
      title: song.title,
      artist: song.artists?.[0]?.name,
      duration: song.duration?.text,
      thumbnail: song.thumbnail?.contents?.at(-1)?.url,
    }));
    console.log(JSON.stringify(results.contents[0].contents[0], null, 2));
    console.log(songs);

    return {
      statusCode: 200,
      body: JSON.stringify(songs),
    };
  } catch (e) {
    console.error(e);

    return {
      statusCode: 500,
      body: JSON.stringify({
        message: e.message,
      }),
    };
  }
};
