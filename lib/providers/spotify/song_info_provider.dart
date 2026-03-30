import 'package:riverpod_annotation/riverpod_annotation.dart';
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
  String title = 'Nothing currently playing...';
  String artist = "Start playing a song to control playback";
  String? uri;
}

@riverpod
class InfoGetter extends _$InfoGetter {
  @override
  Future<Song> build() async {
    final dynamic currentPlaybackState = await ref.watch(spotifyPlaybackstateProvider.future);

    return getCurrentSong(currentPlaybackState);
  }

  Future<Song> getCurrentSong(dynamic currentPlaybackState) async {
    Song currentSong = Song();
    currentSong.title = currentPlaybackState['item']['name'];
    currentSong.artist = currentPlaybackState['item']['album']['artists'][0]['name'];
    currentSong.uri = currentPlaybackState['item']['uri'];

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
    if (state.value!.uri != newURI) {
      ref.read(albumImageProvider.notifier).refreshImage();
      ref.read(appColorSchemeProvider.notifier).refreshColorscheme();
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
