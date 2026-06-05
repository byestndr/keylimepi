import 'package:chopper/chopper.dart';
import 'package:key_limepi/lyrics/backend/lyric_api.dart';
import 'package:key_limepi/providers/spotify/song_info_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_provider.g.dart';

class SearchFilter {
  bool artist;
  bool album;
  SearchFilter({required this.album, required this.artist});
}

@riverpod
class LyricSearch extends _$LyricSearch {
  @override
  Future<List<dynamic>> build() {
    return _searchLyrics();
  }

  Future<List<dynamic>> _searchLyrics() async {
    final Song currentSong = await ref.read(infoGetterProvider.future);
    final SearchFilter searchFilters = ref.watch(lyricSearchFilterProvider);

    final LyricService lyricService = LyricService.create();
    final Response<dynamic> response = await lyricService.searchLyrics(
      trackName: currentSong.title,
      artistName: searchFilters.artist == true ? currentSong.artist : null,
      albumName: searchFilters.album == true ? currentSong.album : null,
    );

    final List<dynamic> responseBody = response.body;
    if (responseBody.isEmpty) {
      return [];
    }

    final Iterable<dynamic> syncedLyrics = responseBody.where(
      (dynamic element) => element['syncedLyrics'] != null,
    );

    return Future.value(syncedLyrics.toList());
  }
}

@riverpod
class LyricSearchFilter extends _$LyricSearchFilter {
  @override
  SearchFilter build() {
    return SearchFilter(album: true, artist: true);
  }

  void changeFilterSettings({bool? album, bool? artist}) {
    state = SearchFilter(
      album: album ?? state.album,
      artist: artist ?? state.artist,
    );
    return;
  }
}