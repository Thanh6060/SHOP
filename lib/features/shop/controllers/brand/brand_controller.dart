import 'package:get/get.dart';
import 'package:shop/data/responsibilities/brand/brand_repo.dart';
import 'package:shop/data/responsibilities/product/product_repo.dart';
import 'package:shop/features/shop/models/brand_model.dart';
import 'package:shop/features/shop/models/product_model.dart';
import 'package:shop/utils/popups/snackbar_helpers.dart';

class BrandController extends GetxController{
  static BrandController get instance => Get.find();
  final _repository = Get.put(BrandRepo());
  RxList<BrandModel> allBrands = <BrandModel>[].obs;
  RxList<BrandModel> featuredBrands = <BrandModel>[].obs;
  RxBool isLoading = false.obs;


  @override
  void onInit() {
    // TODO: implement onInit
    getBrands();
    super.onInit();
  }

  Future<void> getBrands() async{
    try {
      isLoading.value = true;

        List<BrandModel> allBrands = await _repository.fetchBrands();
        this.allBrands.assignAll(allBrands);
        featuredBrands.assignAll(allBrands.where((brand)=>brand.isFeatured ?? false).toList());

    }catch(e){
      USnackBarHelpers.errorSnackBar(title: 'Failed', message: e.toString());
    }finally{
      isLoading.value = false;
    }
  }

  Future<List<ProductModel>> getBrandProducts(String brandId,{int limit = -1}) async{
    try{
      List<ProductModel> products = await ProductRepo.instance.getProductsForBrand(brandId: brandId,limit: limit);
      return products;

    }catch(e){
      USnackBarHelpers.errorSnackBar(title: 'Failed', message: e.toString());
      return [];
    }
  }

  Future<List<BrandModel>> getBrandsForCategory(String categoryId) async{
    try{
      final brands = await _repository.fetchBrandsForCategory(categoryId);
      return brands;
    }catch(e)
    {
      USnackBarHelpers.errorSnackBar(title: 'Failed',message: e.toString());
      return [];
    }
  }
}