import 'package:flutter_feed/utils/json_map.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'video.freezed.dart';

part 'video.g.dart';

//todo: variable name should be lower camel case, find an agreement with backend
@Freezed(toJson: false)
class Video with _$Video {
  const Video._();

  const factory Video({
    required String id,
    required String title,
    required String url,
  }) = _Video;

  factory Video.fromJson(JsonMap json) => _$VideoFromJson(json);
}
