import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';

class Profegedpm extends StatefulWidget {
  const Profegedpm({Key? key}) : super(key: key);
  @override
  State<Profegedpm> createState() => _ProfegedpmState();
}

class _ProfegedpmState extends State<Profegedpm> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  CollectionReference users = FirebaseFirestore.instance.collection('postsGED');
  final controller = TextEditingController();

  final streaming = FirebaseFirestore.instance
      .collection('postsGED')
      .orderBy('Date', descending: true)
      .snapshots();

        Uint8List? pickedImage;
  final currentUsera = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
         getProfilePicture();
    //final streaming;
  }

  @override
  void dispose() {
    super.dispose();
         getProfilePicture();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(4, 99, 128, 1),
      appBar: AppBar(
        iconTheme: CupertinoIconThemeData(
          color: Colors.white,
          size: size.height * 0.035,
        ),
        bottomOpacity: 0.0,
        toolbarHeight: size.height * 0.12,
        leadingWidth: size.width * 0.13,
        //leading:
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: size.width,
                  height: size.height * 0.2,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          filterQuality: FilterQuality.low,
                          image: AssetImage('assets/img/GEDback.png'),
                          fit: BoxFit.cover),
                      //color: Color.fromARGB(155, 255, 102, 0),
                      borderRadius: BorderRadius.all(Radius.circular(31))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'GED',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.height * 0.075,
                          fontFamily: 'Coolvetica',
                          fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'General Education Development',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.height * 0.022,
                          fontFamily: 'Coolvetica',
                          fontWeight: FontWeight.w500),
                      ),
                      
                      Text(
                        'Martes y Jueves',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.height * 0.017,
                          fontFamily: 'Coolvetica',
                          fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '5:30 pm - 7:30 pm',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.height * 0.017,
                          fontFamily: 'Coolvetica',
                          fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
               StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser
                        .email)
                    // 👈 Your document id change accordingly
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  
                  //final data = snapshot.data!.data();
                  if(snapshot.hasData){
                    final Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                    return Container(
                    height: size.height * 0.07,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Container(
                      width: size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: size.width * 0.01),
                          Container(
                            height: size.height * 0.06,
                            width: size.width * 0.98,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 1.0, vertical: 0.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 163, 163, 163),
                                      width: 2),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: TextField(
                                //textAlign: TextAlign.,
                                autofocus: false,
                                minLines: 1,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline,
                                controller: controller,
                                onChanged: (value) => setState(() {
                                  controller.text = value.toString();
                                }),
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: const Color.fromARGB(
                                              0, 0, 187, 212)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: const Color.fromARGB(
                                              0, 0, 187, 212)),
                                    ),
                                    //isCollapsed: true,
                                    hintText: "Mensaje",
                                    hintStyle: const TextStyle(
                                        color: const Color.fromARGB(
                                            255, 110, 110, 110)),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title:
                                                    Text('Publicar actividad'),
                                                content: Text(
                                                    'Estás seguro que quieres publicar esta actividad?'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        DateTime date =
                                                            DateTime.now();
                                                        String today =
                                                            '${date.day}/${date.month}/${date.year}';
                                                        String timetoday =
                                                            '${date.hour}:${date.minute}';
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'postsGED')
                                                            .doc(DateTime(
                                                                    DateTime.now()
                                                                        .year,
                                                                    DateTime.now()
                                                                        .month,
                                                                    DateTime.now()
                                                                        .day,
                                                                    DateTime.now()
                                                                        .hour,
                                                                    DateTime.now()
                                                                        .minute,
                                                                    DateTime.now()
                                                                        .second)
                                                                .toString())
                                                            .set({
                                                          'Name': data['name']??"",
                                                          'Comment':
                                                              controller.text,
                                                          'Date': today,
                                                          'Time': timetoday,
                                                          'User': 'La Puerta',
                                                          'postUrl': 'no imagen'
                                                        });

                                                        Navigator.of(context)
                                                            .pop();
                                                        // postImage();

                                                        controller.clear();
                                                      },
                                                      child: Text('Aceptar')),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('Cancelar'))
                                                ],
                                              );
                                            });
                                      },
                                      icon: Icon(
                                        Icons.send,
                                        color: Color.fromRGBO(4, 99, 128, 1),
                                        size: size.height * 0.035,
                                      ),
                                    )
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  } else if (snapshot.hasError){
                    return Text('error');
                  } else {
                    return CircularProgressIndicator(
                      strokeWidth: size.height*0.0001,
                    );
                  }
                  
                  
                },
              ),
              Container(
                height: size.height * 0.05,
                width: size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey))),
                child: TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/profeGEDpm_files'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        Icon(Icons.folder_copy_outlined),
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        Text('Archivos',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: size.height * 0.02, fontFamily: 'Coolvetica')),
                      ],
                    )),
              ),
              Container(
                height: size.height * 0.05,
                width: size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey))),
                child: TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/studentGEDpm_students'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        Icon(Icons.person_3),
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        Text(
                          'Estudiantes',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: size.height * 0.02, fontFamily: 'Coolvetica'),
                        ),
                      ],
                    )),
              ),
              
              SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                reverse: false,
                padding: EdgeInsets.all(size.width * 0.001),
                child: Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: streaming,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Column(children: [
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              SpinKitFadingCircle(
                                color: Color.fromRGBO(4, 99, 128, 1),
                                size: size.width * 0.1,
                              ),
                            ]);
                          }
                          if (snapshot.hasData) {
                            final snap = snapshot.data!.docs;
                            return RefreshIndicator(
                              color: Color.fromRGBO(3, 69, 88, 1),
                              backgroundColor: Colors.white,
                              displacement: 1,
                              strokeWidth: 3,
                              onRefresh: () async {},
                              child: SizedBox(
                                height: size.height * 0.408,
                                width: double.infinity,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: MasonryGridView.builder(
                                    padding: EdgeInsets.zero,
                                    gridDelegate:
                                        SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 1),
                                    mainAxisSpacing: 1,
                                    crossAxisSpacing: 1,
                                    physics: ScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    primary: true,
                                    itemCount: snap.length,
                                    cacheExtent: 1000.0,
                                    itemBuilder: (context, index) {
                                      // final DocumentSnapshot documentSnapshot =
                                      //  snapshot.data!.docs[index];
                                      return AnimationConfiguration
                                          .staggeredList(
                                        position: index,
                                        child: ScaleAnimation(
                                          duration: Duration(milliseconds: 300),
                                          child: FadeInAnimation(
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            size.width * 0.04)),
                                                elevation: size.height * 0.01,
                                                shadowColor: Colors.black,
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                                child: Container(
                                                  //constraints: const BoxConstraints(minHeight: ),
                                                  //width: 180,
                                                  //height: 20,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        size.width * 0.03),
                                                    child: Column(
                                                      children: [
                                                        Row(children: [
                                                          CircleAvatar(
                                                              minRadius:
                                                                  size.height *
                                                                      0.023,
                                                              maxRadius:
                                                                  size.height *
                                                                      0.023,
                                                              backgroundColor:
                                                                  const Color
                                                                      .fromARGB(
                                                                      143,
                                                                      13,
                                                                      77,
                                                                      252)),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.02,
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              snap[index]
                                                                  ['Name'],
                                                              style: TextStyle(
                                                                fontSize:
                                                                    size.height *
                                                                        0.019,
                                                                fontFamily:
                                                                    'Coolvetica',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        0,
                                                                        0,
                                                                        0)
                                                                    .withOpacity(
                                                                        0.9),
                                                              ),
                                                            ),
                                                          ),
                                                          
                                                          SizedBox(
                                                            width: size.width *
                                                                0.01,
                                                          ),
                                                          Text(
                                                            snap[index]['Time'],
                                                            style: TextStyle(
                                                                fontSize:
                                                                    size.height *
                                                                        0.013,
                                                                fontFamily:
                                                                    'JosefinSans',
                                                                color: const Color
                                                                    .fromARGB(
                                                                    90,
                                                                    0,
                                                                    0,
                                                                    0)),
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.02,
                                                          ),
                                                        ]),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.12,
                                                            ),
                                                            Text(
                                                              snap[index]
                                                                  ['Date'],
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      size.height *
                                                                          0.013,
                                                                  fontFamily:
                                                                      'JosefinSans',
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      90,
                                                                      0,
                                                                      0,
                                                                      0)),
                                                            ),
                                                          ],
                                                        ),
                                                        Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Linkify(
                                                              linkStyle:
                                                                  TextStyle(
                                                                decoration:
                                                                    TextDecoration
                                                                        .none,
                                                                fontSize:
                                                                    size.height *
                                                                        0.0162,
                                                                fontFamily:
                                                                    'Impact',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    28,
                                                                    100,
                                                                    255),
                                                              ),
                                                              style: TextStyle(
                                                                fontSize:
                                                                    size.height *
                                                                        0.0162,
                                                                fontFamily:
                                                                    'Impact',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              text: snap[index]
                                                                  ['Comment'],
                                                              onOpen:
                                                                  (link) async {
                                                                if (!await launchUrl(
                                                                    Uri.parse(link
                                                                        .url))) {
                                                                  throw Exception(
                                                                      'Could not launch ${link.url}');
                                                                }
                                                              },
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
