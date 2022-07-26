import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

final deviceIdProvider = Provider<String>((ref) => const Uuid().v4());
