


import 'package:get/get.dart';
import 'package:shop/features/authentication/screens/forgot_password/forgot_password.dart';
import 'package:shop/routes/routes.dart';


import '../features/authentication/screens/login/login.dart';
import '../features/authentication/screens/onboarding/onboarding.dart';
import '../features/authentication/screens/signup/signup.dart';
import '../features/authentication/screens/signup/verify_email.dart';
import '../features/personalization/screen/address/address.dart';
import '../features/personalization/screen/edit_profile/edit_profile_screen.dart';
import '../features/personalization/screen/profile/profile.dart';
import '../features/shop/screens/cart/cart.dart';
import '../features/shop/screens/checkout/checkout.dart';
import '../features/shop/screens/order/order.dart';
import '../features/shop/screens/store/store.dart';
import '../features/shop/screens/wishlist/wishlist.dart';
import '../loading.dart';


class UAppRoutes{

  static final screens = [
    GetPage(name: URoutes.home, page: () => const LoadingScreen()),
    GetPage(name: URoutes.store, page: () => const StoreScreen(),),
    GetPage(name: URoutes.wishlist, page: () => const WishlistScreen(),),
    GetPage(name: URoutes.profile, page: () => const ProfileScreen(),),
    GetPage(name: URoutes.order, page: () => const OrderScreen(),),
    GetPage(name: URoutes.checkout, page: () => const CheckoutScreen(),),
    GetPage(name: URoutes.cart, page: () => const CartScreen(),),
    GetPage(name: URoutes.editProfile, page: () => const EditProfileScreen(),),
    GetPage(name: URoutes.userAddress, page: () => const AddressScreen(),),
    GetPage(name: URoutes.signup, page: () => const SignupScreen(),),
    GetPage(name: URoutes.verifyEmail, page: () => const VerifyEmailScreen(),),
    GetPage(name: URoutes.signIn, page: () => const LoginScreen(),),
    GetPage(name: URoutes.forgetPassword, page: () => const ForgotPasswordScreen(),),
    GetPage(name: URoutes.onBoarding, page: () => const OnboardingScreen(),),
  ];
}