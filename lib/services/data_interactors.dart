import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_logger/dio_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_feed/services/deviceId_provider.dart';
import 'package:flutter_feed/services/network/api.dart';
import 'package:flutter_feed/services/network/feed_api.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info/package_info.dart';

final feedApiProvider = Provider<Api>((ref) => FeedApi(ref.read(dioProvider)));

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.claps.ai/v1',
  ));
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final packageInfo = await PackageInfo.fromPlatform();

      options.headers.addAll(<String, dynamic>{
        'platform': Platform.isIOS ? 'iOS' : 'Android',
        'version': packageInfo.version,
        'Content-Type': 'application/json',
        'Device-Id': ref.read(deviceIdProvider),
      });

      handler.next(options);
    },
  ));

  if (kDebugMode) {
    dio.interceptors.add(dioLoggerInterceptor);
  }

  return dio;
});
