import 'dart:async';

import 'package:chopper/chopper.dart';

class LyricResponseInterceptor implements Interceptor {
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final response = await chain.proceed(chain.request);

    // Just testing this interceptor right now
    // if (!response.isSuccessful) {
    //   print(response.body);
    // }
    
    return response;
  }
}
