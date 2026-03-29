import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:convert';
import 'package:spotimmich/backend/spotify/spotifyapi.dart';
import 'package:spotimmich/providers/colorscheme.dart';
import 'package:spotimmich/providers/album_art_provider.dart';

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
  Future<Song> build() {
    ref.watch(refreshTimerProvider);
    return getCurrentSong();
  }

  Future<Song> getCurrentSong() async {
    final String currentPlaybackState = await Interactions()
        .cachedPlaybackStateResponse(functionName: 'SongInfo');
    final dynamic body = jsonDecode(currentPlaybackState);

    Song currentSong = Song();
    currentSong.title = body['item']['name'];
    currentSong.artist = body['item']['album']['artists'][0]['name'];
    currentSong.uri = body['item']['uri'];

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

@riverpod
class GetPlaybackState extends _$GetPlaybackState {
  @override
  Future<dynamic> build() async {
    ref.watch(refreshTimerProvider);
    final String currentPlaybackState = await Interactions()
        .cachedPlaybackStateResponse(functionName: 'Controls');

    final dynamic playbackJson = jsonDecode(currentPlaybackState);
    return playbackJson;
  }
}
