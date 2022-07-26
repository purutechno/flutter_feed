import 'package:flutter_feed/pages/feed/state/feed_state.dart';
import 'package:flutter_feed/router/app_router.dart';
import 'package:flutter_feed/services/data_interactors.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final splashscreenPageController = Provider.autoDispose((ref) => SplashscreenPageController(ref.read));

class SplashscreenPageController {
  SplashscreenPageController(this._read) {
    _init();
  }

  final Reader _read;

  Future<void> _init() async {
    final isApiWorking = await _read(feedApiProvider).isApiHealthy();
    if (isApiWorking) {
      final videos = await _read(feedApiProvider).getMainFeed();
      _read(routerProvider).replace(FeedRoute(feedState: FeedState(videos: videos, index: 1)));
    }
  }
}
