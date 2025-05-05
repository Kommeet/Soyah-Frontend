import 'dart:async';

import 'package:flutter/services.dart';
import 'package:quickblox_sdk/models/qb_subscription.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:sohyah/chat/data/repository_exception.dart';

/// Created by Injoit in 2021.
/// Copyright © 2021 Quickblox. All rights reserved.

class SubscriptionsRepository {
  Future<List<QBSubscription?>?> createPushSubscription(
      String deviceToken, String pushChannel) async {
    try {
      return await QB.subscriptions.create(deviceToken, pushChannel);
    } on PlatformException catch (e) {
      throw RepositoryException(e.message);
    }
  }

  Future<List<QBSubscription?>?> getPushSubscriptions() async {
    try {
      return await QB.subscriptions.get();
    } on PlatformException catch (e) {
      throw RepositoryException(e.message);
    }
  }

  Future<void> removePushSubscription(int id) async {
    try {
      await QB.subscriptions.remove(id);
    } on PlatformException catch (e) {
      throw RepositoryException(e.message);
    }
  }
}
