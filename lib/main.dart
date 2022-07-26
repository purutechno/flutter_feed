import 'package:flutter/material.dart';
import 'package:flutter_feed/config/config.dart';
import 'package:flutter_feed/generated/l10n.dart';
import 'package:flutter_feed/router/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  final config = Config(
    env: Env.dev,
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

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerDelegate: ref.watch(routerProvider).delegate(),
      routeInformationParser: ref.watch(routerProvider).defaultRouteParser(),
      //todo:theme
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }
}
