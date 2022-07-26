import 'package:flutter_feed/models/video.dart';
import 'package:flutter_feed/pages/feed/state/feed_state.dart';
import 'package:flutter_feed/services/data_interactors.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final feedPageProvider = StateNotifierProvider.family<FeedPageController, AsyncValue<FeedState>, FeedState>(
    (ref, feedState) => FeedPageController(ref.read, feedState));

class FeedPageController extends StateNotifier<AsyncValue<FeedState>> {
  FeedPageController(this.reader, this.feedState) : super(AsyncValue.data(feedState));

  final Reader reader;
  final FeedState feedState;

  FeedState get _getFeedState => state.asData!.value;

  void onPageChanged(int index) {
    final isDivisibleBy9 = index % 9 == 0; // 10 videos are fetched on a single call
    final shouldFetchNewVideos = index / 9 == _getFeedState.index;
    // first index is 0
    if (index != 0 && isDivisibleBy9 && shouldFetchNewVideos) {
      addVideos();
    }
  }

//todo: Fix
  Future<void> addVideos() async {
    final newVideos = await reader(feedApiProvider).getMainFeed();
    final List<Video> videos = [];
    videos.addAll(_getFeedState.videos);
    videos.addAll(newVideos);
    final newFeedState = FeedState(videos: videos, index: _getFeedState.index + 1);
    state = AsyncValue.data(newFeedState);
  }
}
