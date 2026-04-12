// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserSettings)
final userSettingsProvider = UserSettingsProvider._();

final class UserSettingsProvider
    extends $NotifierProvider<UserSettings, UserValues> {
  UserSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userSettingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userSettingsHash();

  @$internal
  @override
  UserSettings create() => UserSettings();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserValues value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserValues>(value),
    );
  }
}

String _$userSettingsHash() => r'fead1fb868c33994a2333e8a5beb11b8f01be2ab';

abstract class _$UserSettings extends $Notifier<UserValues> {
  UserValues build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<UserValues, UserValues>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UserValues, UserValues>,
              UserValues,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
