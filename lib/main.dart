
import 'dart:io';

import 'package:baichday/provider/category_provider.dart';
import 'package:baichday/provider/product_provider.dart';
import 'package:baichday/screens/auth/email_verify_screen.dart';
import 'package:baichday/screens/auth/login_screen.dart';
import 'package:baichday/screens/auth/phone_auth_screen.dart';
import 'package:baichday/screens/auth/register_screen.dart';
import 'package:baichday/screens/category/product_by_category_screen.dart';
import 'package:baichday/screens/category/subcategory_screen.dart';
import 'package:baichday/screens/chat/user_chat_screen.dart';
import 'package:baichday/screens/home_screen.dart';
import 'package:baichday/screens/location_screen.dart';
import 'package:baichday/screens/main_navigatiion_screen.dart';
import 'package:baichday/screens/post/my_post_screen.dart';
import 'package:baichday/screens/product/product_details_screen.dart';
import 'package:baichday/screens/profile_screen.dart';
import 'package:baichday/screens/splash_screen.dart';
import 'package:baichday/screens/welcome_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'SellerScreens/SellerProfileScreen.dart';
import 'SellerScreens/seller_main_navigatiion_screen.dart';
import 'constants/colors.dart';
import 'forms/common_form.dart';
import 'forms/sell_car_form.dart';
import 'forms/user_form_review.dart';
import 'screens/auth/reset_password_screen.dart';
import 'screens/category/category_list_screen.dart';
import 'screens/chat/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // await FirebaseAppCheck.instance.activate(
  //   // webProvider: 'recaptcha-v3-site-key',
  // );

  Platform.isAndroid
      ? await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyBz2UaTutgjTzsdb12FzDNQ7y0phL-sRgM',
        appId: '1:159989194373:android:11822ab560718d1bc513ec',
        messagingSenderId: "159989194373",
        projectId: "baichday-3c03e",
        storageBucket: "baichday-3c03e.appspot.com",
      ))
      : await Firebase.initializeApp();
  // await FirebaseAppCheck.instance.activate(
  //   // webRecaptchaSiteKey: 'recaptcha-v3-site-key',
  //   // Set androidProvider to `AndroidProvider.debug`
  //   androidProvider: AndroidProvider.debug,
  // );
  await FirebaseAppCheck.instance
      .activate(
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.appAttest,
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        )
      ],
      child: const Main(),
    ),
  );
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: blackColor,
          backgroundColor: whiteColor,
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: whiteColor,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.screenId,
        routes: {
          SplashScreen.screenId: (context) => const SplashScreen(),
          LoginScreen.screenId: (context) => const LoginScreen(),
          PhoneAuthScreen.screenId: (context) => const PhoneAuthScreen(),
          LocationScreen.screenId: (context) => const LocationScreen(),
          HomeScreen.screenId: (context) => const HomeScreen(),
          WelcomeScreen.screenId: (context) => const WelcomeScreen(),
          RegisterScreen.screenId: (context) => const RegisterScreen(),
          EmailVerifyScreen.screenId: (context) => const EmailVerifyScreen(),
          ResetPasswordScreen.screenId: (context) =>
              const ResetPasswordScreen(),
          CategoryListScreen.screenId: (context) => const CategoryListScreen(),
          SubCategoryScreen.screenId: (context) => const SubCategoryScreen(),
          SellerMainNavigationScreen.screenId: (context) =>
          const SellerMainNavigationScreen(),
          MainNavigationScreen.screenId: (context) =>
              const MainNavigationScreen(),
          ChatScreen.screenId: (context) => const ChatScreen(),
          MyPostScreen.screenId: (context) => const MyPostScreen(),
          SellerProfilePage.screenId: (context) => const SellerProfilePage(),

          ProfileScreen.screenId: (context) => const ProfileScreen(),
          SellCarForm.screenId: (context) => const SellCarForm(),
          UserFormReview.screenId: (context) => const UserFormReview(),
          CommonForm.screenId: (context) => const CommonForm(),
          ProductDetail.screenId: (context) => const ProductDetail(),
          ProductByCategory.screenId: (context) => const ProductByCategory(),
          UserChatScreen.screenId: (context) => const UserChatScreen(),
        });
  }
}
