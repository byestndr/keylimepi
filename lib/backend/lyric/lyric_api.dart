import 'dart:async';
import 'package:chopper/chopper.dart';

part 'lyric_api.chopper.dart';

@ChopperApi(baseUrl: '/api')
abstract class LyricService extends ChopperService {
  @GET(path: "/get-cached")
  Future<Response> getLyrics({
    @Query('track_name') required String trackName,
    @Query('artist_name') required String artistName,
    @Query('album_name') required String albumName,
  });

  @GET(path: "/get")
  Future<Response> getUncachedLyrics({
    @Query('track_name') required String trackName,
    @Query('artist_name') required String artistName,
    @Query('album_name') required String albumName,
  });

  @GET(path: '/search')
  Future<Response> searchLyrics();

  static LyricService create() {
    final ChopperClient client = ChopperClient(
      baseUrl: Uri.parse('https://lrclib.net'),
      services: <ChopperService>[_$LyricService()],
      converter: const JsonConverter(),
      authenticator: LyricResponseNull()
    );
    return _$LyricService(client);
  }
}

class LyricResponseNull extends Authenticator {
  @override
  FutureOr<Request?> authenticate(Request request, Response<dynamic> response, [Request? originalRequest]) {
     if (!response.isSuccessful) {
      return request.copyWith(uri: Uri(path: '/api/get'));
    }
  }
}
