const { Innertube } = require("youtubei.js");

async function playable(videoId) {
  console.log(`[playable] Fetching audio for videoId: ${videoId}`);

  const yt = await Innertube.create();
  const info = await yt.getInfo(videoId);

  console.log(`[playable] Title: ${info.basic_info.title}`);
  console.log(`[playable] Duration: ${info.basic_info.duration}s`);

  const audioFormats = info.streaming_data.adaptive_formats.filter(
    (f) => f.has_audio && !f.has_video,
  );
  audioFormats.sort((a, b) => b.bitrate - a.bitrate);
  const best = audioFormats[0];

  console.log(`[playable] Format: ${best.mime_type} @ ${best.bitrate}bps`);
  console.log(`[playable] URL: ${best.url || "N/A"}`);

  return {
    url: best.url,
    bitrate: best.bitrate,
    mimeType: best.mime_type,
    duration: info.basic_info.duration,
  };
}

module.exports = { playable };
