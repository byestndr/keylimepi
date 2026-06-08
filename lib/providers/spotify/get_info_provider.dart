import 'package:chopper/chopper.dart';
import 'package:key_limepi/backend/spotify/spotify_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_info_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<Response> GetSongItems(
  Ref ref, {
  required bool isPlaylist,
  required String id,
  int offset = 0,
}) async {
  final SpotifyGetService spotifyAPI = SpotifyGetService.create();

  if (isPlaylist) {
    return await spotifyAPI.getPlaylistItems(id, offset);
  }

  return await spotifyAPI.getAlbumItems(id);
}
