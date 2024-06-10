import 'dart:ui';


import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../components/main_appbar_with_search.dart';
import '../components/product_listing_widget.dart';
import '../constants/colors.dart';
import '../constants/widgets.dart';
import '../provider/category_provider.dart';
import '../utils.dart';
import 'category/category_widget.dart';
import 'location_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String screenId = 'home_screen';
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController searchController;
  late CarouselController _controller;
  int _current = 0;
  late FocusNode searchNode;

  Future<List<String>> downloadBannerImageUrlList() async {
    List<String> bannerUrlList = [];
    final ListResult storageRef =
        await FirebaseStorage.instance.ref().child('banner').listAll();
    List<Reference> bannerRef = storageRef.items;
    await Future.forEach<Reference>(bannerRef, (image) async {
      final String fileUrl = await image.getDownloadURL();
      bannerUrlList.add(fileUrl);
    });
    return bannerUrlList;
  }

  @override
  void initState() {
    searchController = TextEditingController();
    searchNode = FocusNode();
    _controller = CarouselController();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    searchNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: MainAppBarWithSearch(
            controller: searchController, focusNode: searchNode),
      ),
      body: homeBodyWidget(),
    );
  }

  Widget homeBodyWidget() {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Column(
                children: [

                  FutureBuilder(
                    future: downloadBannerImageUrlList(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<String>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          height: 250,

                          child: Center(
                              child: CircularProgressIndicator(
                            color: secondaryColor,
                          )),
                        );
                      } else {
                        if (snapshot.hasError) {
                          return const Text(
                              'Currently facing issue in banner loading');
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 20.0),
                            child: CarouselSlider.builder(
                              itemCount: snapshot.data!.length,
                              options: CarouselOptions(
                                autoPlay: true,
                                viewportFraction: 1.0,
                                  // aspectRatio : 16 / 9
                              ),
                              itemBuilder: (context, index, realIdx) {
                                return CachedNetworkImage(
                                  fit: BoxFit.fitWidth,
                                  imageUrl: snapshot.data![index],
                                );
                              },
                            ),
                          );
                        }
                      }
                    },
                  ),
                  CategoryWidget(),
                ],
              ),
            ),
            ProductListing()
          ],
        ),
      ),
    );
  }
}
