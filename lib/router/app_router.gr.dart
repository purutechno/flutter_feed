// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'app_router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    SplashscreenRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const SplashscreenPage());
    },
    FeedRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const FeedPage());
    }
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(SplashscreenRoute.name, path: '/'),
        RouteConfig(FeedRoute.name, path: '/feed-page')
      ];
}

/// generated route for
/// [SplashscreenPage]
class SplashscreenRoute extends PageRouteInfo<void> {
  const SplashscreenRoute() : super(SplashscreenRoute.name, path: '/');

  static const String name = 'SplashscreenRoute';
}

/// generated route for
/// [FeedPage]
class FeedRoute extends PageRouteInfo<void> {
  const FeedRoute() : super(FeedRoute.name, path: '/feed-page');

  static const String name = 'FeedRoute';
}
