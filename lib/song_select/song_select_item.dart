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
    required this.artist,
    required this.id,
    required this.uri,
    required this.image,
    required this.duration,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SpotifySong && other.uri == uri;
  }

  @override
  int get hashCode => uri.hashCode;
}

class SpotifyQueueItem extends SpotifySong {
  int queuePosition;

  factory SpotifyQueueItem.fromMap(Map<String, dynamic> song, int index) {
    final List<dynamic> images = song['album']['images'];

    return SpotifyQueueItem(
      name: song['name'],
      artist: song['artists'][0]['name'],
      duration: Duration(milliseconds: song['duration_ms']),
      uri: song['uri'],
      id: song['id'],
      image: images.last['url'],
      queuePosition: index,
    );
  }

  SpotifyQueueItem({
    required super.name,
    required super.artist,
    required super.id,
    required super.uri,
    required super.image,
    required super.duration,
    required this.queuePosition,
  });
}

class SpotifyLyricItem extends SpotifySong {
  SpotifyAlbum album;

  SpotifyLyricItem({
    required super.name,
    required super.artist,
    required super.id,
    required super.uri,
    required super.image,
    required super.duration,
    required this.album,
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
