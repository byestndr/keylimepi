abstract class SpotifyItem {
  String name;
  String id;
  String uri;
  Uri image;

  SpotifyItem({
    required this.name,
    required this.id,
    required this.uri,
    required this.image,
  });
}

class SpotifySong implements SpotifyItem {
  String artist;
  Duration duration;

  @override
  String name;

  @override
  String id;

  @override
  String uri;

  @override
  Uri image;

  SpotifySong({
    required this.name,
    required this.id,
    required this.uri,
    required this.image,
    required this.artist,
    required this.duration,
  });
}

abstract class SpotifyCollection implements SpotifyItem {}

class SpotifyPlaylist implements SpotifyCollection {
  @override
  String name;

  @override
  String id;

  @override
  String uri;

  @override
  Uri image;

  SpotifyPlaylist({
    required this.name,
    required this.id,
    required this.uri,
    required this.image,
  });
}

class SpotifyAlbum implements SpotifyCollection {
  String artist;

  @override
  String name;

  @override
  String id;

  @override
  String uri;

  @override
  Uri image;

  SpotifyAlbum({
    required this.name,
    required this.id,
    required this.uri,
    required this.image,
    required this.artist,
  });
}
