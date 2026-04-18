import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotimmich/settings/preferences.dart';

part 'settings_provider.g.dart';

@Riverpod(keepAlive: true)
class UserSettings extends _$UserSettings {
  @override
  UserValues build() {
    throw UnimplementedError();
  }

  Future<void> getNewState() async {
    final UserValues newState = await UserValues().getUpdatedValues();

    state = newState;
    return;
  }
}

class UserSettingsOverride extends UserSettings {
  final UserValues initialData;
  UserSettingsOverride(this.initialData);

  @override
  UserValues build() => initialData;
}

