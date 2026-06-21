let yt;

async function getYoutube() {
  if (!yt) {
    const { Innertube } = await import("youtubei.js");
    yt = await Innertube.create();
  }

  return yt;
}

module.exports = {
  getYoutube,
};
