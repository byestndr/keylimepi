import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:convert';
import 'package:spotimmich/backend/spotify/spotifyapi.dart';

part 'album_art_provider.g.dart';

@riverpod
class AlbumImage extends _$AlbumImage {
  @override
  Future<String> build() async {
    return getAlbumArt();
  }

  Future<String> getAlbumArt() async {
    final String currentPlaybackState = await Interactions()
        .cachedPlaybackStateResponse(functionName: 'SongImage');

    final dynamic body = jsonDecode(currentPlaybackState);
    final String imageURL = body['item']['album']['images'][0]['url'];
    return imageURL;
  }

  void refreshImage() {
    ref.invalidateSelf();
  }
}
