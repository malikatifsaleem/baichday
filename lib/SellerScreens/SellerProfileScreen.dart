import 'package:baichday/constants/colors.dart';
import 'package:baichday/constants/widgets.dart';
import 'package:baichday/screens/Edit%20Profile.dart';
import 'package:baichday/screens/auth/login_screen.dart';
import 'package:baichday/screens/main_navigatiion_screen.dart';
import 'package:baichday/screens/welcome_screen.dart';
import 'package:baichday/services/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../SellerScreens/seller_main_navigatiion_screen.dart';

class SellerProfilePage extends StatefulWidget {
  static const screenId = 'seller_profile_screen';
  const SellerProfilePage({Key? key}) : super(key: key);

  @override
  State<SellerProfilePage> createState() => _SellerProfilePageState();
}

class _SellerProfilePageState extends State<SellerProfilePage> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  UserService firebaseUser = UserService();
  bool isSeller = true; // Variable to manage the state of the switch

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Seller Profile'),
      ),
      body: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: settingLabel.length + 1, // Add one for the switch button card
        itemBuilder: (context, index) {
          if (index == 0) {
            return Card(
              elevation: 8.0,
              margin: EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Icon(
                    Icons.credit_card,
                    color: Colors.teal,
                  ),
                  title: Text(
                    "Seller mode",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Switch(
                    value: isSeller,
                    onChanged: (value) {
                      setState(() {
                        isSeller = value;
                        if (value) {
                          // Navigate to seller dashboard
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SellerMainNavigationScreen()),
                          );
                        } else {
                          // Navigate to buyer dashboard
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MainNavigationScreen()),
                          );
                        }
                      });
                    },
                    activeTrackColor: Colors.teal,
                    activeColor: Colors.grey,
                  ),
                ),
              ),
            );
          } else {
            final actualIndex = index - 1; // Adjust index to account for the switch button card
            return ListTile(
              title: Text(
                settingLabel[actualIndex],
                style: TextStyle(
                  fontSize: 16.0,
                  // color: actualIndex % 4 == 0 ? kDarkColor : kDarkColor.withOpacity(0.6),
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 20.0,
                // color: actualIndex % 4 == 0 ? kDarkColor : kDarkColor.withOpacity(0.6),
              ),
              onTap: () => this.setState(() {
                switch (settingLabel[actualIndex]) {
                  case 'Account':
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
                    break;
                  case 'Logout':
                    loadingDialogBox(context, 'Signing Out');
                    googleSignIn.signOut();
                    FirebaseAuth.instance.signOut().then((value) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          LoginScreen.screenId, (route) => false);
                    });
                    break;
                }
              }),
            );
          }
        },
        separatorBuilder: (context, index) {
          return index == 0
              ? SizedBox.shrink() // No separator for the switch button card
              : (settingLabel[index - 1] == 'Email' || settingLabel[index - 1] == 'Credit Card')
              ? kSmallDivider
              : Divider();
        },
      ),
    );
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();

  snackBarMsg(BuildContext context, String msg) {
    var sb = SnackBar(
      elevation: kRadius,
      content: Text(msg),
      duration: Duration(seconds: 2),
      action: SnackBarAction(
        // textColor: kWhiteColor,
        label: 'OK',
        onPressed: () {},
      ),
    );
    // scaffoldKey.currentState.showSnackBar(sb);
  }
}
