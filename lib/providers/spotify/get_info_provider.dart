import 'package:chopper/chopper.dart';
import 'package:key_limepi/backend/spotify/spotify_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_info_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<Response> GetPlaylistItems(
  Ref ref, {
  required bool isPlaylist,
  required String id,
}) async {
  final SpotifyGetService spotifyAPI = SpotifyGetService.create();
  
  if (isPlaylist) {
    return await spotifyAPI.getPlaylistItems(id);
  } 

  return await spotifyAPI.getAlbumItems(id);
}
