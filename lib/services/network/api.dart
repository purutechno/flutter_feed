import 'package:flutter_feed/models/video.dart';

abstract class Api {
  Future<bool> isApiHealthy();

  Future<List<Video>> getMainFeed();
}
