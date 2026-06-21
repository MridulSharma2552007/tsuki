let yt;

async function getYoutube() {
  if (!yt) {
    console.log("[YOUTUBE] Initializing Innertube...");
    const { Innertube } = await import("youtubei.js");
    yt = await Innertube.create();
    console.log("[YOUTUBE] Innertube initialized");
  }

  return yt;
}

module.exports = {
  getYoutube,
};
