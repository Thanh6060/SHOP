import 'package:get/get.dart';
import 'package:shop/features/shop/controllers/cart/cart_controller.dart';
import 'package:shop/features/shop/controllers/product/image_controller.dart';
import 'package:shop/features/shop/models/product_model.dart';
import 'package:shop/features/shop/models/product_variation_model.dart';

class VariationController extends GetxController{
  static VariationController get instance => Get.find();
// variables
  RxMap selectedAttributes = {}.obs;
  Rx<ProductVariationModel> selectedVariation = ProductVariationModel.empty().obs;
  RxString variationStockStatus = ''.obs;

  void onAttributeSelected(ProductModel product,attributeName,attributeValue){
    Map<String, dynamic> selectedAttributes = Map<String, dynamic>.from(this.selectedAttributes);
    selectedAttributes[attributeName] = attributeValue;
    this.selectedAttributes[attributeName] = attributeValue;// select att 'colors'

    ProductVariationModel selectedVariation = product.productVariations!.firstWhere((variation)=>isSameAttributeValues(variation.attributeValues, selectedAttributes),orElse: ()=>ProductVariationModel.empty());

    if(selectedVariation.image.isNotEmpty){
      ImageController.instance.selectedProductImage.value = selectedVariation.image;
    }
    if(selectedVariation.id.isNotEmpty){
      final cartController = CartController.instance;
      cartController.productQuantityInCart.value = cartController.getVariationQuantityInCart(product.id, selectedVariation.id);
    }
    

    this.selectedVariation(selectedVariation);
    
  }
  bool isSameAttributeValues(Map<String,dynamic> variationAttributes, Map<String,dynamic> selectedAttributes){
    if(variationAttributes.length != selectedAttributes.length) return false;
    for (final key in variationAttributes.keys){
      if(variationAttributes[key] != selectedAttributes[key]) return false  ;
      
    }
    return true;
  }
  Set<String?> getAttributesAvailableInVariation(List<ProductVariationModel> variations, String attributeName){
    final availableAttributesValue = variations.where((variation)=>
        variation.attributeValues[attributeName]!.isNotEmpty &&
        variation.attributeValues[attributeName] !=null &&
        variation.stock > 0 )
        .map((variation)=>variation.attributeValues[attributeName])
        .toSet();

    return availableAttributesValue;
  }

  String getVariationPrice(){
    return (selectedVariation.value.salePrice > 0 ? selectedVariation.value.salePrice : selectedVariation.value.price).toStringAsFixed(0);
  }
  void getProductVariationStockStatus(){
    variationStockStatus.value = selectedVariation.value.stock > 0 ? 'In Stock' : ' Out of Stock';
  }
  void resetSelectedAttributes(){
    selectedAttributes.clear();
    variationStockStatus.value = '';
    selectedVariation.value = ProductVariationModel.empty();
  }

}