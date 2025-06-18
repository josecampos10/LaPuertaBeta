import 'dart:typed_data';

import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lapuerta2/administrador/admin_widget_tree.dart';
import 'package:lapuerta2/firebase_api.dart';
import 'package:lapuerta2/notification_services.dart';

class AdminProfilehome extends StatefulWidget {
  const AdminProfilehome({Key? key}) : super(key: key);

  @override
  State<AdminProfilehome> createState() => _AdminProfileHomeState();
}

class _AdminProfileHomeState extends State<AdminProfilehome> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;
  final GlobalKey scrollKey = GlobalKey();
  bool isSwitched = false;


  void requestNotificationPermissiones() async {
    await FirebaseApi().initNotifications();
  }

  void requestNotificationPermission() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      //appsetting.AppSettings.openNotificationSettings();
      if (kDebugMode) {
        print('user denied permission');
      }
    }
  }

  signOut() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AdminWidgetTree()));
  }

  String push = '';

  Uint8List? pickedImage;

  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    getProfilePicture();


  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
          appBar: AppBar(
            bottomOpacity: 0.0,
            toolbarHeight: size.width * 0.17,
            leadingWidth: size.width * 0.17,
            leading: Container(
              padding: EdgeInsets.all(6),
              width: size.width * 0.2,
              child: CircleAvatar(
                backgroundColor: const Color.fromARGB(0, 240, 195, 195),
                child: Image.asset(
                  'assets/img/logo.png',
                  fit: BoxFit.scaleDown,
                  scale: size.height * 0.008,
                  color: Colors.white,
                ),
              ),
            ),
            title: Container(
                padding: EdgeInsets.only(top: size.height * 0.03),
                child: Text(
                  'Perfil',
                )),
            centerTitle: true,
            titleTextStyle: TextStyle(
                fontFamily: '',
                fontWeight: FontWeight.bold,
                fontSize: size.height * 0.023,
                color: const Color.fromARGB(255, 255, 255, 255)),
            backgroundColor: Color.fromRGBO(4, 99, 128, 1),
            actions: [],
          ),
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color.fromRGBO(4, 99, 128, 1),
          body: Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(size.width * 0.08),
                    topRight: Radius.circular(size.width * 0.08))),
            //color: Colors.red,
            height: size.height * 0.9,
            width: size.width,
            //color: Color.fromRGBO(4, 99, 128, 1),
            child: Column(
              children: [
                SingleChildScrollView(
                  /*physics: AlwaysScrollableScrollPhysics(),
                  key: scrollKey,
                  reverse: true,
                  primary: true,*/
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.02),
                      Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: size.width * .7,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: size.height * 0.015,
                                    ),
      
                                    StreamBuilder<
                                        DocumentSnapshot<Map<String, dynamic>>>(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(currentUser
                                              .email) // 👈 Your document id change accordingly
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<DocumentSnapshot>
                                              snapshot) {
                                        if (snapshot.hasError) {
                                          return const Text(
                                              'Something went wrong');
                                        }
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Column(children: [
                                            SizedBox(
                                              height: size.height * 0.02,
                                            ),
                                            SpinKitFadingCircle(
                                              color:
                                                  Color.fromRGBO(4, 99, 128, 1),
                                              size: size.width * 0.1,
                                            ),
                                          ]);
                                        }
                                        Map<String, dynamic> data = snapshot.data!
                                            .data() as Map<String, dynamic>;
                                        return Text(
                                          data['name'],
                                          style: TextStyle(
                                              fontSize: size.height * 0.025,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.bold,
                                              color: const Color.fromARGB(
                                                  255, 77, 77, 77)),
                                        ); // 👈 your valid data here
                                      },
                                    ),
      
                                    //SizedBox(
                                    //    height: 24,
                                    //    child: Image.asset("assets/images/verified.png")),
                                  ],
                                ),
                              ),
                              Container(
                                height: size.height * 0.12,
                                width: size.height * 0.12,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  border: Border.all(
                                    color: Color.fromRGBO(4, 99, 128, 1),
                                    width: size.height * 0.004,
                                  ),
                                  shape: BoxShape.circle,
                                  image: pickedImage != null
                                      ? DecorationImage(
                                          fit: BoxFit.cover,
                                          image: Image.memory(
                                            pickedImage!,
                                          ).image)
                                      : null,
                                ),
                              ),
                            ]),
                      ]),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: size.height * 0.02,
                          ),
                          Text(
                            'Cuenta',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.5),
                                fontSize: size.height * 0.028,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: size.height * 0.01,
                          ),
                          Container(
                            width: size.width - 20,
                            height: size.height * 0.06,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(4, 99, 128, 1),
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  spreadRadius: 0,
                                  blurRadius: 10,
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                            child: TextButton(
                              
                              onPressed: () => Navigator.pushNamed(
                                  context, '/detailsWishlist'),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '    Editar Perfil',
                                    style: TextStyle(
                                        fontSize: size.height * 0.022,
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      Icons.arrow_forward_ios_outlined)
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: size.height * 0.01,
                          ),
                          Container(
                            width: size.width - 20,
                            height: size.height * 0.06,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(4, 99, 128, 1),
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  spreadRadius: 0,
                                  blurRadius: 10,
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                            child: TextButton(
                             
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/changePassword'),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '    Change Password',
                                    style: TextStyle(
                                        fontSize: size.height * 0.022,
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      Icons.arrow_forward_ios_outlined)
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: size.height * 0.01,
                          ),
                          Container(
                            width: size.width - 20,
                            height: size.height * 0.06,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(4, 99, 128, 1),
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  spreadRadius: 0,
                                  blurRadius: 10,
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                            child: TextButton(
                              
                              onPressed: () {
                                
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '    Security & Privacy',
                                    style: TextStyle(
                                        fontSize: size.height * 0.022,
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      Icons.arrow_forward_ios_outlined)
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Notificaciones',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.5),
                                fontSize: size.height * 0.025,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: size.height * 0.01,
                          ),
                          Container(
                            width: size.width - 20,
                            height: size.height * 0.06,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(4, 99, 128, 1),
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  spreadRadius: 0,
                                  blurRadius: 10,
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                            child: TextButton(
                              
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Notificaciones'),
                                        content: Text(
                                            'Para cambiar los ajustes de Notificaciones vaya a los ajustes de su teléfono'),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                //AppSettings.openAppSettings(type: AppSettingsType.notification);
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cancelar')),
                                          TextButton(
                                              onPressed: () =>
                                                  AppSettings.openAppSettings(
                                                      type: AppSettingsType
                                                          .notification),
                                              //Navigator.of(context).pop();
      
                                              child: Text('Ir a Ajustes')),
                                        ],
                                      );
                                    });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '    Ajustes',
                                    style: TextStyle(
                                        fontSize: size.height * 0.022,
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  StreamBuilder<
                                      DocumentSnapshot<Map<String, dynamic>>>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(currentUser
                                            .email) // 👈 Your document id change accordingly
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            snapshot) {
                                      if (snapshot.hasError) {
                                        return const Text('Something went wrong');
                                      }
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Text("");
                                      }
                                      Map<String, dynamic> data = snapshot.data!
                                          .data() as Map<String, dynamic>;
                                      if (data['Push Notifications'].toString() ==
                                          'enabled') {
                                        return Text('');
                                      } else {
                                        return Text(
                                            ''); // 👈 your valid data here
                                      }
                                    },
                                  ),
                                  Icon(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      Icons.arrow_forward_ios_outlined)
                                  /*Switch(
                                      value: _notificationEnabled,
                                      onChanged: (value) {
                                        setState(() {
                                          _notificationEnabled = value;
                                          //notificationServices.requestNotificationPermission();
                                          if (value) {
                                            _checkNotificationPermission();
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(currentUser.email)
                                                .update({
                                              'Push Notifications': 'enabled'
                                            });
                                          } else {
                                            _requestNotificationPermission();
                                            _checkNotificationPermission();
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(currentUser.email)
                                                .update({
                                              'Push Notifications': 'disabled'
                                            });
                                          }
                                        });
                                      })*/
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.025,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: size.height * 0.02,
                          ),
                          Text(
                            'Cerrar sesión',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.5),
                                fontSize: size.height * 0.025,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: size.width - 20,
                            height: size.height * 0.06,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(4, 99, 128, 1),
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  spreadRadius: 0,
                                  blurRadius: 10,
                                  offset: Offset(-4, 4),
                                ),
                              ],
                            ),
                            child: TextButton(
                             
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Salir'),
                                        content: Text(
                                            'Estás seguro que deseas cerrar sesión?'),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cancelar')),
                                          TextButton(
                                              onPressed: () {
                                                signOut();
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Aceptar')),
                                        ],
                                      );
                                    });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '    Salir',
                                    style: TextStyle(
                                        fontSize: size.height * 0.022,
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      Icons.arrow_forward_ios_outlined)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
    
    
  }

  Future<void> onProfileTapped() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child(currentUser.email.toString());
    final imageBytes = await image.readAsBytes();
    await imageRef.putData(imageBytes);

    setState(() => pickedImage = imageBytes);
  }

  Future<void> getProfilePicture() async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child(currentUser.email.toString());

    try {
      final imageBytes = await imageRef.getData();
      if (imageBytes == null) return;
      setState(() => pickedImage = imageBytes);
    } catch (e) {
      print('Profile Picture could not be found');
    }
  }
}

class editProfile extends StatefulWidget {
  const editProfile({Key? key}) : super(key: key);
  @override
  State<editProfile> createState() => _editProfile();
}

class _editProfile extends State<editProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('EDIT'),
      ),
    );
  }
}
