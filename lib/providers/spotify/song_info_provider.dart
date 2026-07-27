import 'package:key_limepi/providers/spotify/seekbar_provider.dart';
import 'package:key_limepi/song_select/song_select_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:key_limepi/lyrics/providers/lyrics_provider.dart';
import 'package:key_limepi/lyrics/providers/search_provider.dart';
import 'package:key_limepi/providers/spotify/spotify_playbackstate.dart';
import 'package:key_limepi/providers/theme/colorscheme.dart';
import 'package:key_limepi/providers/theme/album_art_provider.dart';

part 'song_info_provider.g.dart';

@riverpod
Stream<void> refreshTimer(Ref ref) {
  return Stream.periodic(
    const Duration(seconds: 5),
    (_) => <dynamic, dynamic>{},
  );
}

@Riverpod(keepAlive: true)
class InfoGetter extends _$InfoGetter {
  @override
  Future<SpotifySong?> build() async {
    final dynamic currentPlaybackState = await ref.watch(
      spotifyPlaybackStateProvider.future,
    );

    if (currentPlaybackState.statusCode == 204) {
      return null;
    }

    return getCurrentSong(currentPlaybackState.body);
  }

  Future<SpotifySong> getCurrentSong(dynamic currentPlaybackState) async {
    final Uri albumCover = Uri.parse(
      currentPlaybackState['item']['album']['images'][0]['url'],
    );

    final String albumArtist =
        currentPlaybackState['item']['album']['artists'][0]['name'];

    final SpotifyAlbum songAlbum = SpotifyAlbum(
      name: currentPlaybackState['item']['album']['name'],
      id: currentPlaybackState['item']['album']['id'],
      uri: currentPlaybackState['item']['uri'],
      image: albumCover,
      artist: albumArtist,
    );

    final SpotifySong currentSong = SpotifySong(
      album: songAlbum,
      name: currentPlaybackState['item']['name'],
      artist: albumArtist,
      uri: currentPlaybackState['item']['uri'],
      id: currentPlaybackState['item']['id'],
      duration: Duration(
        milliseconds: currentPlaybackState['item']['duration_ms'],
      ),
      image: albumCover,
    );

    final SpotifySong? oldSong = state.value;

    if (oldSong != null && _isNewSong(currentSong)) {
      _onNewSong();
    }

    // If no previous song is found, it should still refresh colorscheme and images.
    if (oldSong == null) {
      ref.read(albumImageProvider.notifier).refreshImage();
      ref.read(appColorSchemeProvider.notifier).refreshColorscheme();
    }

    return currentSong;
  }

  bool _isNewSong(SpotifySong newSong) {
    return state.value == newSong;
  }

  void _onNewSong() {
    ref.read(albumImageProvider.notifier).refreshImage();
    ref.read(appColorSchemeProvider.notifier).refreshColorscheme();
    ref.invalidate(lyricsGetterProvider);
    ref.invalidate(seekbarPositionProvider);

    if (ref.exists(lyricSearchProvider)) {
      ref.invalidate(lyricSearchProvider);
    }
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

@Riverpod(keepAlive: true)
class SongLatency extends _$SongLatency {
  @override
  Stopwatch build() {
    return Stopwatch();
  }

  void startStopwatch() {
    state.start();
    return;
  }

  void stopStopwatch() {
    state.stop();
    return;
  }

  void resetStopwatch() {
    state.reset();
    return;
  }
}
