import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lapuerta2/Profile%20files/wishlist_nav.dart';
import 'package:lapuerta2/UserhomePrincipal.dart';

import 'package:lapuerta2/scan_page.dart';
import 'package:lapuerta2/Students%20Clases/studentClases_nav.dart';

class Mainwrapper extends StatefulWidget {
  const Mainwrapper({super.key});
  @override
  State<Mainwrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<Mainwrapper> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  int _selectedIndex = 0;
  int _notificationCount = 0; // Count of new notifications

  @override
  void initState() {
    super.initState();
    _listenForNewPosts();
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser?.email)
        .update({'token': FirebaseMessaging.instance.getToken()});
  }

  /// Listens for new posts in Firestore and updates the notification count
  void _listenForNewPosts() {
    FirebaseFirestore.instance
        .collection('posts')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docChanges.isNotEmpty) {
        setState(() {
          _notificationCount += snapshot.docChanges.length; // Increase count
        });
      }
    });
  }

  /// Handles navigation bar taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 3) {
        // Notifications tab index
        _notificationCount = 0; // Reset notification count when opened
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: Container(
        height: size.height * 0.065,
        child: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedLabelStyle: TextStyle(fontSize: size.height * 0.001),
            selectedItemColor: Colors.white,
            unselectedItemColor: Color.fromRGBO(3, 67, 87, 1),
            //backgroundColor: Colors.green,
            //iconSize: size.height * 0.025,
            selectedIconTheme: IconThemeData(size: size.height * 0.03),
            unselectedIconTheme: IconThemeData(size: size.height * 0.025),
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
                if (index == 2) {
                  _notificationCount = 0;
                }
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                  ),
                  backgroundColor: Color.fromRGBO(4, 99, 128, 1),
                  label: ''),
              /*BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat,
                  ),
                  backgroundColor: Color.fromRGBO(4, 99, 128, 1), label: ''),*/
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.class_,
                  ),
                  backgroundColor: Color.fromRGBO(4, 99, 128, 1),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Stack(
                    children: [
                      Icon(
                        Icons.notifications,
                        //color: const Color.fromRGBO(3, 67, 87, 1),
                      ),
                      if (_notificationCount >
                          0) // Show badge only if there are new notifications
                        Positioned(
                          right: size.width * 0.01,
                          top: 0,
                          bottom: size.width * 0.02,
                          child: Container(
                            padding: EdgeInsets.only(),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              shape: BoxShape.circle,
                            ),
                            constraints: BoxConstraints(
                                maxHeight: size.width * 0.018,
                                maxWidth: size.width * 0.018,
                                minWidth: size.width * 0.018,
                                minHeight: size.width * 0.018),
                            child: Text(
                              '$_notificationCount',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontSize: size.width * 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  backgroundColor: Color.fromRGBO(4, 99, 128, 1),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                  ),
                  backgroundColor: Color.fromRGBO(4, 99, 128, 1),
                  label: ''),
            ]),
      ),

      /*NavigationBar(
        labelPadding: EdgeInsets.only(bottom: 0),
          height: size.height*0.08,
          backgroundColor: const Color.fromARGB(255, 4, 99, 128),
          indicatorColor: Colors.transparent,
          shadowColor: Colors.transparent,
          selectedIndex: _selectedIndex,
          surfaceTintColor: Colors.transparent,
          onDestinationSelected: _onItemTapped,
          destinations: <NavigationDestination>[
            NavigationDestination(
                selectedIcon: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: size.width * 0.06,
                ),
                icon: Icon(
                  Icons.home_outlined,
                  color: Colors.white30,
                  size: size.width * 0.06,
                ),
                label: ''),
            NavigationDestination(
                selectedIcon: Icon(
                  Icons.chat,
                  color: Colors.white,
                  size: size.width * 0.06,
                ),
                icon: Icon(
                  Icons.chat_outlined,
                  color: Colors.white30,
                  size: size.width * 0.06,
                ),
                label: ''),
            NavigationDestination(
                selectedIcon: Icon(
                  Icons.class_,
                  color: Colors.white,
                  size: size.width * 0.06,
                ),
                icon: Icon(
                  Icons.class_outlined,
                  color: Colors.white30,
                  size: size.width * 0.06,
                ),
                label: ''),
            NavigationDestination(
                selectedIcon: Icon(Icons.notifications,
                    color: Colors.white, size: size.width * 0.06),
                icon: Stack(
                  children: [
                    Icon(Icons.notifications_outlined,
                        color: Colors.white30, size: size.width * 0.06),
                    if (_notificationCount >
                        0) // Show badge only if there are new notifications
                      Positioned(
                        right: size.width*0.02,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          padding: EdgeInsets.only(),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          constraints: BoxConstraints(
                            maxHeight: size.width*0.01,
                            maxWidth: size.width*0.005,
                             minWidth: size.width*0.005,
                            minHeight: size.width*0.005
                          ),
                          child: Text(
                            '$_notificationCount',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontSize: size.width*0.03,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                label: ''),
            NavigationDestination(
                selectedIcon: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: size.width * 0.06,
                ),
                icon: Icon(
                  Icons.person_outline,
                  color: Colors.white30,
                  size: size.width * 0.06,
                ),
                label: '')
          ]),*/

      body: SafeArea(
          top: false,
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              UserhomePrincipal(),
              //UserchatHome(),
              StudentclasesNav(),
              Notifications(),
              Wishlist(),
            ],
          )),
    );
  }
}
