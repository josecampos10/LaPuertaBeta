import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Adminclases extends StatefulWidget {
  const Adminclases({
    Key? key,
  }) : super(key: key);

  @override
  State<Adminclases> createState() => _AdminclasesState();
}

class _AdminclasesState extends State<Adminclases> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController controllerdes = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color.fromRGBO(255, 255, 255, 1).withOpacity(0.8),
      body: Container(
        height: size.height * 0.93,
        width: size.width,
        /*decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/foto4.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
          ),
        ),*/
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
                    height: size.height * 0.02,
                  ),
                  Text(
                    'Agregar Clase',
                    style: TextStyle(
                        fontSize: size.width * 0.045,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 0, 0, 0)),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: controller,
                      onChanged: (value) => setState(() {
                        controller.text = value.toString();
                      }),
                      decoration: InputDecoration(
                        labelText: 'Nombre de la clase',
                        prefixIcon: Icon(Icons.add),
                        labelStyle:
                            TextStyle(fontSize: 14, fontFamily: 'Impact'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      controller: controllerdes,
                      onChanged: (value) => setState(() {
                        controllerdes.text = value.toString();
                      }),
                      decoration: InputDecoration(
                        labelText: 'Descripcion de la clase',
                        prefixIcon: Icon(Icons.add),
                        labelStyle:
                            TextStyle(fontSize: 14, fontFamily: 'Impact'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  SizedBox(
                    width: size.height * 0.35,
                    height: size.height * 0.06,
                    child: ElevatedButton(
                      onPressed: () {
                        if (controller.text == '') {
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Agregar una clase'),
                                  content: Text(
                                      'Estás seguro que quieres añadir una clase?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('clases')
                                              .doc(controller.text)
                                              .set({
                                            'Name': controller.text,
                                            'Descripcion': controllerdes.text
                                          });
                                          Navigator.of(context).pop();
                                          controller.clear();
                                          controllerdes.clear();
                                        },
                                        child: Text('Aceptar')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancelar'))
                                  ],
                                );
                              });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Color.fromRGBO(4, 99, 128, 1),
                          padding: EdgeInsets.symmetric(
                              horizontal: 35, vertical: 10)),
                      child: Text(
                        'Confirmar',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: size.width * 0.044,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('clases')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          final snap = snapshot.data!.docs;
                          return Container(
                            constraints: BoxConstraints(
                                minHeight: size.height * 0.4,
                                maxHeight: size.height * 0.5),
                            width: size.width - 30,
                            // height: size.height * 0.27,
                            child: GridView.builder(
                              physics: ScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1, childAspectRatio: 6),
                              shrinkWrap: true,
                              primary: false,
                              itemCount: snap.length,
                              cacheExtent: 1000.0,
                              itemBuilder: (context, index) {
                                return Slidable(
                                  endActionPane: ActionPane(
                                      motion: StretchMotion(),
                                      children: [
                                        SlidableAction(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          onPressed: (context) {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title:
                                                        Text('Eliminar clase'),
                                                    content: Text(
                                                        'Estás seguro que quieres eliminar esta clase?'),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'clases')
                                                                .doc(snapshot
                                                                        .data!
                                                                        .docs[
                                                                    index]['Name'])
                                                                .delete();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              Text('Aceptar')),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              Text('Cancelar'))
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
                                    height: size.height * 0.07,
                                    width: size.width,
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(width: 1),
                                            borderRadius:
                                                BorderRadius.circular(15.0)),
                                        elevation: 50,
                                        shadowColor: Colors.black26,
                                        color: Color.fromRGBO(199, 228, 241, 0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(7),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        snap[index]['Name'],
                                                        style: TextStyle(
                                                          fontSize:
                                                              size.height *
                                                                  0.022,
                                                          fontFamily: '',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromRGBO(
                                                              0, 0, 0, 1),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                    ]),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
