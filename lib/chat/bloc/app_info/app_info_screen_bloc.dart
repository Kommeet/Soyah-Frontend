
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quickblox_sdk/models/qb_settings.dart';
import 'package:sohyah/chat/data/settings_repository.dart';

import '../base_bloc.dart';
import 'app_info_screen_events.dart';
import 'app_info_screen_states.dart';

/// Created by Injoit in 2021.
/// Copyright © 2021 Quickblox. All rights reserved.

class AppInfoScreenBloc extends Bloc<AppInfoScreenEvents, AppInfoScreenStates, void> {
  final SettingsRepository settingsRepository = SettingsRepository();

  @override
  void init() {
    super.init();
    states?.add(SettingsInProgressState());
    _getSettings();
  }

  void _getSettings() async {
    try {
      QBSettings? settings = await settingsRepository.get();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version + "." + packageInfo.buildNumber;
      states?.add(SettingsSuccessState(settings, version));
    } on PlatformException catch (e) {
      states?.add(SettingsErrorState(makeErrorMessage(e)));
    }
  }
}
