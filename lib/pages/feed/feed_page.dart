import 'package:flutter/material.dart';
import 'package:flutter_feed/models/video.dart';
import 'package:flutter_feed/pages/feed/feed_page_provider.dart';
import 'package:flutter_feed/pages/feed/state/feed_state.dart';
import 'package:flutter_feed/pages/feed/widget/feed_video_player.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FeedPage extends HookConsumerWidget {
  const FeedPage({
    required this.feedState,
    Key? key,
  }) : super(key: key);

  final FeedState feedState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();

    return Scaffold(
      body: ref.watch(feedPageProvider(feedState)).map(
            data: (data) => _FeedPage(
              pageController: pageController,
              videos: data.value.videos,
              onPageChanged: ref.read(feedPageProvider(data.value).notifier).onPageChanged,
            ),
            error: (error) => _FeedPage(
              pageController: pageController,
              videos: feedState.videos,
              onPageChanged: ref.read(feedPageProvider(feedState).notifier).onPageChanged,
            ),
            loading: (loading) => const SizedBox.shrink(),
          ),
    );
  }
}

class _FeedPage extends StatelessWidget {
  const _FeedPage({
    required this.pageController,
    required this.videos,
    required this.onPageChanged,
    Key? key,
  }) : super(key: key);

  final PageController pageController;
  final List<Video> videos;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) => PageView.builder(
        controller: pageController,
        scrollDirection: Axis.vertical,
        itemCount: videos.length,
        onPageChanged: onPageChanged,
        itemBuilder: (context, index) => FeedVideoPlayer.network(
          autoPlay: true,
          showScrubber: false,
          url: videos[index].url,
        ),
      );
}
