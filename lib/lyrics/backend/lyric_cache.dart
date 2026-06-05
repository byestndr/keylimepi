import 'package:hive_ce/hive_ce.dart';
import 'package:key_limepi/lyrics/providers/lyric_classes.dart';

class LyricCacheService {
  static const String _boxName = "lyric_cache";

  static Future<LazyBox> _getBox() async {
    return await Hive.openLazyBox(_boxName);
  }

  static Future<void> cacheLyric(String id, List<LyricLine> lyrics) async {
    final LazyBox lyricCache = await _getBox();

    await lyricCache.put(id, lyrics);
    return;
  }

  static Future<List<LyricLine>?> getLyric(String id) async {
    final LazyBox<dynamic> lyricCache = await _getBox();
    final lyricData = await lyricCache.get(id);

    if (lyricData == null) {
      return lyricData;
    }

    final List<LyricLine> cachedLyrics = (lyricData as List).cast<LyricLine>();

    return cachedLyrics;
  }

  static Future<void> clearCache() async {
    final LazyBox lyricCache = await _getBox();
    await lyricCache.clear();

    return;
  }
}
