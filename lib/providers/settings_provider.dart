import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotimmich/settings/preferences.dart';

part 'settings_provider.g.dart';

class UserValues {}

@Riverpod(keepAlive: true)
class UserSettings extends _$UserSettings {
  @override
  UserValues build() {
    return UserValues();
  }
}
