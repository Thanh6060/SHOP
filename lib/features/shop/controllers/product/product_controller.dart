


import 'package:get/get.dart';
import 'package:shop/data/responsibilities/product/product_repo.dart';
import 'package:shop/data/services/branch_services.dart';
import 'package:shop/features/shop/models/product_model.dart';
import 'package:shop/utils/constants/enums.dart';
import 'package:shop/utils/constants/texts.dart';
import 'package:shop/utils/helpers/network_manager.dart';
import 'package:shop/utils/popups/snackbar_helpers.dart';

class ProductController extends GetxController{
  static ProductController get instance => Get.find();
  final _repository  = Get.put(ProductRepo());
  RxList<ProductModel> featuredProducts = <ProductModel>[].obs;
  RxBool isLoading  = false.obs;

  @override
  void onInit() {

    getFeaturedProduct();
    super.onInit();
  }

  Future<ProductModel> getSingleProducts(String productId) async{
    try {
      ProductModel product = await _repository.fetchSingleProduct(productId);
      return product;

    }catch(e){

      USnackBarHelpers.errorSnackBar(title: 'Failed',message: e.toString());

      return ProductModel.empty();
    }
  }



  Future<List<ProductModel>> getAllProducts() async{
    try {
      List<ProductModel> products = await _repository.fetchAllProduct();
      return products;

    }catch(e){
      USnackBarHelpers.errorSnackBar(title: 'Failed',message: e.toString());
      return [];
    }
  }


  Future<void> getFeaturedProduct() async{
    try{
      isLoading.value = true;
      List<ProductModel> featuredProducts = await _repository.fetchFeaturedProducts();

      this.featuredProducts.assignAll(featuredProducts);

    }catch(e){
      USnackBarHelpers.errorSnackBar(title: 'Failed',message: e.toString());
    }finally{
      isLoading.value = false;
    }
  }
  Future<List<ProductModel>> getAllFeaturedProduct() async {
    try {
      List<ProductModel> featuredProducts = await _repository
          .fetchAllFeaturedProducts();

      return featuredProducts;
    } catch (e) {
      USnackBarHelpers.errorSnackBar(title: 'Failed', message: e.toString());
    return [];
    }
  }
  String? calculateSalePercentage(double originalPrice, double? salePrice){
    if(salePrice == null || salePrice <= 0.0){
      return null;
    }
    if(originalPrice <=0.0) return null;
    double percentage = ((originalPrice - salePrice) / originalPrice) * 100;
    return percentage.toStringAsFixed(1);
  }
  String getProductPrice(ProductModel product){
    double smallestPrice = double.infinity;
    double largestPrice = 0.0;
    if(product.productType == ProductType.single.toString()){
      return product.salePrice > 0 ? product.salePrice.toString() : product.price.toString();
    }
    else{
      for(final variation in product.productVariations!){
        double variationPrice = product.salePrice > 0 ? variation.salePrice : variation.price;
        if(variationPrice > largestPrice){
          largestPrice = variationPrice;
        }
        if(variationPrice<smallestPrice){
          smallestPrice = variationPrice;
        }

      }
      if(smallestPrice.isEqual(largestPrice)){
        return largestPrice.toStringAsFixed(0);
      }else {
        return '${largestPrice.toStringAsFixed(0)} - ${UTexts.currency}${smallestPrice.toStringAsFixed(0)}';
      }
    }
  }
  String getProductStockStatus(int stock) {
    return stock > 0 ? ' In Stock' : 'Out of Stock';
  }
  Future<void> shareProduct(ProductModel product) async{

    try{
      bool isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        USnackBarHelpers.errorSnackBar(title: 'No Internet', message: 'Please check your internet');
        return;
      }
      BranchServices.instance.createLink(product);

    }catch(e){
      USnackBarHelpers.errorSnackBar(title: 'Failed',message: e.toString());
    }
  }
}