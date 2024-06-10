import 'package:baichday/constants/colors.dart';
import 'package:baichday/screens/category/category_list_screen.dart';
import 'package:baichday/screens/chat/chat_screen.dart';
import 'package:baichday/screens/home_screen.dart';
import 'package:baichday/screens/post/my_post_screen.dart';
import 'package:baichday/screens/profile_screen.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainNavigationScreen extends StatefulWidget {
  static const screenId = 'main_nav_screen';
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  List pages = [
    const HomeScreen(),
    const ChatScreen(),
    // const CategoryListScreen(isForForm: true),
    const MyPostScreen(),
    const ProfileScreen(),
  ];
  PageController controller = PageController();
  int _index = 0;

  _bottomNavigationBar() {
    return Container(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        // margin: EdgeInsets.zero,
        // paddingR: EdgeInsets.zero,
        selectedItemColor: secondaryColor,
        currentIndex: _index,
        // dotIndicatorColor: Colors.transparent,
        unselectedItemColor: Colors.teal,
        // enablePaddingAnimation: true,
        // enableFloatingNavBar: false,
        onTap: (index) {
          setState(() {
            _index = index;
          });
          controller.jumpToPage(index);
        },
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Container(
              decoration: BoxDecoration(
                  color: _index == 0 ? Color(0xFF28B391) : Colors.teal,
                  borderRadius: BorderRadius.circular(40)),
              padding: const EdgeInsets.all(10),
              child: Icon(
                Icons.home,
                color: _index == 0 ? Colors.white : Colors.white,
              ),
            ),
          ),
          BottomNavigationBarItem(
            label: 'Chat',
            icon: Container(
              decoration: BoxDecoration(
                  color: _index == 1 ?Color(0xFF28B391) : Colors.teal,
                  borderRadius: BorderRadius.circular(40)),
              padding: const EdgeInsets.all(10),
              child: Icon(
                Icons.messenger_outlined,
                color: _index == 1 ? Colors.white : Colors.white
              ),
            ),
          ),
          // BottomNavigationBarItem(
          //   label: 'Sell',
          //   icon: Container(
          //     decoration: BoxDecoration(
          //         color: _index == 2 ?Color(0xFF28B391) : Colors.teal,
          //         borderRadius: BorderRadius.circular(40)),
          //     padding: const EdgeInsets.all(10),
          //     child: Icon(
          //       Icons.add,
          //       color: _index == 2 ? Colors.white : Colors.white
          //     ),
          //   ),
          // ),
          BottomNavigationBarItem(
            label: 'Favorites',
            icon: Container(
              decoration: BoxDecoration(
                  color: _index == 3 ? Color(0xFF28B391) : Colors.teal,
                  borderRadius: BorderRadius.circular(40)),
              padding: const EdgeInsets.all(10),
              child: Icon(
                _index == 3 ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                color: _index == 3 ? Colors.white : Colors.white
              ),
            ),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Container(
              decoration: BoxDecoration(
                  color: _index == 4 ? Color(0xFF28B391) : Colors.teal,
                  borderRadius: BorderRadius.circular(40)),
              padding: const EdgeInsets.all(10),
              child: Icon(

                // semanticLabel:"Profile",
                Icons.person,
                color: _index == 4 ? Colors.white : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: PageView.builder(
            itemCount: pages.length,
            controller: controller,
            onPageChanged: (page) {
              setState(() {
                _index = page;
              });
            },
            itemBuilder: (context, position) {
              return pages[position];
            }),
        bottomNavigationBar: _bottomNavigationBar());
  }
}
