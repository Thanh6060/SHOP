import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';
import 'package:shop/data/responsibilities/banner/banner_repo.dart';
import 'package:shop/features/shop/models/banners_model.dart';
import 'package:shop/utils/popups/snackbar_helpers.dart';

class BannerController  extends GetxController{
  static BannerController get instance => Get.find();
  final _repository = Get.put(BannerRepo());
  RxList<BannerModel> banners = <BannerModel>[].obs;
  RxBool isLoading = false.obs;
  final carouselController = CarouselSliderController();
  RxInt currentIndex = 0.obs;


  @override
  void onInit() {
fetchBanners();
    super.onInit();
  }
  void  onPageChanged(int index){
    currentIndex.value = index;
  }

  Future<void> fetchBanners() async{
    try {
      isLoading.value = true;
      List<BannerModel> activeBanners = await _repository.fetchActiveBanners();

      banners.assignAll(activeBanners);

    }catch(e) {
      USnackBarHelpers.errorSnackBar(title: 'Failed',message: e.toString());

    }finally {
      isLoading.value = false;
    }
  }
}