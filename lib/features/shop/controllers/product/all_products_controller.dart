import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shop/data/responsibilities/product/product_repo.dart';
import 'package:shop/features/shop/models/product_model.dart';
import 'package:shop/utils/popups/snackbar_helpers.dart';

class AllProductsController  extends GetxController{
  static AllProductsController get instance => Get.find();
  final _repository = ProductRepo.instance;
  final RxString selectedSortOption = 'Name'.obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;
  Future<List<ProductModel>> fetchProductsByQuery(Query? query) async{
    try{
      if(query == null) return [];
      List<ProductModel> products = await _repository.fetchProductsByQuery(query);

      return products;

    }catch(e){

      USnackBarHelpers.errorSnackBar(title: 'Failed',message: e.toString());
      return [];
    }
  }
  void sortProducts(String sortOption){
    selectedSortOption.value = sortOption;
    switch(sortOption){
      case 'Name':
        products.sort((a,b)=> a.title.compareTo(b.title));
        break;
      case 'Lower Price':
        products.sort((a,b)=>a.price.compareTo(b.price));
        break;
      case 'Higher Price':
        products.sort((a,b)=>b.price.compareTo(a.price));
        break;
      case 'Newest':
        products.sort((a,b)=>a.date!.compareTo(b.date!));
        break;
      case 'Sale':
        products.sort((a,b){
          if(b.salePrice > 0){
            return b.salePrice.compareTo(a.salePrice);
          }else if(a.salePrice>0){
            return -1;
          }else {
            return 1;
          }
        });
      default:
    }
  }
  void assignProducts(List<ProductModel> products){
    this.products.assignAll(products);
    sortProducts('Name');
  }
}