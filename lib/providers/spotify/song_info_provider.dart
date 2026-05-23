import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotimmich/providers/lyrics_provider.dart';
import 'package:spotimmich/providers/spotify/spotify_playbackstate.dart';
import 'package:spotimmich/providers/theme/colorscheme.dart';
import 'package:spotimmich/providers/theme/album_art_provider.dart';

part 'song_info_provider.g.dart';

@riverpod
Stream<void> refreshTimer(Ref ref) {
  return Stream.periodic(
    const Duration(seconds: 5),
    (_) => <dynamic, dynamic>{},
  );
}

class Song {
  String title;
  String artist;
  String? album;
  String? uri;
  String? image;
  int? queuePosition;

  Song({
    this.title = 'Nothing currently playing...',
    this.artist = 'Start playing a song to control playback',
    this.album,
    this.uri,
    this.image,
    this.queuePosition,
  });

  factory Song.fromMap(Map<String, dynamic> song, int index) {
    final List<dynamic> images = song['album']['images'];

    return Song(
      title: song['name'],
      artist: song['artists'][0]['name'],
      album: song['album']['name'],
      uri: song['uri'],
      image: images.last['url'],
      queuePosition: index,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Song && other.uri == uri;
  }

  @override
  int get hashCode => uri.hashCode;
}

@Riverpod(keepAlive: true)
class InfoGetter extends _$InfoGetter {
  @override
  Future<Song> build() async {
    final dynamic currentPlaybackState = await ref.watch(
      spotifyPlaybackStateProvider.future,
    );

    if (currentPlaybackState.statusCode == 204) {
      return Song();
    }

    return getCurrentSong(currentPlaybackState.body);
  }

  Future<Song> getCurrentSong(dynamic currentPlaybackState) async {
    Song currentSong = Song(
      title: currentPlaybackState['item']['name'],
      artist: currentPlaybackState['item']['album']['artists'][0]['name'],
      album: currentPlaybackState['item']['album']['name'],
      uri: currentPlaybackState['item']['uri'],
      image: currentPlaybackState['item']['album']['images'][0]['url'],
    );

    final Song? oldSong = state.value;

    if (oldSong != null) {
      isNewSong(currentSong.uri);
    }

    // If no previous song is found, it should still refresh colorscheme and images.
    if (oldSong == null) {
      ref.read(albumImageProvider.notifier).refreshImage();
      ref.read(appColorSchemeProvider.notifier).refreshColorscheme();
    }

    return currentSong;
  }

  void isNewSong(String? newURI) {
    if (state.value!.uri == newURI) {
      return;
    }

    ref.read(albumImageProvider.notifier).refreshImage();
    ref.read(appColorSchemeProvider.notifier).refreshColorscheme();
    ref.invalidate(lyricsGetterProvider);

    if (ref.exists(lyricSearchProvider)) {
      ref.invalidate(lyricSearchProvider);
    }
  }

  void getNewSong() async {
    ref.invalidateSelf();
  }
}

@riverpod
class isQueueExpanded extends _$isQueueExpanded {
  @override
  bool build() {
    return false;
  }

  void changeState() {
    state = !state;
  }
}
