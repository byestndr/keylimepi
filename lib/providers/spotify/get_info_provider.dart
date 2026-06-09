import 'package:chopper/chopper.dart';
import 'package:key_limepi/backend/spotify/spotify_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_info_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<List<dynamic>> getItemSongs(
  Ref ref, {
  required String id,
  required bool isPlaylist,
}) async {
  final SpotifyGetService spotifyAPI = SpotifyGetService.create();

  late Response<dynamic> response;
  if (isPlaylist) {
    response = await spotifyAPI.getPlaylistItems(id, 0);
  } else {
    response = await spotifyAPI.getAlbumItems(id, 0);
  }

  List<dynamic> songs = response.body['items'];
  final int totalSongs = response.body['total'];
  final int songsPerPage = response.body['limit'];
  if (totalSongs - songsPerPage < 0) {
    return songs;
  }

  final int pagesToGet = (totalSongs / songsPerPage).ceil() + 1;

  for (int i = 1; i < pagesToGet; i++) {
    late Response<dynamic> newResponse;
    if (isPlaylist) {
      newResponse = await spotifyAPI.getPlaylistItems(id, i * songsPerPage);
    } else {
      newResponse = await spotifyAPI.getAlbumItems(id, i * songsPerPage);
    }
    songs.addAll(newResponse.body['items']);
  }

  return songs;
}
