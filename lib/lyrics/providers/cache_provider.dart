import 'package:key_limepi/lyrics/backend/lyric_cache.dart';
import 'package:key_limepi/lyrics/providers/lyric_classes.dart';
import 'package:key_limepi/providers/spotify/song_info_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cache_provider.g.dart';

@riverpod
FutureOr<List<LyricLine>?> LyricCache(Ref ref) async {
  final Song currentSong = await ref.watch(infoGetterProvider.future);
  final String songID = currentSong.uri!;

  final List<LyricLine>? lyrics = await LyricCacheService.getLyric(songID);
  return lyrics;
}