let yt;
async function getYoutube() {
  if (!yt) {
    console.log("Initializing Innertube");
    yt = await Innertube.create();
    console.log("Innertube Initialized");
  }
  return yt;
}

module.exports = {
  getYoutube,
};
