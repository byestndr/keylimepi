import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:convert';
import 'package:spotimmich/settings/spotify/spotifyapi.dart';
import 'package:spotimmich/providers/colorscheme.dart';
import 'package:spotimmich/providers/album_art_provider.dart';

part 'song_info_provider.g.dart';

class Song {
  String? title;
  String? artist;
  String? uri;
}

@riverpod
class InfoGetter extends _$InfoGetter {
  @override
  Future<Song> build() {
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
