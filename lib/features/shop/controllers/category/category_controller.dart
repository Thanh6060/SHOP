import 'package:get/get.dart';
import 'package:shop/data/responsibilities/category/category_repo.dart';
import 'package:shop/data/responsibilities/product/product_repo.dart';
import 'package:shop/features/shop/models/category_model.dart';
import 'package:shop/features/shop/models/product_model.dart';
import 'package:shop/utils/popups/snackbar_helpers.dart';

class CategoryController extends GetxController{
  static CategoryController get instance => Get.find();
  final _repository = Get.put(CategoryRepo());
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> featuredCategories = <CategoryModel>[].obs;

  RxBool isCategoriesLoading = false.obs;

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  Future<void> fetchCategories() async{
    try{

      isCategoriesLoading.value = true;

      List<CategoryModel> categories = await _repository.getAllCategories();

      allCategories.assignAll(categories);
      featuredCategories.assignAll(
          categories.where((category) =>
          category.isFeatured &&
              (category.parentId == null || category.parentId!.trim().isEmpty)
          ).toList()
      );


    }catch(e){
      USnackBarHelpers.errorSnackBar(title: 'Failed',message: e.toString());
    }finally{
      isCategoriesLoading.value = false;
    }
  }

  Future<List<ProductModel>> getCategoryProducts({required String categoryId, int limit = 4}) async{
    try{
      final products = await ProductRepo.instance.getProductsForCategory(categoryId: categoryId,limit: limit);


      return products;

    }catch(e){
      USnackBarHelpers.errorSnackBar(title: 'Failed',message: e.toString());
      return [];
    }
  }

  Future<List<CategoryModel>> getSubCategories(String categoryId) async{
    try{
      final subCategories = await _repository.getSubCategories(categoryId);
      return subCategories;
      
    }catch(e){
      USnackBarHelpers.errorSnackBar(title: 'Failed',message: e.toString());
          return [];
    }
  }
}