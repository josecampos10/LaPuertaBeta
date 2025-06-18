import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:lapuerta2/administrador/image_storage_methods.dart';
import 'package:lapuerta2/administrador/utils.dart';

class Adminpublicaciones extends StatefulWidget {
  const Adminpublicaciones({
    Key? key,
  }) : super(key: key);

  @override
  State<Adminpublicaciones> createState() => _AdminpublicacionesState();
}

class _AdminpublicacionesState extends State<Adminpublicaciones> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController controllerdes = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;
  final String id = FirebaseFirestore.instance.collection('posts').doc().id;
  Uint8List? pickedImage;
  final time = DateTime.now().millisecondsSinceEpoch.toString();
  String photoID = '';

  Uint8List? _file;

  String imagenref = '';

  Future<Uint8List?>? future;

  // ignore: unused_field
  bool _isLoading = false;

  void postImage(user) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res =
          await ImageStoreMethods().uploadPost(controllerdes.text, _file!, user);

      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        showSnackbar('Posted', context);
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackbar(res, context);
      }
    } catch (err) {
      showSnackbar(err.toString(), context);
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  _imageSelect(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Seleccionar'),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Usa la cámara'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.camera,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Desde la galería'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    getProfilePicture();
    imagenref =
        'https://firebasestorage.googleapis.com/v0/b/fir-lapuerta.firebasestorage.app/o/default.png?alt=media&token=aabb96df-14d7-486b-bdce-b9c81dfd6ced';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: Container(
        height: size.height * 0.93,
        width: size.width,
        child: SingleChildScrollView(
          //physics: NeverScrollableScrollPhysics(),
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          reverse: false,
          child: Column(children: [
            Column(
              children: [
                SizedBox(
                  height: size.height * 0.07,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: size.width * 0.12,
                        width: size.width * 0.12,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.grey.withOpacity(0.5)),
                        child: Icon(Icons.close,
                            color: const Color.fromARGB(255, 179, 179, 179)),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.04,
                    )
                  ],
                ),
                //SizedBox( height: size.height * 0.1 ),
              ],
            ),
            Container(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Text(
                    'Crear publicacion',
                    style: TextStyle(
                        fontSize: size.width * 0.045,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 0, 0, 0)),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: size.width * 0.03,
                      ),
                      Container(
                        height: size.height * 0.06,
                        width: size.height * 0.06,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(0, 158, 158, 158),
                          border: Border.all(
                            color: Color.fromRGBO(4, 99, 128, 1),
                            width: size.height * 0.002,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/img/logo2.png',
                          filterQuality: FilterQuality.high,
                          scale: size.height * 0.012,
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.03,
                      ),
                      Text(
                        'La Puerta',
                        style: TextStyle(
                            fontSize: size.width * 0.045,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ],
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(0)),
                    child: TextField(
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      controller: controllerdes,
                      onChanged: (value) => setState(() {
                        controllerdes.text = value.toString();
                      }),
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(0, 0, 0, 0), width: 0.0)),
                        labelText: 'Que desea escribir...',
                        prefixIcon: Icon(Icons.add),
                        labelStyle:
                            TextStyle(fontSize: 14, fontFamily: 'Impact'),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: size.width * 0.01,
                      ),
                      SizedBox(
                        width: size.width * 0.10,
                        child: IconButton(
                            onPressed: () => _imageSelect(context),
                            icon: Image(
                              image: AssetImage('assets/img/iconphoto.png'),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  _file == null
                      ? Center(
                          child: Column(
                            children: [
                              FutureBuilder(
                                  future: FireStoreDataBase().getData(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return const Text('Something went wrong');
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return Container(
                                        height: size.height * 0.06,
                                        width: size.width * 0.5,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (controllerdes.text == '') {
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Publicar actividad'),
                                                      content: Text(
                                                          'Estás seguro que quieres publicar esta actividad?'),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              DateTime date =
                                                                  DateTime
                                                                      .now();
                                                              String today =
                                                                  '${date.day}/${date.month}/${date.year}';
                                                              String timetoday =
                                                                  '${date.hour}:${date.minute}';
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'posts')
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
                                                                'Comment':
                                                                    controllerdes
                                                                        .text,
                                                                'Date': today,
                                                                'Time':
                                                                    timetoday,
                                                                'User':
                                                                    'La Puerta',
                                                                'postUrl':
                                                                    'no imagen',
                                                                'Image': snapshot
                                                                    .data
                                                                    .toString(),
                                                                'createdAt': Timestamp.now()
                                                              });

                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              // postImage();

                                                              controllerdes
                                                                  .clear();
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
                                            }
                                            if (controllerdes.text.isEmpty) {
                                              return;
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              backgroundColor:
                                                  Color.fromRGBO(4, 99, 128, 1),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 25,
                                                  vertical: 10)),
                                          child: Text(
                                            'Siguiente',
                                            style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontSize: size.width * 0.044,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      );
                                    }
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }),
                            ],
                          ),
                        )
                      : Center(
                          child: Column(
                            children: [
                              FutureBuilder(
                                  future: FireStoreDataBase().getData(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return const Text('Something went wrong');
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return Column(children: [
                                        Container(
                                          height: size.height * 0.35,
                                          width: size.height,
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  0, 158, 158, 158),
                                              border: Border.all(
                                                color: Color.fromRGBO(
                                                    4, 99, 128, 0),
                                                width: size.height * 0.0,
                                              ),
                                              //shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: Image.memory(
                                                    _file!,
                                                  ).image)),
                                        ),
                                        SizedBox(
                                          height: size.height * 0.01,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            if (controllerdes.text == '') {
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Publicar actividad'),
                                                      content: Text(
                                                          'Estás seguro que quieres publicar esta actividad?'),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              DateTime date =
                                                                  DateTime
                                                                      .now();
                                                              String today =
                                                                  '${date.day}/${date.month}/${date.year}';
                                                              String timetoday =
                                                                  '${date.hour}:${date.minute}';
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'posts')
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
                                                                  .update({
                                                                /*'Comment': controllerdes.text,
                                          'Date': today,
                                          'Time': timetoday,
                                          'User': 'La Puerta',
                                          'postUrl': 'no image',*/
                                                                'Image': snapshot
                                                                    .data
                                                                    .toString()
                                                              });

                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              postImage(snapshot.data.toString());

                                                              controllerdes
                                                                  .clear();
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
                                            }
                                            if (controllerdes.text.isEmpty) {
                                              return;
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              backgroundColor:
                                                  Color.fromRGBO(4, 99, 128, 1),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 25,
                                                  vertical: 10)),
                                          child: Text(
                                            'Siguiente',
                                            style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontSize: size.width * 0.044,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ]);
                                    }
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }),
                            ],
                          ),
                        ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  Future<void> onProfileTapped() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final storageRef = FirebaseStorage.instance.ref('images/$time.png');
    final imageRef = storageRef.child(currentUser.email.toString());
    final imageBytes = await image.readAsBytes();
    await imageRef.putData(imageBytes);

    setState(() {
      pickedImage = imageBytes;
      photoID = time;
    });
  }

  Future<void> getProfilePicture() async {
    var time = DateTime.now().millisecondsSinceEpoch.toString();
    final storageRef = FirebaseStorage.instance.ref('images/$time.png');
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

class FireStoreDataBase {
  final currentUsera = FirebaseAuth.instance.currentUser!;
  String? downloadURL;
  Future getData() async {
    try {
      await downloadURLExample();
      return downloadURL;
    } catch (e) {
      debugPrint('Error - $e');
      return null;
    }
  }

  Future<void> downloadURLExample() async {
    downloadURL = await FirebaseStorage.instance
        .ref()
        .child(currentUsera.email.toString())
        .getDownloadURL();
    debugPrint(downloadURL.toString());
  }
}
