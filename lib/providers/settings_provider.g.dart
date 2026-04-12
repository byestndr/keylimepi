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

@ProviderFor(Authorization)
final authorizationProvider = AuthorizationProvider._();

final class AuthorizationProvider
    extends $NotifierProvider<Authorization, AuthorizationValue> {
  AuthorizationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authorizationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authorizationHash();

  @$internal
  @override
  Authorization create() => Authorization();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthorizationValue value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthorizationValue>(value),
    );
  }
}

String _$authorizationHash() => r'14d4813e0e042392508f709dc37d711293199694';

abstract class _$Authorization extends $Notifier<AuthorizationValue> {
  AuthorizationValue build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AuthorizationValue, AuthorizationValue>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthorizationValue, AuthorizationValue>,
              AuthorizationValue,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
