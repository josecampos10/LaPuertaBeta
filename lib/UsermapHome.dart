import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

class UsermapHome extends StatefulWidget {
  const UsermapHome({Key? key}) : super(key: key);
  @override
  State<UsermapHome> createState() => _UsermapHomeState();
}

class _UsermapHomeState extends State<UsermapHome> {
  final Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;
  final currentUser = FirebaseAuth.instance.currentUser!;
  int _selectedIndex = 0;
  int _notificationCountESLpm = 0;
  int _notificationCountGEDpm = 0;
  int _notificationCountCostura = 0;
  int _notificationCountCiudadania = 0;
    Uint8List? pickedImage;
  final currentUsera = FirebaseAuth.instance.currentUser!;

  void _initializeMapRenderer() {
    final GoogleMapsFlutterPlatform mapsImplementation =
        GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
    }
  }

  void _listenForNewPostsESLpm() {
    FirebaseFirestore.instance
        .collection('postsESL')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docChanges.isNotEmpty) {
        setState(() {
          _notificationCountESLpm +=
              snapshot.docChanges.length; // Increase count
        });
      }
    });
  }

  void _listenForNewPostsGEDpm() {
    FirebaseFirestore.instance
        .collection('postsGED')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docChanges.isNotEmpty) {
        setState(() {
          _notificationCountGEDpm +=
              snapshot.docChanges.length; // Increase count
        });
      }
    });
  }

  void _listenForNewPostsCostura() {
    FirebaseFirestore.instance
        .collection('postsCostura')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docChanges.isNotEmpty) {
        setState(() {
          _notificationCountCostura +=
              snapshot.docChanges.length; // Increase count
        });
      }
    });
  }

  void _listenForNewPostsCiudadania() {
    FirebaseFirestore.instance
        .collection('postsCiudadania')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docChanges.isNotEmpty) {
        setState(() {
          _notificationCountCiudadania +=
              snapshot.docChanges.length; // Increase count
        });
      }
    });
  }

  @override
  void initState() {
    _init();
    _initializeMapRenderer();
    _listenForNewPostsESLpm();
    _listenForNewPostsGEDpm();
    _listenForNewPostsCostura();
    _listenForNewPostsCiudadania();
    super.initState();
    getProfilePicture();
  }

  _init() {
    _cameraPosition = CameraPosition(
        target: const LatLng(31.552747572929263, -97.1278868172345),
        zoom: 15.3);
  }

  @override
  void dispose() {
    _init();
    _initializeMapRenderer();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(4, 99, 128, 1),
      appBar: AppBar(
        //iconTheme: CupertinoIconThemeData(color: Colors.white,size: size.height*0.035, ),
        bottomOpacity: 0.0,
        toolbarHeight: size.height * 0.12,
        leadingWidth: size.width * 0.13,
        leading: Text(''),
        title: Container(
            padding: EdgeInsets.only(top: size.height * 0.0),
            child: Text(
              'Mis clases',
              style: TextStyle(
                  //fontWeight: FontWeight.w500,
                  fontSize: size.width * 0.055,
                  color: Colors.white,
                  fontFamily: ''),
            )),
        centerTitle: false,
        titleTextStyle: TextStyle(
            fontFamily: '',
            fontWeight: FontWeight.bold,
            fontSize: size.height * 0.023,
            color: const Color.fromARGB(255, 255, 255, 255)),
        backgroundColor: const Color.fromRGBO(4, 99, 128, 1),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/puntos.png'),
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: size.height * 0.065,
                width: size.height * 0.065,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(
                    color: Color.fromRGBO(255, 255, 255, 0.174),
                    width: size.height * 0.003,
                  ),
                  shape: BoxShape.circle,
                  image: pickedImage != null
                      ? DecorationImage(
                          fit: BoxFit.cover,
                          image: Image.memory(
                            pickedImage!,
                          ).image)
                      : DecorationImage(
                          image: NetworkImage(
                              'https://firebasestorage.googleapis.com/v0/b/fir-lapuerta.firebasestorage.app/o/default.png?alt=media&token=aabb96df-14d7-486b-bdce-b9c81dfd6ced')),
                ),
              ),
              SizedBox(
                width: size.width * 0.03,
              )
            ],
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      //backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.width * 0.08),
                topRight: Radius.circular(size.width * 0.08))),
        height: size.height,
        width: size.width,
        //decoration: BoxDecoration(
        //image: DecorationImage(image: AssetImage('assets/img/foto5.jpg'),
        //colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
        // fit: BoxFit.cover
        // ),
        //),

        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.02,
              ),
              /*SizedBox(
                  //padding: EdgeInsets.all(5.0),
                  height: size.height*0.805,
                  width: size.width * 1,
                  child: _buildBody())*/

              //PARTE DE ESTUDIANTES********************************************
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser
                        .email) // 👈 Your document id change accordingly
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(children: [
                      
                    ]);
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Estudiante') {
                      if (data['ESLpm'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/studentESLpm');
                                setState(() {
                                  _notificationCountESLpm = 0;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image:
                                          AssetImage('assets/img/ESL back.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.language,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(155, 255, 102, 0)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(155, 255, 102, 0),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.2,
                                            child: Text(
                                              "ESL PM",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountESLpm >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth:
                                                        size.width * 0.08,
                                                    minWidth:
                                                        size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
                                                ),
                                        ],
                                      )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser
                        .email) // 👈 Your document id change accordingly
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Estudiante') {
                      if (data['GEDpm'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/studentGEDpm');
                                setState(() {
                                  _notificationCountGEDpm = 0;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image:
                                          AssetImage('assets/img/GEDback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.school,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(143, 13, 77, 252)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(143, 13, 77, 252),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.2,
                                            child: Text(
                                              "GED PM",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountGEDpm >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth:
                                                        size.width * 0.08,
                                                    minWidth:
                                                        size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
                                                ),
                                        ],
                                      )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser
                        .email) // 👈 Your document id change accordingly
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Estudiante') {
                      if (data['costuraAM'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/studentCosturaAM');
                                setState(() {
                                  _notificationCountCostura = 0;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage(
                                          'assets/img/Costuraback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.home_work,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(143, 52, 161, 1)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(143, 52, 161, 1),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.2,
                                            child: Text(
                                              "Costura",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountCostura >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth:
                                                        size.width * 0.08,
                                                    minWidth:
                                                        size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
                                                ),
                                        ],
                                      )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser
                        .email) // 👈 Your document id change accordingly
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Estudiante') {
                      if (data['ciudadania'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/studentCiudadania');
                                setState(() {
                                  _notificationCountCiudadania = 0;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage(
                                          'assets/img/Ciudadaniaback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.folder,
                                          size: size.height * 0.1,
                                          color: Color.fromARGB(
                                              153, 116, 40, 122)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(153, 116, 40, 122),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.3,
                                            child: Text(
                                              "Ciudadania",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountCiudadania >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth:
                                                        size.width * 0.08,
                                                    minWidth:
                                                        size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
                                                ),
                                        ],
                                      )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),

              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser
                        .email) // 👈 Your document id change accordingly
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Estudiante') {
                      if (data['cosmetologia'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/studentCiudadania');
                                setState(() {
                                  _notificationCountCiudadania = 0;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage(
                                          'assets/img/Ciudadaniaback.png'),
                                          colorFilter: ColorFilter.mode(Color.fromARGB(153, 122, 77, 40), BlendMode.color),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.folder,
                                          size: size.height * 0.1,
                                          color: const Color.fromARGB(153, 122, 77, 40)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(153, 122, 77, 40),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.35,
                                            child: Text(
                                              "Cosmetología",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountCiudadania >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth:
                                                        size.width * 0.08,
                                                    minWidth:
                                                        size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
                                                ),
                                        ],
                                      )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),


              //PARTE DE PROFESORES********************************************
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser
                        .email) // 👈 Your document id change accordingly
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == "Profesor") {
                      if (data['ESLpm'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.00,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/profeESLpm');
                                setState(() {
                                  _notificationCountESLpm = 0;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image:
                                          AssetImage('assets/img/ESL back.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.language,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(155, 255, 102, 0)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(155, 255, 102, 0),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.2,
                                            child: Text(
                                              "ESL PM",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountESLpm >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth:
                                                        size.width * 0.08,
                                                    minWidth:
                                                        size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
                                                ),
                                        ],
                                      )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }
                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser
                        .email) // 👈 Your document id change accordingly
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == "Profesor") {
                      if (data['GEDpm'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/profeGEDpm');
                                setState(() {
                                  _notificationCountGEDpm = 0;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image:
                                          AssetImage('assets/img/GEDback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.school,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(143, 13, 77, 252)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(143, 13, 77, 252),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.2,
                                            child: Text(
                                              "GED PM",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountGEDpm >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth:
                                                        size.width * 0.08,
                                                    minWidth:
                                                        size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
                                                ),
                                        ],
                                      )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser
                        .email) // 👈 Your document id change accordingly
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == "Profesor") {
                      if (data['costuraAM'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/profeCosturaAM');
                                setState(() {
                                  _notificationCountCostura = 0;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage(
                                          'assets/img/Costuraback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.home_work,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(143, 52, 161, 1)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(143, 52, 161, 1),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.2,
                                            child: Text(
                                              "Costura",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountCostura >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth:
                                                        size.width * 0.08,
                                                    minWidth:
                                                        size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
                                                ),
                                        ],
                                      )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser
                        .email) // 👈 Your document id change accordingly
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == "Profesor") {
                      if (data['ciudadania'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/profeCiudadania');
                                setState(() {
                                  _notificationCountCiudadania = 0;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage(
                                          'assets/img/Ciudadaniaback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.folder,
                                          size: size.height * 0.1,
                                          color: Color.fromARGB(
                                              153, 116, 40, 122)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(153, 116, 40, 122),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.3,
                                            child: Text(
                                              "Ciudadania",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountCiudadania >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth:
                                                        size.width * 0.08,
                                                    minWidth:
                                                        size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
                                                ),
                                        ],
                                      )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),

              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser
                        .email) // 👈 Your document id change accordingly
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Profesor') {
                      if (data['cosmetologia'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/profeCosmetologia');
                                setState(() {
                                  _notificationCountCiudadania = 0;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage(
                                          'assets/img/Ciudadaniaback.png'),
                                          colorFilter: ColorFilter.mode(Color.fromARGB(153, 122, 77, 40), BlendMode.color),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.folder,
                                          size: size.height * 0.1,
                                          color: const Color.fromARGB(153, 122, 77, 40)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(153, 122, 77, 40),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.35,
                                            child: Text(
                                              "Cosmetología",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountCiudadania >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth:
                                                        size.width * 0.08,
                                                    minWidth:
                                                        size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
                                                ),
                                        ],
                                      )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),


              //PARTE DE VOLUNTARIO********************************************

              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser
                        .email) // 👈 Your document id change accordingly
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Voluntario') {
                      if (data['ESLpm'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/studentESLpm');
                                setState(() {
                                  _notificationCountESLpm = 0;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image:
                                          AssetImage('assets/img/ESL back.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.language,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(155, 255, 102, 0)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(155, 255, 102, 0),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.2,
                                            child: Text(
                                              "ESL PM",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountESLpm >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth:
                                                        size.width * 0.08,
                                                    minWidth:
                                                        size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
                                                ),
                                        ],
                                      )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser
                        .email) // 👈 Your document id change accordingly
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Voluntario') {
                      if (data['GEDpm'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/studentGEDpm');
                                setState(() {
                                  _notificationCountGEDpm = 0;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image:
                                          AssetImage('assets/img/GEDback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.school,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(143, 13, 77, 252)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(143, 13, 77, 252),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.2,
                                            child: Text(
                                              "GED PM",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountGEDpm >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth:
                                                        size.width * 0.08,
                                                    minWidth:
                                                        size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
                                                ),
                                        ],
                                      )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser
                        .email) // 👈 Your document id change accordingly
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Voluntario') {
                      if (data['costuraAM'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/studentCosturaAM');
                                setState(() {
                                  _notificationCountCostura = 0;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage(
                                          'assets/img/Costuraback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.home_work,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(143, 52, 161, 1)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(143, 52, 161, 1),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.2,
                                            child: Text(
                                              "Costura",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountCostura >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth:
                                                        size.width * 0.08,
                                                    minWidth:
                                                        size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
                                                ),
                                        ],
                                      )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser
                        .email) // 👈 Your document id change accordingly
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Voluntario') {
                      if (data['ciudadania'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/studentCiudadania');
                                setState(() {
                                  _notificationCountCiudadania = 0;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage(
                                          'assets/img/Ciudadaniaback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.folder,
                                          size: size.height * 0.1,
                                          color: Color.fromARGB(
                                              153, 116, 40, 122)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(153, 116, 40, 122),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.3,
                                            child: Text(
                                              "Ciudadania",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountCiudadania >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth:
                                                        size.width * 0.08,
                                                    minWidth:
                                                        size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
                                                ),
                                        ],
                                      )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),

              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser
                        .email) // 👈 Your document id change accordingly
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Voluntario') {
                      if (data['cosmetologia'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/studentCiudadania');
                                setState(() {
                                  _notificationCountCiudadania = 0;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage(
                                          'assets/img/Ciudadaniaback.png'),
                                          colorFilter: ColorFilter.mode(Color.fromARGB(153, 122, 77, 40), BlendMode.color),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.folder,
                                          size: size.height * 0.1,
                                          color: const Color.fromARGB(153, 122, 77, 40)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(153, 122, 77, 40),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.35,
                                            child: Text(
                                              "Cosmetología",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountCiudadania >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth:
                                                        size.width * 0.08,
                                                    minWidth:
                                                        size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
                                                ),
                                        ],
                                      )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),


              //PARTE DE STAFF********************************************
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser
                        .email) // 👈 Your document id change accordingly
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == "Staff") {
                      if (data['ESLpm'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.00,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/profeESLpm');
                                setState(() {
                                  _notificationCountESLpm = 0;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image:
                                          AssetImage('assets/img/ESL back.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.language,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(155, 255, 102, 0)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(155, 255, 102, 0),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.2,
                                            child: Text(
                                              "ESL PM",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountESLpm >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth:
                                                        size.width * 0.08,
                                                    minWidth:
                                                        size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
                                                ),
                                        ],
                                      )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }
                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser
                        .email) // 👈 Your document id change accordingly
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == "Staff") {
                      if (data['GEDpm'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/profeGEDpm');
                                setState(() {
                                  _notificationCountGEDpm = 0;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image:
                                          AssetImage('assets/img/GEDback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.school,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(143, 13, 77, 252)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(143, 13, 77, 252),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.2,
                                            child: Text(
                                              "GED PM",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountGEDpm >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth:
                                                        size.width * 0.08,
                                                    minWidth:
                                                        size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
                                                ),
                                        ],
                                      )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser
                        .email) // 👈 Your document id change accordingly
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == "Staff") {
                      if (data['costuraAM'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/profeCosturaAM');
                                setState(() {
                                  _notificationCountCostura = 0;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage(
                                          'assets/img/Costuraback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.home_work,
                                          size: size.height * 0.1,
                                          color:
                                              Color.fromARGB(143, 52, 161, 1)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(143, 52, 161, 1),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.2,
                                            child: Text(
                                              "Costura",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountCostura >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth:
                                                        size.width * 0.08,
                                                    minWidth:
                                                        size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
                                                ),
                                        ],
                                      )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser
                        .email) // 👈 Your document id change accordingly
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == "Staff") {
                      if (data['ciudadania'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/profeCiudadania');
                                setState(() {
                                  _notificationCountCiudadania = 0;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage(
                                          'assets/img/Ciudadaniaback.png'),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.folder,
                                          size: size.height * 0.1,
                                          color: Color.fromARGB(
                                              153, 116, 40, 122)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(153, 116, 40, 122),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.3,
                                            child: Text(
                                              "Ciudadania",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountCiudadania >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth:
                                                        size.width * 0.08,
                                                    minWidth:
                                                        size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
                                                ),
                                        ],
                                      )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),

              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser
                        .email) // 👈 Your document id change accordingly
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (snapshot.hasData) {
                    if (data['rol'] == 'Staff') {
                      if (data['cosmetologia'] == 'inscrito') {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/studentCiudadania');
                                setState(() {
                                  _notificationCountCiudadania = 0;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      opacity: 0.6,
                                      image: AssetImage(
                                          'assets/img/Ciudadaniaback.png'),
                                          colorFilter: ColorFilter.mode(Color.fromARGB(153, 122, 77, 40), BlendMode.color),
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.fitWidth),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.15,
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(Icons.folder,
                                          size: size.height * 0.1,
                                          color: const Color.fromARGB(153, 122, 77, 40)),
                                    ),
                                    Container(
                                      width: size.width / 1.03 -
                                          size.width * 0.05 -
                                          size.width * 0.05,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(153, 122, 77, 40),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12))),
                                      padding: const EdgeInsets.all(12),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.35,
                                            child: Text(
                                              "Cosmetología",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.055,
                                                  color: Colors.white,
                                                  fontFamily: 'Coolvetica'),
                                            ),
                                          ),
                                          if (_notificationCountCiudadania >
                                              0) // Show badge only if there are new notifications
                                            Container(
                                                padding: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 221, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        size.width * 0.08,
                                                    maxWidth:
                                                        size.width * 0.08,
                                                    minWidth:
                                                        size.width * 0.08,
                                                    minHeight:
                                                        size.width * 0.08),
                                                child: Icon(
                                                  Icons.notification_add,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                                /*Text(
                                                '$_notificationCountESLpm',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),*/
                                                ),
                                        ],
                                      )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }

                  return Container(); // 👈 your valid data here
                },
              ),


              SizedBox(
                height: size.height * 0.03,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return _getMap();
  }

  Widget _getMap() {
    Size size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(size.width * 0.08),
        topRight: Radius.circular(size.width * 0.08),
      ),
      child: GoogleMap(
          zoomControlsEnabled: false,
          myLocationEnabled: false,
          rotateGesturesEnabled: false,
          liteModeEnabled: false,
          myLocationButtonEnabled: false,
          buildingsEnabled: false,
          //padding: EdgeInsets.all(40),
          initialCameraPosition: _cameraPosition!,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            controller.showMarkerInfoWindow(MarkerId('La Puerta'));
            if (!_googleMapController.isCompleted) {
              _googleMapController.complete(controller);
            }
          },
          markers: {
            Marker(
              visible: true,
              markerId: const MarkerId("La Puerta"),
              position: const LatLng(31.552747572929263, -97.1278868172345),
              infoWindow:
                  const InfoWindow(title: "La Puerta", snippet: "500 Clay Ave"),
            ),
          }),
    );
  }
    Future<void> getProfilePicture() async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child(currentUsera.email.toString());

    try {
      final imageBytes = await imageRef.getData();
      if (imageBytes == null) return;
      setState(() => pickedImage = imageBytes);
    } catch (e) {
      print('Profile Picture could not be found');
    }
  }
}
