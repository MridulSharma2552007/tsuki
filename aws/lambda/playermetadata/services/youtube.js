const { Innertube } = require("youtubei.js");
let yt;

async function getYoutube() {
  if (!yt) {
    yt = await Innertube.create();
  }

  return yt;
}

module.exports = {
  getYoutube,
};
