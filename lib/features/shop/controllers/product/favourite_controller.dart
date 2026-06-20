import 'dart:convert';


import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shop/data/responsibilities/authentication_repo.dart';
import 'package:shop/data/responsibilities/product/product_repo.dart';
import 'package:shop/features/shop/models/product_model.dart';
import 'package:shop/utils/popups/snackbar_helpers.dart';

class FavouriteController extends GetxController{
  static FavouriteController get instance => Get.find();
  RxMap<String, bool> favourites = <String, bool>{}.obs;
  late GetStorage _storage = GetStorage(AuthenticationRepo.instance.currentUser!.uid);


  @override
  void onInit() {
    final user = AuthenticationRepo.instance.currentUser;

    if (user != null) {
      _storage = GetStorage(user.uid);
      initFavourite();
    }
    super.onInit();
  }
  Future<void> initFavourite() async{
   String? encodedFavourite =  _storage.read('favourite');
   if(encodedFavourite == null) return;
   Map<String, dynamic> storedFavourite =  jsonDecode(encodedFavourite);

   favourites.assignAll(storedFavourite.map((key,value)=> MapEntry(key, value as bool)));
  }

  void toggleFavouriteProduct(String productId){
    if(favourites.containsKey(productId)){

      favourites.remove(productId);
      saveFavouriteToStorage();
      USnackBarHelpers.customToast(message: 'Products has been removed from the Wishlist');
    }else {
      favourites[productId] = true;
      saveFavouriteToStorage();
      USnackBarHelpers.customToast(message: 'Products has been added to the Wishlist');
    }

  }
  void saveFavouriteToStorage(){
    String encodeFavourite = jsonEncode(favourites);
    _storage.write('favourite', encodeFavourite);
  }

  bool  isFavourite(String productId){
    return favourites[productId] ?? false;
  }
  Future<List<ProductModel>> getFavouriteProducts() async{
    final productIds = favourites.keys.toList();
    return await ProductRepo.instance.getFavouriteProducts(productIds);
  }
}