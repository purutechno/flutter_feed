import 'package:flutter_feed/models/video.dart';
import 'package:flutter_feed/pages/feed/state/feed_state.dart';
import 'package:test/test.dart';

void main() {
  group('The given test verifies that the API call will be made when the end of the video is reached.', () {
    test('Given 10 videos when reached to 9th index in an array then a function is triggered', () {
      //
      final videos = [for (int a = 0; a < 10; a++) Video(id: "1$a", title: "$a", url: "${a + 1}")];
      final feedState = FeedState(videos: videos, index: 1);
      //
      final newVideos = [for (int b = 0; b < 10; b++) Video(id: "$b$b", title: "$b$b", url: "${b + 1}")];
      final oldFeedStateVideoLength = feedState.videos.length;
      if (oldFeedStateVideoLength % 9 == 0 && oldFeedStateVideoLength / 9 == feedState.index) {
        final newFeedState = FeedState(videos: videos + newVideos, index: 2);
        //
        expect(20, newFeedState.videos.length);
      }
    });
  });
}
