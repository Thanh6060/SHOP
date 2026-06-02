
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../controllers/banner/banner_controller.dart';

class BannersDotNavigation extends StatelessWidget {
  const BannersDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final bannerController = Get.find<BannerController>();
    return Obx(
      () => SmoothPageIndicator(
        count: bannerController.banners.take(5).length,
        effect: ExpandingDotsEffect(
          dotHeight: 6.0,
        ),controller: PageController(initialPage: bannerController.currentIndex.value),
      ),
    );
  }
}
