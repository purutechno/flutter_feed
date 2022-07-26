import 'package:hooks_riverpod/hooks_riverpod.dart';

final configProvider = Provider<Config>((ref) => throw UnimplementedError());

enum Env { dev, staging, prod }

class Config {
  final Env env;

  Config({
    required this.env,
  });
}
