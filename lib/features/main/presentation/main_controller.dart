import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  late PageController pageController;
  late ScrollController scrollController;

  @override
  void onInit() {
    super.onInit();

    pageController = PageController(initialPage: 2);
    scrollController = ScrollController();
    scrollController.addListener(() {
      // If user is at the very top and scrolling up
      if (scrollController.position.pixels <= 0 &&
          scrollController.position.userScrollDirection ==
              ScrollDirection.forward) {
        pageController.animateToPage(
          2,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    pageController.dispose();
    scrollController.dispose();
  }
}
