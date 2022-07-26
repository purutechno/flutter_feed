import 'package:flutter/material.dart';
import 'package:flutter_feed/config/config.dart';
import 'package:flutter_feed/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  final config = Config(
    env: Env.prod,
  );

  runApp(
    ProviderScope(
      overrides: [
        configProvider.overrideWithValue(config),
      ],
      child: const MyApp(),
    ),
  );
}
