const { getYoutube } = require("../services/youtube");
const featuredArtists = require("../data/tsuki_featured_artists");
const featuredAlbums = require("../data/tsuki_featured_albums");
const featuredSongs = require("../data/tsuki_featured_songs");

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
        thumbnail: artist.thumbnail?.contents?.at(-1)?.url,
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
        thumbnail: album.thumbnail?.contents?.at(-1)?.url,
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
        thumbnail: song.thumbnail?.contents?.at(-1)?.url,
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
