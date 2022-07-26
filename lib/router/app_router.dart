import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feed/pages/feed/feed_page.dart';
import 'package:flutter_feed/pages/feed/state/feed_state.dart';
import 'package:flutter_feed/pages/splashscreen/splashscreen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'app_router.gr.dart';

final routerProvider = Provider<AppRouter>((ref) => AppRouter());

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: SplashscreenPage, initial: true),
    AutoRoute<FeedState>(page: FeedPage),
  ],
)
class AppRouter extends _$AppRouter {}
