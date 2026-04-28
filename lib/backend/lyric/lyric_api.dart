import 'package:chopper/chopper.dart';
import 'package:spotimmich/backend/lyric/lyric_interceptor.dart';

part 'lyric_api.chopper.dart';

@ChopperApi(baseUrl: '/api')
abstract class LyricService extends ChopperService {
  @GET(path: "/get")
  Future<Response> getLyrics();

  @GET(path: "/get-cached")
  Future<Response> getCachedLyrics();

  @GET(path: '/search')
  Future<Response> searchLyrics();

  static LyricService create() {
    final ChopperClient client = ChopperClient(
      baseUrl: Uri.parse('https://lrclib.net'),
      services: <ChopperService>[_$LyricService()],
      converter: const JsonConverter(),
      interceptors: <Interceptor>[LyricResponseInterceptor()],
    );
    return _$LyricService(client);
  }
}