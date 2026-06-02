


import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shop/data/responsibilities/authentication_repo.dart';
import 'package:shop/features/shop/controllers/product/variation_controller.dart';
import 'package:shop/features/shop/models/cart_item_model.dart';
import 'package:shop/features/shop/models/product_model.dart';
import 'package:shop/features/shop/models/product_variation_model.dart';
import 'package:shop/features/shop/screens/checkout/checkout.dart';
import 'package:shop/utils/constants/enums.dart';
import 'package:shop/utils/popups/snackbar_helpers.dart';

import '../../../../utils/constants/keys.dart';

class CartController  extends GetxController{
  static CartController get instance => Get.find();
  final _storage = GetStorage(AuthenticationRepo.instance.currentUser!.uid);
  RxInt noOfCartItem = 0.obs;
  RxDouble totalCartPrice = 0.0.obs;
  RxInt productQuantityInCart = 0.obs;
  RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  final variationController = VariationController.instance;

  CartController(){
    localCartItem();
  }

  void localCartItem(){
    List<dynamic>? storageCartItem = _storage.read(UKeys.cartItemsKey);
    if(storageCartItem != null){
      cartItems.assignAll(storageCartItem.map((item)=> CartItemModel.fromJson(item as Map<String, dynamic>)));
      updateCartToTotals()  ;
    }
  }

  Future<void> checkout(ProductModel product) async{

    cartItems.clear();

    productQuantityInCart.value = 1;

   // if(productQuantityInCart < 1){
   //   USnackBarHelpers.customToast(message: 'Select Quantity');
   //   return;
  //  }
    if(product.productType == ProductType.variable.toString() && variationController.selectedVariation.value.id.isEmpty){
      USnackBarHelpers.customToast(message: "Select Variation");
      return;

    }
    // out of stock
    if(product.productType == ProductType.variable.toString()) {
      if (variationController.selectedVariation.value.stock < 1) {
        USnackBarHelpers.warningSnackBar(
            title: 'Out of Stock', message: 'This variation is out of stock');
        return;
      }
    }  else{
        if(product.stock<1){
          USnackBarHelpers.warningSnackBar(title: 'Out of Stock',message: 'This product is out of stock');
        }
      }
      CartItemModel selectedCartItem =  convertToCartItem(product, productQuantityInCart.value);

     // int index = cartItems.indexWhere((cartItem)=>cartItem.productId == selectedCartItem.productId && selectedCartItem.variationId == cartItem.variationId);
    //  if(index>0){
      //  cartItems[index].quantity = selectedCartItem.quantity;

    //  }else {
        cartItems.add(selectedCartItem);
    //  }
      updateCartToTotals();

    //  USnackBarHelpers.customToast(message: 'Your product has been added to the cart');

      await Get.to(()=>CheckoutScreen());

      localCartItem();

  }
  void addOneToCart(CartItemModel item){
  int index  = cartItems.indexWhere((cartItem)=> item.productId == cartItem.productId && item.variationId==cartItem.variationId);

  if(index>=0){
    cartItems[index].quantity += 1;
    }else{
    cartItems.add(item);

  }
  updateCart();
  }
  void removeOneFromCart(CartItemModel item){
    int index  = cartItems.indexWhere((cartItem)=> item.productId == cartItem.productId && item.variationId==cartItem.variationId);

    if(index>=0){
      if(cartItems[index].quantity>1){
        cartItems[index].quantity -=1;
      }else {
        cartItems[index].quantity == 1? removeFromCartDialog(index) : cartItems.removeAt(index);
      }
    }
    updateCart();
  }

  void removeFromCartDialog(int index){
  Get.defaultDialog(
    title: 'Remove Product',
    middleText: 'Are you sure want to remove this product?',
    onConfirm: (){
      cartItems.removeAt(index);
      updateCart();
      USnackBarHelpers.customToast(message: 'Product remove from the cart');
      Get.back();
    },
    onCancel: (){},
  );

  }
  int getProductQuantityInCart(String productId){
    final itemQuantity = cartItems.where((cartItem)=> cartItem.productId == productId).fold(
        0, (previousValue,cartItem)=> previousValue + cartItem.quantity
    );
    return itemQuantity;
  }
  int getVariationQuantityInCart(String productId, String variationId){
    CartItemModel cartItemModel = cartItems.firstWhere((item)=>item.productId == productId && item.variationId == variationId,
    orElse: ()=> CartItemModel.empty());
    return cartItemModel.quantity;
  }
   

  void updateCart(){
    updateCartToTotals();
    saveCartItem();
    cartItems.refresh();

  }
  void saveCartItem(){
    List<Map<String,dynamic>> cartItemsList = cartItems.map((item)=>item.toJson()).toList();
  
    _storage.write(UKeys.cartItemsKey, cartItemsList);
  }
  void updateCartToTotals(){
    double calculateTotalPrice = 0.0;
    int calculateNoOfItem = 0;
    for(final item in cartItems) {
      calculateTotalPrice += (item.price) * item.quantity.toDouble();
      calculateNoOfItem += item.quantity;

    }
    totalCartPrice.value = calculateTotalPrice;
    noOfCartItem.value = calculateNoOfItem;
  }

  CartItemModel convertToCartItem(ProductModel product, int quantity){
    if(product.productType == ProductType.single.toString()){
      variationController.resetSelectedAttributes();
    }
    ProductVariationModel variation = variationController.selectedVariation.value;

    bool isVariation = variation.id.isNotEmpty;
    String image = isVariation ? variation.image : product.thumbnail;
    double price = isVariation ? variation.salePrice > 0.0 ? variation.salePrice : variation.price :
    product.salePrice > 0.0 ? product.salePrice : product.price;
    return CartItemModel(
        productId: product.id,
        quantity: quantity,
        title: product.title,
        brandName: product.brand!= null ? product.brand!.name : '',
        image: image,
        price: price,
        selectedVariation: isVariation ? variation.attributeValues : null,
        variationId: variation.id
    );

  }
  void updateAlreadyAddedProductCount(ProductModel product){
    if(product.productType == ProductType.single.toString()){
      productQuantityInCart.value = getProductQuantityInCart(product.id);
    }else {
      String variationId = variationController.selectedVariation.value.id;
      if(variationId.isNotEmpty){
        productQuantityInCart.value = getVariationQuantityInCart(product.id, variationId);

      }else {
        productQuantityInCart.value = 0;
      }
    }
  }

  void clearCart(){
    productQuantityInCart.value = 0;
    cartItems.clear();
    updateCart();
  }



}