
import 'package:baichday/screens/category/product_by_category_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../provider/category_provider.dart';
import '../../services/auth.dart';
import 'category_list_screen.dart';
import 'subcategory_screen.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({Key? key}) : super(key: key);

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  Auth authService = Auth();

  @override
  Widget build(BuildContext context) {
    var categoryProvider = Provider.of<CategoryProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
      child: FutureBuilder<QuerySnapshot>(
        future: authService.categories
            .orderBy('category_name', descending: false)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container();
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }

          return SizedBox(
              height: 140,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Shop for',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () => Navigator.pushNamed(
                              context, CategoryListScreen.screenId),
                          child: Row(
                            children: [
                              Text(
                                'See All',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: linkColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Icon(
                              //   Icons.arrow_forward_ios,
                              //   size: 14,
                              //   color: linkColor,
                              // )
                            ],
                          ),
                        )
                      ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: ((context, index) {
                          var doc = snapshot.data!.docs[index];
                          return InkWell(
                            onTap: () {
                              categoryProvider
                                  .setCategory(doc['category_name']);
                              categoryProvider.setCategorySnapshot(doc);
                              if (doc['subcategory'] == null) {
                                Navigator.of(context)
                                    .pushNamed(ProductByCategory.screenId);
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) =>
                                            SubCategoryScreen(doc: doc)));
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.network(
                                    doc['img'],
                                    height: 50,
                                    width: 50,
                                  ),
                                  const SizedBox(
                                    height: 15,

                                  ),
                                  Flexible(
                                    child: Text(
                                      doc['category_name'],
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: blackColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        })),
                  )
                ],
              ));
        },
      ),
    );
  }
}
