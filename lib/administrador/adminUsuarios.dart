import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lapuerta2/administrador/admin_detalles_users.dart';

final gridItems = [
  'Todos',
  'Estudiantes',
  'Profesores',
  'Staff',
  'Voluntarios'
];

class AdminUsuarios extends StatefulWidget {
  const AdminUsuarios({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminUsuarios> createState() => _AdminUsuariosState();
}

class _AdminUsuariosState extends State<AdminUsuarios> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController controllerdes = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;
  int selectedIndex = 0;

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
          physics: NeverScrollableScrollPhysics(),
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
                Text(
                  'Usuarios',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: size.width * 0.045,
                      fontFamily: '',
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            SingleChildScrollView(
              padding: EdgeInsets.all(size.width * 0.001),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: size.height * 0.045,
                    child: GridView.builder(
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: size.width * 0.0009),
                      shrinkWrap: true,
                      primary: false,
                      itemCount: gridItems.length,
                      cacheExtent: 1000.0,
                      itemBuilder: (BuildContext context, int position) {
                        return AnimationConfiguration.staggeredGrid(
                          position: 1,
                          columnCount: 1,
                          child: ScaleAnimation(
                            duration: Duration(milliseconds: 400),
                            child: FadeInAnimation(
                              child: InkWell(
                                onTap: () =>
                                    setState(() => selectedIndex = position),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          size.width * 0.03)),
                                  elevation: size.height * 0.5,
                                  //shadowColor: Colors.black26,
                                  color: (selectedIndex == position)
                                      ? Color.fromRGBO(231, 155, 56, 1)
                                      : Color.fromRGBO(238, 135, 1, 0),
                                  child: Padding(
                                    padding: EdgeInsets.all(size.width * 0.01),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.0,
                                              ),
                                              Text(
                                                gridItems[position],
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: size.height * 0.018,
                                                  fontFamily: '',
                                                  fontWeight: FontWeight.bold,
                                                  color: (selectedIndex ==
                                                          position)
                                                      ? Color.fromRGBO(
                                                          0, 0, 0, 1)
                                                      : Color.fromRGBO(
                                                          143, 143, 143, 1),
                                                ),
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
                  )
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                    if (snapshot.hasData && selectedIndex == 4) {
                      final snap = snapshot.data!.docs;

                      return RefreshIndicator(
                        color: Color.fromRGBO(3, 69, 88, 1),
                        backgroundColor: Colors.white,
                        displacement: 1,
                        strokeWidth: 3,
                        onRefresh: () async {},
                        child: SizedBox(
                          height: size.height * 0.787,
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
                                  DocumentSnapshot documentSnapshot =
                                      snapshot.data!.docs[index];
                                  if (snap[index]['rol'] == 'Voluntario') {
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
                                                        BorderRadius.circular(
                                                            10.0),
                                                    onPressed: (context) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Eliminar recurso'),
                                                              content: Text(
                                                                  'Estás seguro que quieres borrar un recurso?'),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        'Aceptar')),
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
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
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AdminDetallesHome(
                                                                documentSnapshot:
                                                                    documentSnapshot)));
                                              },
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            size.width * 0.02)),
                                                elevation: size.height * 0.0,
                                                shadowColor: Colors.black,
                                                color: Color.fromRGBO(
                                                    219, 219, 219, 0),
                                                child: Container(
                                                  //constraints: const BoxConstraints(minHeight: ),
                                                  //width: 180,
                                                  //height: 20,
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              width: 1,
                                                              color: const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  211,
                                                                  211,
                                                                  211)))),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        size.width * 0.03),
                                                    child: Column(
                                                      children: [
                                                        Row(children: [
                                                          Icon(
                                                            Icons.person_3,
                                                            size: size.height *
                                                                0.02,
                                                            color:
                                                                Color.fromRGBO(
                                                                    4,
                                                                    99,
                                                                    128,
                                                                    1),
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.02,
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              snap[index]
                                                                  ['name'],
                                                              style: TextStyle(
                                                                fontSize:
                                                                    size.height *
                                                                        0.019,
                                                                fontFamily:
                                                                    'JosefinSans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
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
                                                                0.3,
                                                          ),
                                                        ]),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.065,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                snap[index]
                                                                    ['rol'],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: size
                                                                          .height *
                                                                      0.0162,
                                                                  fontFamily:
                                                                      'Impact',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: Color
                                                                          .fromRGBO(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              1)
                                                                      .withOpacity(
                                                                          0.9),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                }),
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasData && selectedIndex == 3) {
                      final snap = snapshot.data!.docs;

                      return RefreshIndicator(
                        color: Color.fromRGBO(3, 69, 88, 1),
                        backgroundColor: Colors.white,
                        displacement: 1,
                        strokeWidth: 3,
                        onRefresh: () async {},
                        child: SizedBox(
                          height: size.height * 0.787,
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
                                  DocumentSnapshot documentSnapshot =
                                      snapshot.data!.docs[index];
                                  if (snap[index]['rol'] == 'Staff') {
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
                                                        BorderRadius.circular(
                                                            10.0),
                                                    onPressed: (context) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Eliminar recurso'),
                                                              content: Text(
                                                                  'Estás seguro que quieres borrar un recurso?'),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        'Aceptar')),
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
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
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AdminDetallesHome(
                                                                documentSnapshot:
                                                                    documentSnapshot)));
                                              },
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            size.width * 0.02)),
                                                elevation: size.height * 0.0,
                                                shadowColor: Colors.black,
                                                color: Color.fromRGBO(
                                                    219, 219, 219, 0),
                                                child: Container(
                                                  //constraints: const BoxConstraints(minHeight: ),
                                                  //width: 180,
                                                  //height: 20,
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              width: 1,
                                                              color: const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  211,
                                                                  211,
                                                                  211)))),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        size.width * 0.03),
                                                    child: Column(
                                                      children: [
                                                        Row(children: [
                                                          Icon(
                                                            Icons.person_3,
                                                            size: size.height *
                                                                0.02,
                                                            color:
                                                                Color.fromRGBO(
                                                                    4,
                                                                    99,
                                                                    128,
                                                                    1),
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.02,
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              snap[index]
                                                                  ['name'],
                                                              style: TextStyle(
                                                                fontSize:
                                                                    size.height *
                                                                        0.019,
                                                                fontFamily:
                                                                    'JosefinSans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
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
                                                                0.3,
                                                          ),
                                                        ]),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.065,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                snap[index]
                                                                    ['rol'],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: size
                                                                          .height *
                                                                      0.0162,
                                                                  fontFamily:
                                                                      'Impact',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: Color
                                                                          .fromRGBO(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              1)
                                                                      .withOpacity(
                                                                          0.9),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                }),
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasData && selectedIndex == 2) {
                      final snap = snapshot.data!.docs;

                      return RefreshIndicator(
                        color: Color.fromRGBO(3, 69, 88, 1),
                        backgroundColor: Colors.white,
                        displacement: 1,
                        strokeWidth: 3,
                        onRefresh: () async {},
                        child: SizedBox(
                          height: size.height * 0.787,
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
                                  DocumentSnapshot documentSnapshot =
                                      snapshot.data!.docs[index];
                                  if (snap[index]['rol'] == 'Profesor') {
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
                                                        BorderRadius.circular(
                                                            10.0),
                                                    onPressed: (context) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Eliminar recurso'),
                                                              content: Text(
                                                                  'Estás seguro que quieres borrar un recurso?'),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        'Aceptar')),
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
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
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AdminDetallesHome(
                                                                documentSnapshot:
                                                                    documentSnapshot)));
                                              },
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            size.width * 0.02)),
                                                elevation: size.height * 0.0,
                                                shadowColor: Colors.black,
                                                color: Color.fromRGBO(
                                                    219, 219, 219, 0),
                                                child: Container(
                                                  //constraints: const BoxConstraints(minHeight: ),
                                                  //width: 180,
                                                  //height: 20,
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              width: 1,
                                                              color: const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  211,
                                                                  211,
                                                                  211)))),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        size.width * 0.03),
                                                    child: Column(
                                                      children: [
                                                        Row(children: [
                                                          Icon(
                                                            Icons.person_3,
                                                            size: size.height *
                                                                0.02,
                                                            color:
                                                                Color.fromRGBO(
                                                                    4,
                                                                    99,
                                                                    128,
                                                                    1),
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.02,
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              snap[index]
                                                                  ['name'],
                                                              style: TextStyle(
                                                                fontSize:
                                                                    size.height *
                                                                        0.019,
                                                                fontFamily:
                                                                    'JosefinSans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
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
                                                                0.03,
                                                          ),
                                                        ]),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.065,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                snap[index]
                                                                    ['rol'],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: size
                                                                          .height *
                                                                      0.0162,
                                                                  fontFamily:
                                                                      'Impact',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: Color
                                                                          .fromRGBO(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              1)
                                                                      .withOpacity(
                                                                          0.9),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                }),
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasData && selectedIndex == 1) {
                      final snap = snapshot.data!.docs;

                      return RefreshIndicator(
                        color: Color.fromRGBO(3, 69, 88, 1),
                        backgroundColor: Colors.white,
                        displacement: 1,
                        strokeWidth: 3,
                        onRefresh: () async {},
                        child: SizedBox(
                          height: size.height * 0.787,
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
                                   DocumentSnapshot documentSnapshot =
                                      snapshot.data!.docs[index];
                                  if (snap[index]['rol'] == 'Estudiante') {
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
                                                        BorderRadius.circular(
                                                            10.0),
                                                    onPressed: (context) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Eliminar recurso'),
                                                              content: Text(
                                                                  'Estás seguro que quieres borrar un recurso?'),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        'Aceptar')),
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
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
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AdminDetallesHome(
                                                                documentSnapshot:
                                                                    documentSnapshot)));
                                              },
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            size.width * 0.02)),
                                                elevation: size.height * 0.0,
                                                shadowColor: Colors.black,
                                                color: Color.fromRGBO(
                                                    219, 219, 219, 0),
                                                child: Container(
                                                  //constraints: const BoxConstraints(minHeight: ),
                                                  //width: 180,
                                                  //height: 20,
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              width: 1,
                                                              color: const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  211,
                                                                  211,
                                                                  211)))),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        size.width * 0.03),
                                                    child: Column(
                                                      children: [
                                                        Row(children: [
                                                          Icon(
                                                            Icons.person_3,
                                                            size: size.height *
                                                                0.02,
                                                            color:
                                                                Color.fromRGBO(
                                                                    4,
                                                                    99,
                                                                    128,
                                                                    1),
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.02,
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              snap[index]
                                                                  ['name'],
                                                              style: TextStyle(
                                                                fontSize:
                                                                    size.height *
                                                                        0.019,
                                                                fontFamily:
                                                                    'JosefinSans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
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
                                                                0.3,
                                                          ),
                                                        ]),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.065,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                snap[index]
                                                                    ['rol'],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: size
                                                                          .height *
                                                                      0.0162,
                                                                  fontFamily:
                                                                      'Impact',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: Color
                                                                          .fromRGBO(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              1)
                                                                      .withOpacity(
                                                                          0.9),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                }),
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasData && selectedIndex == 0) {
                      final snap = snapshot.data!.docs;
                      return RefreshIndicator(
                        color: Color.fromRGBO(3, 69, 88, 1),
                        backgroundColor: Colors.white,
                        displacement: 1,
                        strokeWidth: 3,
                        onRefresh: () async {},
                        child: SizedBox(
                          height: size.height * 0.787,
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
                                 DocumentSnapshot documentSnapshot =
                                    snapshot.data!.docs[index];
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
                                                              'Eliminar recurso'),
                                                          content: Text(
                                                              'Estás seguro que quieres borrar un recurso?'),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
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
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AdminDetallesHome(
                                                            documentSnapshot:
                                                                documentSnapshot)));
                                          },
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        size.width * 0.02)),
                                            elevation: size.height * 0.0,
                                            shadowColor: Colors.black,
                                            color: Color.fromRGBO(
                                                219, 219, 219, 0),
                                            child: Container(
                                              //constraints: const BoxConstraints(minHeight: ),
                                              //width: 180,
                                              //height: 20,
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          width: 1,
                                                          color: const Color
                                                              .fromARGB(255,
                                                              211, 211, 211)))),
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                    size.width * 0.01),
                                                child: Column(
                                                  children: [
                                                    Row(children: [
                                                      Icon(
                                                        Icons.person_3,
                                                        size:
                                                            size.height * 0.02,
                                                        color: Color.fromRGBO(
                                                            4, 99, 128, 1),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            size.width * 0.02,
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          snap[index]['name'],
                                                          style: TextStyle(
                                                            fontSize:
                                                                size.height *
                                                                    0.018,
                                                            fontFamily: '',
                                                            fontWeight:
                                                                FontWeight.w700,
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
                                                        width:
                                                            size.width * 0.02,
                                                      ),
                                                    ]),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: size.width *
                                                              0.065,
                                                        ),
                                                        Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Text(
                                                            snap[index]['rol'],
                                                            style: TextStyle(
                                                              fontSize:
                                                                  size.height *
                                                                      0.0162,
                                                              fontFamily:
                                                                  'Impact',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color: Color
                                                                      .fromRGBO(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          1)
                                                                  .withOpacity(
                                                                      0.9),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
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
                      return SizedBox();
                    }
                  }),
            )
          ]),
        ),
      ),
    );
  }
}
