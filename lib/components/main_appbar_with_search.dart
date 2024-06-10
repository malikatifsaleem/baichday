
import 'package:baichday/Notification/NotificationPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../Notification/NotificationList.dart';
import '../constants/colors.dart';
import '../constants/widgets.dart';
import '../models/product_model.dart';
import '../provider/product_provider.dart';
import '../screens/location_screen.dart';
import '../services/auth.dart';
import '../services/search.dart';
import '../services/user.dart';
import '../utils.dart';

class MainAppBarWithSearch extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  const MainAppBarWithSearch({
    required this.controller,
    required this.focusNode,
    Key? key,
  }) : super(key: key);

  @override
  State<MainAppBarWithSearch> createState() => _MainAppBarWithSearchState();
}

class _MainAppBarWithSearchState extends State<MainAppBarWithSearch> {
  static List<Products> products = [];
  Auth authService = Auth();
  Search searchService = Search();
  String address = '';
  UserService firebaseUser = UserService();
  DocumentSnapshot? sellerDetails;
  @override
  void initState() {
    authService.products.get().then(((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        products.add(Products(
            document: doc,
            title: doc['title'],
            description: doc['description'],
            category: doc['category'],
            subcategory: doc['subcategory'],
            price: doc['price'],
            postDate: doc['posted_at']));
        getSellerAddress(doc['seller_uid']);
      });
    }));
    super.initState();
  }

  getSellerAddress(selledId) {
    firebaseUser.getSellerData(selledId).then((value) => {
          setState(() {
            address = value['address'];
            sellerDetails = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProductProvider>(context);
    return SafeArea(
      child: Container(
        height: 150,
        color: Colors.transparent,
        padding: const EdgeInsets.only(left: 15,right: 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(LocationScreen.screenId);
                    },
                    child: Center(child: lcoationAutoFetchBar(context)),
                  ),
                  // Text(
                  //   "Bechdo",
                  //   style: TextStyle(
                  //     color: blackColor,
                  //     fontSize: 15,
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     searchService.searchQueryPage(
                  //         context: context,
                  //         products: products,
                  //         address: address,
                  //         sellerDetails: sellerDetails,
                  //         provider: provider);
                  //   },
                  //   child: Container(
                  //     padding: const EdgeInsets.all(10),
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(50),
                  //       color: disabledColor.withOpacity(0.3),
                  //     ),
                  //     child: const Icon(
                  //       Icons.search,
                  //     ),
                  //   ),
                  // ),
                 InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationList()));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        // color: disabledColor.withOpacity(0.3),
                      ),
                      child: const Icon(
                        Icons.notifications,
                        size: 23,
                      ),
                    ),
                  )

                ],
              ),
              // SizedBox(height: 10,),
              Container(
                padding: const EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: disabledColor.withOpacity(0.3),
                ),

                height: 40,
                child: InkWell(
                  onTap: () {
                    searchService.searchQueryPage(
                        context: context,
                        products: products,
                        address: address,
                        sellerDetails: sellerDetails,
                        provider: provider);
                  },
                  child: TextField(
                    enabled: false,
                    cursorColor: secondaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: Colors.black),
                      hintText: "Search cars, mobiles, properties...",
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black54.withOpacity(0.4),
                      ),
                    ),
                                    ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  lcoationAutoFetchBar(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    User? user = FirebaseAuth.instance.currentUser;
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(user!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return customSnackBar(
              context: context, content: "Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return customSnackBar(
              context: context, content: "Addrress not selected");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
          snapshot.data!.data() as Map<String, dynamic>;
          if (data['address'] == null) {
            Position? position = data['location'];
            getFetchedAddress(context, position).then((location) {
              return locationTextWidget(
                location: location,
              );
            });
          } else {
            return locationTextWidget(location: data['address']);
          }
          return locationTextWidget(location: 'Update Location');
        }
        return locationTextWidget(location: 'Fetching location');
      },
    );
  }
}

class locationTextWidget extends StatelessWidget {
  final String? location;
  const locationTextWidget({Key? key, required this.location})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.location_on,
          size: 18,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          location ?? '',
          style: TextStyle(
            color: blackColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
