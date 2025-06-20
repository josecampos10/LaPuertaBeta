import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:image_picker/image_picker.dart';

class Profeeslfilespm extends StatefulWidget {
  const Profeeslfilespm({Key? key}) : super(key: key);
  @override
  State<Profeeslfilespm> createState() => _ProfeeslfilespmState();
}

class _ProfeeslfilespmState extends State<Profeeslfilespm> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  CollectionReference users = FirebaseFirestore.instance.collection('postsESL');
  late Future<ListResult> futureFiles;
  PlatformFile? pickedFile;
  List<PlatformFile>? selectedFiles;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Uint8List? pickedImage;
  final currentUsera = FirebaseAuth.instance.currentUser!;
  UploadTask? uploadTask;

  Future uploadFile() async {
    final path = 'ESLfiles/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download Link: $urlDownload');
    setState(() {
      uploadTask = null;
    });
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  @override
  void initState() {
    super.initState();
    futureFiles = FirebaseStorage.instance.ref('/ESLfiles').listAll();
    getProfilePicture();
    //uploadTask = null;
    //selectFile();
  }

  @override
  void dispose() {
    super.dispose();
    getProfilePicture();
    //pickedFile = null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          backgroundColor: const Color.fromARGB(255, 96, 146, 255),
          child: Icon(
            Icons.add, size: size.height*0.04,
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
          onPressed: () {
            selectFile();
            //pickFile();
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

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
                          image: AssetImage('assets/img/ESL back.png'),
                          fit: BoxFit.cover),
                      //color: Color.fromARGB(155, 255, 102, 0),
                      borderRadius: BorderRadius.all(
                          Radius.circular(size.width * 0.087))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ESL',
                        //textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.075,
                            fontFamily: 'Coolvetica',
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'English as Second Language',
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
              if (pickedFile != null)
                Container(
                    width: size.width * 0.95,
                    height: size.height * 0.06,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 2,
                            color: const Color.fromARGB(255, 134, 134, 134)),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: const Color.fromARGB(0, 255, 193, 7)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.01,
                                    ),
                                    Icon(Icons.file_copy_rounded),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 6),
                                      child: Text(
                                        'Archivo seleccionado',
                                        style: TextStyle(
                                            fontFamily: 'Coolvetica',
                                            fontSize: size.height * 0.02),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      child: CircleAvatar(
                                        backgroundColor: const Color.fromARGB(
                                            255, 238, 238, 238),
                                        child: Icon(
                                          Icons.delete_rounded,
                                          color: const Color.fromARGB(
                                              255, 245, 66, 53),
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          pickedFile = null;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    GestureDetector(
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromARGB(
                                              255, 238, 238, 238),
                                          child: Icon(
                                            Icons.upload,
                                            color: const Color.fromARGB(
                                                255, 51, 173, 55),
                                          ),
                                        ),
                                        onTap: () {
                                          uploadFile();
                                          pickedFile = null;
                                          uploadTask = null;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text('Archivo subido'),
                                            duration: Duration(seconds: 3),
                                          ));
                                        }),
                                    SizedBox(
                                      width: size.width * 0.01,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )),

              /*ListView.builder(
                    shrinkWrap: true,
                    itemCount: pickedFile!.length,
                    itemBuilder: (context, index) {
                      var file = pickedFile![index];
                      return Container(
                        height: 60,
                        color: Colors.grey.shade300,
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.file_copy_rounded),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 6),
                                      child: Text(file.name),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          )),
                                      onTap: () {
                                        setState(() {
                                          selectedFiles!.removeAt(index);
                                        });
                                      },
                                    ),
                                    InkWell(
                                      child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            Icons.upload_file_rounded,
                                            color: Colors.green,
                                          )),
                                      onTap: () {
                                        
                                        uploadFile();
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                    ),*/
              SizedBox(
                height: size.width * 0.015,
              ),
              SingleChildScrollView(
                reverse: false,
                padding: EdgeInsets.all(size.width * 0.001),
                child: Column(
                  children: [
                    FutureBuilder<ListResult>(
                      future:
                          FirebaseStorage.instance.ref('/ESLfiles').listAll(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final files = snapshot.data!.items;
                          return SizedBox(
                            width: size.width,
                            height: size.height * 0.571,
                            child: ListView.builder(
                                itemCount: files.length,
                                itemBuilder: (context, index) {
                                  final file = files[index];
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    child: ScaleAnimation(
                                      duration: Duration(milliseconds: 300),
                                      child: FadeInAnimation(
                                          child: Slidable(
                                        endActionPane: ActionPane(
                                            motion: StretchMotion(),
                                            children: [
                                              SlidableAction(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                onPressed: (context) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Eliminar actividad'),
                                                          content: Text(
                                                              'Estás seguro que quieres borrar esta actividad?'),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  FirebaseStorage
                                                                      .instance
                                                                      .ref(
                                                                          '/ESLfiles')
                                                                      .listAll();
                                                                  setState(() {
                                                                    FirebaseStorage
                                                                        .instance
                                                                        .ref()
                                                                        .child(
                                                                            'ESLfiles/${file.name}')
                                                                        .delete();
                                                                  });
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          SnackBar(
                                                                    content: Text(
                                                                        'Archivo borrado'),
                                                                    duration: Duration(
                                                                        seconds:
                                                                            3),
                                                                  ));

                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                    'Aceptar')),
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                    'Cancelar'))
                                                          ],
                                                        );
                                                      });
                                                },
                                                backgroundColor: Colors.red,
                                                icon: Icons.delete,
                                                label: 'borrar',
                                              )
                                            ]),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom:
                                                      BorderSide(width: 1.1, color: const Color.fromARGB(255, 224, 224, 224)))),
                                          child: ListTile(
                                            leading: Container(
                                                width: size.width * 0.2,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    IconButton(
                                                        onPressed: () =>
                                                            downloadFile(file),
                                                        icon: Icon(
                                                            Icons.download,
                                                            size: size.height *
                                                                0.03)),
                                                    Icon(Icons.file_present,
                                                        size:
                                                            size.height * 0.03),
                                                  ],
                                                )),
                                            title: Text(file.name,
                                                style: TextStyle(
                                                    fontSize:
                                                        size.height * 0.02,
                                                    fontFamily: 'Coolvetica')),
                                          ),
                                        ),
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
              ),
              //buildProgress(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
        stream: uploadTask?.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            double progress = data.bytesTransferred / data.totalBytes;
            return Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  color: Colors.green,
                ),
                Center(
                  child: Text(
                    '${(100 * progress).roundToDouble()}%',
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ],
            );
          } else {
            return const SizedBox(
              height: 50,
            );
          }
        },
      );

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
