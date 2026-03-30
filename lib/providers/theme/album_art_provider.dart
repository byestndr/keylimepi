import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:convert';
import 'package:spotimmich/providers/spotify/spotify_playbackstate.dart';

part 'album_art_provider.g.dart';

@riverpod
class AlbumImage extends _$AlbumImage {
  @override
  Future<String> build() async {
    final dynamic currentPlaybackState = await ref.watch(spotifyPlaybackstateProvider.future);

    return getAlbumArt(currentPlaybackState);
  }

  Future<String> getAlbumArt(dynamic currentPlaybackState) async {
    final String imageURL = currentPlaybackState['item']['album']['images'][0]['url'];
    return imageURL;
  }

  void refreshImage() {
    ref.invalidateSelf();
  }
}
