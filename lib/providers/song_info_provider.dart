import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:convert';
import 'package:spotimmich/settings/spotify/spotifyapi.dart';

part 'song_info_provider.g.dart';

class Song {
  String? title;
  String? artist;
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

    return currentSong;
  }

  void getNewSong() async {
    ref.invalidateSelf();
  }
}
