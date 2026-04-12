import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

class UserValues {}

class AuthorizationValue {}

@Riverpod(keepAlive: true)
class UserSettings extends _$UserSettings {
  @override
  UserValues build() {
    return UserValues();
  }
}

@Riverpod(keepAlive: true)
class Authorization extends _$Authorization {
  @override
  AuthorizationValue build() {
    return AuthorizationValue();
  }
}
