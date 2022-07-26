import 'package:flutter/material.dart';
import 'package:flutter_feed/pages/splashscreen/splashscreen_page_controller.dart';
import 'package:flutter_feed/pages/splashscreen/widget/loader.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SplashscreenPage extends ConsumerWidget {
  const SplashscreenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(splashscreenPageController);

    return const Scaffold(
      body: Loader(),
    );
  }
}
