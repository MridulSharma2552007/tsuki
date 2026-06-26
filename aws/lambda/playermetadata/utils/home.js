const { getYoutube } = require("../services/youtube");
const featuredArtists = require("../data/tsuki_featured_artists");
const featuredAlbums = require("../data/tsuki_featured_albums");
const featuredSongs = require("../data/tsuki_featured_songs");

// Picks the largest thumbnail from the contents array (search results
// don't always return them sorted by size)
function getBestThumbnail(thumbnail) {
  const contents = thumbnail?.contents;
  if (!contents?.length) return null;
  return contents.reduce(
    (best, t) => (t.width > (best?.width ?? 0) ? t : best),
    null,
  )?.url;
}

// YouTube/Google CDN thumbnail URLs encode size in the query suffix
// (e.g. =w120-h120-l90-rj or =s120). Rewriting that suffix gets you a
// much higher resolution image from the same source, no extra API calls.
// We drop the -l90-rj lossy-compression suffix for maximum quality.
function upscaleThumbnail(url, size = 1080) {
  if (!url) return null;
  if (/=w\d+-h\d+/.test(url)) {
    return url.replace(/=w\d+-h\d+(-.*)?$/, `=w${size}-h${size}`);
  }
  if (/=s\d+/.test(url)) {
    return url.replace(/=s\d+(-.*)?$/, `=s${size}`);
  }
  // fallback: append a size param if the URL has none of the known patterns
  return `${url}=w${size}-h${size}`;
}

// Channel avatars on YouTube are max 800x800
function getArtistThumbnail(thumbnail) {
  return upscaleThumbnail(getBestThumbnail(thumbnail), 800);
}

// Album art is typically higher res
function getAlbumThumbnail(thumbnail) {
  return upscaleThumbnail(getBestThumbnail(thumbnail), 1080);
}

// Songs use the standard YouTube thumbnail CDN for native maxres quality
function getSongThumbnail(song) {
  return `https://i.ytimg.com/vi/${song.id}/maxresdefault.jpg`;
}

async function getFeaturedArtists(yt, artists) {
  const data = await Promise.all(
    artists.map(async (artistName) => {
      const results = await yt.music.search(artistName, {
        type: "artist",
      });
      const artist = results.contents?.[0]?.contents?.[0];
      if (!artist) return null;
      return {
        id: artist.id,
        name: artist.name,
        thumbnail: getArtistThumbnail(artist.thumbnail),
        youtubeUrl: `https://www.youtube.com/channel/${artist.id}`,
      };
    }),
  );
  return data.filter(Boolean);
}

async function getFeaturedAlbums(yt, albums) {
  const data = await Promise.all(
    albums.map(async (albumInfo) => {
      const query = `${albumInfo.album} ${albumInfo.artist}`;
      const results = await yt.music.search(query, {
        type: "album",
      });
      const album = results.contents?.[0]?.contents?.[0];
      if (!album) return null;
      return {
        id: album.id,
        title: album.title,
        artist: album.author?.name,
        thumbnail: getAlbumThumbnail(album.thumbnail),
      };
    }),
  );
  return data.filter(Boolean);
}

async function getFeaturedSongs(yt, songs) {
  const data = await Promise.all(
    songs.map(async (songInfo) => {
      const query = `${songInfo.title} ${songInfo.artist}`;
      const results = await yt.music.search(query, {
        type: "song",
      });
      const song = results.contents?.[0]?.contents?.[0];
      if (!song) return null;
      return {
        id: song.id,
        title: song.title,
        artist: song.artists?.[0]?.name,
        duration: song.duration?.text,
        thumbnail: getSongThumbnail(song),
        youtubeUrl: `https://www.youtube.com/watch?v=${song.id}`,
      };
    }),
  );
  return data.filter(Boolean);
}

exports.home = async () => {
  try {
    const yt = await getYoutube();
    const [artists, albums, songs] = await Promise.all([
      getFeaturedArtists(yt, featuredArtists),
      getFeaturedAlbums(yt, featuredAlbums),
      getFeaturedSongs(yt, featuredSongs),
    ]);
    return {
      statusCode: 200,
      body: JSON.stringify({
        artists,
        albums,
        songs,
      }),
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
