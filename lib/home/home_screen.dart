import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_tiktok/home/following/followings_video_screen.dart';
import 'package:flutter_tiktok/home/for_you/for_you_video_screen.dart';
import 'package:flutter_tiktok/home/profile/profile_screen.dart';
import 'package:flutter_tiktok/home/search/search_scareen.dart';
import 'package:flutter_tiktok/home/upload_video/upload_custom_icon.dart';
import 'package:flutter_tiktok/home/upload_video/upload_video_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int screenIndex = 0;
  List screensList = const [
    ForYouVideoScreen(),
    SearchScreen(),
    UploadVideoScreen(),
    FollowingsVideoScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            screenIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white12,
        currentIndex: screenIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 30,
              ),
              label: 'Discover'),
          BottomNavigationBarItem(
              icon: Icon(
                UploadCustomIcon(),
                size: 30,
              ),
              label: ''),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.inbox_sharp,
              size: 30,
            ),
            label: 'Followings',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 30,
              ),
              label: 'Me'),
        ],
      ),
      body: screensList[screenIndex],
    );
  }
}
