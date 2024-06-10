import 'package:baichday/provider/product_provider.dart';
import 'package:baichday/screens/Edit%20Profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../EditAdScreen.dart';
import '../../constants/colors.dart';
import '../../services/user.dart';
import '../chat/user_chat_screen.dart';

class SellerProfileScreen extends StatelessWidget {
  final ProductProvider sellerDetails;

  SellerProfileScreen({Key? key, required this.sellerDetails}) : super(key: key);
  UserService firebaseUser = UserService();

  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Seller Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Seller',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: CircleAvatar(
                backgroundColor: primaryColor,
                radius: 40,
                child: CircleAvatar(
                  backgroundColor: secondaryColor,
                  radius: 37,
                  child: Icon(
                    CupertinoIcons.person,
                    color: whiteColor,
                    size: 40,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Name: ${sellerDetails.sellerDetails!['name']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              'Email: ${sellerDetails.sellerDetails!['email']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            // Text(
            //   'Location: ${sellerDetails.sellerDetails!['location']}',
            //   style: TextStyle(fontSize: 16),
            // ),


          ],
        ),
      ),
      bottomSheet: BottomAppBar(

        child: Padding(
          padding: (productProvider.productData!['seller_uid'] ==
              firebaseUser.user!.uid)
              ? EdgeInsets.zero
              : EdgeInsets.all(8),
          child: (productProvider.productData!['seller_uid'] ==
              firebaseUser.user!.uid)
              ? ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(secondaryColor)),
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EditProfile()));
              },
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.edit,
                      size: 16,
                      color: whiteColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Edit',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    )
                  ],
                ),
              ))
              : Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _createChatRoom(sellerDetails,context);
                  },
                  // style: ElevatedButton.styleFrom(
                  //   primary: secondaryColor,
                  // ),
                  icon: Icon(
                    Icons.chat_bubble,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Chat',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    var phoneNo = Uri.parse(
                        'tel:${sellerDetails.sellerDetails!['mobile']}');
                    await _callLauncher(phoneNo);
                  },
                  // style: ElevatedButton.styleFrom(
                  //   primary: secondaryColor,
                  // ),
                  icon: Icon(
                    Icons.call,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Call',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    var phoneNo = Uri.parse(
                        'tel:${sellerDetails.sellerDetails!['contact_details']['mobile']}');
                    await _callLauncher(phoneNo);
                  },
                  // style: ElevatedButton.styleFrom(
                  //   primary: secondaryColor,
                  // ),
                  icon: Icon(
                    Icons.message,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Message',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
  _createChatRoom(ProductProvider productProvider, BuildContext context) {
    Map product = {
      'product_id': sellerDetails.productData!.id,
      'product_img': sellerDetails.productData!['images'][0],
      'price': sellerDetails.productData!['price'],
      'title': sellerDetails.productData!['title'],
      'seller': sellerDetails.productData!['seller_uid'],
    };
    List<String> users = [
      sellerDetails.sellerDetails!['uid'],
      firebaseUser.user!.uid,
    ];
    String chatroomId =
        '${sellerDetails.sellerDetails!['uid']}.${firebaseUser.user!.uid}${productProvider.productData!.id}';
    Map<String, dynamic> chatData = {
      'users': users,
      'chatroomId': chatroomId,
      'read': false,
      'product': product,
      'lastChat': null,
      'lastChatTime': DateTime.now().microsecondsSinceEpoch,
    };
    firebaseUser.createChatRoom(data: chatData);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => UserChatScreen(
              chatroomId: chatroomId,
            )));
  }
  Future<void> _callLauncher(number) async {
    if (!await launchUrl(number)) {
      throw 'Could not launch $number';
    }
  }
}