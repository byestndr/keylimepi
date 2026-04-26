import 'package:chopper/src/response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotimmich/backend/spotify/spotify_api.dart';
import 'package:spotimmich/providers/spotify/song_info_provider.dart';
import 'package:spotimmich/providers/spotify/spotify_playbackstate.dart';

part 'queue_provider.g.dart';

@Riverpod(keepAlive: true)
class SpotifyQueue extends _$SpotifyQueue {
  @override
  FutureOr<List<Song>> build() async {
    ref.watch(spotifyPlaybackStateProvider);
    return await getUpdatedQueue();
  }

  Future<List<Song>> getUpdatedQueue() async {
    final SpotifyUserService spotifyService = SpotifyUserService.create();
    final Response<dynamic> spotifyResponse = await spotifyService.getQueue();

    final List<dynamic> queue = spotifyResponse.body['queue'];

    final List<Song> convertedQueue = List<Song>.generate(
      queue.length,
      (int index) => Song.fromMap(queue[index], index),
    );
    return convertedQueue;
  }
}
