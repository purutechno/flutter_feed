import 'package:dio/dio.dart';
import 'package:flutter_feed/models/video.dart';
import 'package:flutter_feed/services/network/api.dart';
import 'package:flutter_feed/utils/json_list.dart';
import 'package:flutter_feed/utils/json_map.dart';

class Endpoints {
  static const healthCheck = "/health-check";
  static const healthCheckAuth = "/health-check-auth";
  static const videos = "/videos";
  static const mainFeed = "/main-feed";
}

class FeedApi extends Api {
  FeedApi(this._dio);

  final Dio _dio;

  @override
  Future<List<Video>> getMainFeed() async {
    try {
      final response = await _dio.get<JsonList>(Endpoints.videos + Endpoints.mainFeed);
      return response.data?.map((videoData) => Video.fromJson(videoData)).toList() ?? <Video>[];
    } catch (error) {
      rethrow;
    }
  }

  //todo: Create Error Validator
  @override
  Future<bool> isApiHealthy() async {
    try {
      final response = await _dio.get<JsonMap>(Endpoints.healthCheck);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (error) {
      rethrow;
    }
  }
}
