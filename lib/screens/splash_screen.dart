import 'dart:async';

import 'package:baichday/screens/auth/login_screen.dart';
import 'package:baichday/screens/welcome_screen.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../constants/colors.dart';
import '../services/auth.dart';
import 'main_navigatiion_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String screenId = 'splash_screen';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  int loadingProgress = 0;

  Auth authService = Auth();
  @override
  void initState() {
    startLoadingAnimation();
    super.initState();
  }

  permissionBasedNavigationFunc() {
    Timer(const Duration(seconds: 4), () async {
      FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        if (user == null) {
          Navigator.pushReplacementNamed(context, LoginScreen.screenId);
        } else {
          Navigator.pushReplacementNamed(
              context, MainNavigationScreen.screenId);
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Color(0xfff4f4f4),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "F-17 Islamabad",
              style:   TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)
              ,
            ),
            SizedBox(height: size.height * 0.03),
            DotsIndicator(
              dotsCount: 4,
              mainAxisSize: MainAxisSize.min,
              position: loadingProgress,
              decorator: const DotsDecorator(
                color: Color(0xffc9e1b9),
                activeColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startLoadingAnimation() {
    Future.delayed(const Duration(milliseconds: 700), () {
      setState(() {
        if (loadingProgress == 3) {
          permissionBasedNavigationFunc();
        } else {
          loadingProgress = (loadingProgress + 1) % (4);
          startLoadingAnimation();
        }
      });
    });
  }
}

// class _SplashScreenState extends State<SplashScreen> {
//   Auth authService = Auth();
//   @override
//   void initState() {
//     permissionBasedNavigationFunc();
//     super.initState();
//   }
//
//   permissionBasedNavigationFunc() {
//     Timer(const Duration(seconds: 4), () async {
//       FirebaseAuth.instance.authStateChanges().listen((User? user) async {
//         if (user == null) {
//           Navigator.pushReplacementNamed(context, LoginScreen.screenId);
//         } else {
//           Navigator.pushReplacementNamed(
//               context, MainNavigationScreen.screenId);
//         }
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             width: MediaQuery.of(context).size.width,
//             margin: const EdgeInsets.only(top: 250),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//
//                 // Text(
//                 //   'Bechdo',
//                 //   style: TextStyle(
//                 //       color: secondaryColor,
//                 //       fontWeight: FontWeight.bold,
//                 //       fontSize: 30),
//                 // ),
//                 AnimatedTextKit(
//                   animatedTexts: [
//                     ScaleAnimatedText('Bechdo',textStyle:  TextStyle(
//                         color: secondaryColor,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 30),duration: Duration(milliseconds: 3000),),
//                     // WavyAnimatedText('Look at the waves'),
//                   ],
//                   isRepeatingAnimation: true,
//                   onTap: () {
//                     print("Tap Event");
//                   },
//                 ),
//                 Text(
//                   'Sell your un-needs here !',
//                   style: TextStyle(
//                     color: blackColor,
//                     fontSize: 20,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           SizedBox(height: 20,),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 130),
//             height: MediaQuery.of(context).size.height,
//             child: Lottie.asset(
//               "assets/lottie/logo.json",
//               width: MediaQuery.of(context).size.width,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
