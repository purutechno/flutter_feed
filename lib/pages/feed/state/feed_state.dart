import 'package:flutter_feed/models/video.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_state.freezed.dart';

@Freezed(toJson: false)
class FeedState with _$FeedState {
  const FeedState._();

  const factory FeedState({
    required List<Video> videos,
    required int index,
  }) = _FeedState;
}
