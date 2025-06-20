import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentCosturafilesAM extends StatefulWidget {
  const StudentCosturafilesAM({Key? key}) : super(key: key);
  @override
  State<StudentCosturafilesAM> createState() => _StudentCosturafilesAMState();
}

class _StudentCosturafilesAMState extends State<StudentCosturafilesAM> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  CollectionReference users =
      FirebaseFirestore.instance.collection('postsCostura');
  late Future<ListResult> futureFiles;
    Uint8List? pickedImage;
  final currentUsera = FirebaseAuth.instance.currentUser!;
  late Stream<QuerySnapshot> base;

  @override
  void initState() {
    super.initState();
    futureFiles = FirebaseStorage.instance.ref('/Costurafiles').listAll();
        getProfilePicture();
    base = FirebaseFirestore.instance
        .collection('postsESL')
        .orderBy('Time', descending: true)
        .snapshots();
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
                topLeft: Radius.circular(size.width * 0.087),
                topRight: Radius.circular(size.width * 0.087))),
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
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
                          image: AssetImage('assets/img/Costuraback.png'),
                          fit: BoxFit.cover),
                      //color: Color.fromARGB(155, 255, 102, 0),
                      borderRadius: BorderRadius.all(Radius.circular(31))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Costura',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.075,
                            fontFamily: 'Coolvetica',
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Corte y Confección',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.022,
                            fontFamily: 'Coolvetica',
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Miercoles y Viernes',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.017,
                            fontFamily: 'Coolvetica',
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '10:00 am - 12:00 pm',
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
              SingleChildScrollView(
                reverse: false,
                padding: EdgeInsets.all(size.width * 0.001),
                child: Column(
                  children: [
                    FutureBuilder<ListResult>(
                      future: FirebaseStorage.instance
                          .ref('/Costurafiles')
                          .listAll(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final files = snapshot.data!.items;
                          return SizedBox(
                            width: size.width,
                            height: size.height * 0.59,
                            child: ListView.builder(
                                itemCount: files.length,
                                itemBuilder: (context, index) {
                                  final file = files[index];
                                  return Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(width: 1))),
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.file_present,
                                        size: size.height * 0.03,
                                      ),
                                      title: Text(
                                        file.name,
                                        style: TextStyle(
                                            fontSize: size.height * 0.02,
                                            fontFamily: 'Coolvetica'),
                                      ),
                                      trailing: IconButton(
                                          onPressed: () => downloadFile(file),
                                          icon: Icon(
                                            Icons.download,
                                            size: size.height * 0.03,
                                            color: const Color.fromRGBO(
                                                4, 99, 128, 1),
                                          )),
                                    ),
                                  );
                                }),
                          );
                        } else if (snapshot.hasError) {
                          return Text('error');
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    )
                  ],
                ),
              )
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



  Future downloadFile(Reference ref) async {
    final Directory dir = Directory('/storage/emulated/0/Download');
    final file = File('${dir.path}/${ref.name}');
    await ref.writeToFile(file);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${ref.name} descargado')));
  }
}
