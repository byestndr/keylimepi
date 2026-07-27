import 'package:chopper/src/response.dart';
import 'package:key_limepi/song_select/song_select_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:key_limepi/backend/spotify/spotify_api.dart';
import 'package:key_limepi/providers/spotify/spotify_playbackstate.dart';

part 'queue_provider.g.dart';

@Riverpod(keepAlive: true)
class SpotifyQueue extends _$SpotifyQueue {
  @override
  FutureOr<List<SpotifyQueueItem>> build() async {
    ref.watch(spotifyPlaybackStateProvider);
    return await getUpdatedQueue();
  }

  Future<List<SpotifyQueueItem>> getUpdatedQueue() async {
    final SpotifyUserService spotifyService = SpotifyUserService.create();
    final Response<dynamic> spotifyResponse = await spotifyService.getQueue();

    final List<dynamic> queue = spotifyResponse.body['queue'];

    final List<SpotifyQueueItem> convertedQueue =
        List<SpotifyQueueItem>.generate(
          queue.length,
          (int index) => SpotifyQueueItem.fromMap(queue[index], index),
        );
    return convertedQueue;
  }
}
