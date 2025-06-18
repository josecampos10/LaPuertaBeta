import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AdminDetallesHome extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  const AdminDetallesHome({Key? key, required this.documentSnapshot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: size.height,
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
          child: Column(children: [
            Container(
              width: size.width,
              height: size.height * 0.2,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.08,
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
            ),
            Container(
              width: size.width - 30,
              height: size.height * 0.6,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color.fromRGBO(212, 129, 4, 0.705)),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    width: size.width - 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        color: Color.fromRGBO(4, 99, 128, 1)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: Text(
                          'La Puerta Waco',
                          style: TextStyle(
                              fontSize: size.height * 0.025,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * 0.05,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                //color: Colors.white,
                                child: Text(
                                  ' Nombre: ',
                                  style: TextStyle(
                                      fontSize: size.height * 0.02,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.02,
                              ),
                              Text(
                                documentSnapshot['name'],
                                style: TextStyle(
                                    fontSize: size.height * 0.025,
                                    fontFamily: 'JosefinSans',
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * 0.05,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: Text(
                                  ' Correo: ',
                                  style: TextStyle(
                                      fontSize: size.height * 0.02,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.02,
                              ),
                              Text(
                                documentSnapshot['email'],
                                style: TextStyle(
                                    fontSize: size.height * 0.02,
                                    fontFamily: 'JosefinSans',
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * 0.05,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: Text(
                                  ' Función: ',
                                  style: TextStyle(
                                      fontSize: size.height * 0.02,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.02,
                              ),
                              Text(
                                documentSnapshot['rol'],
                                style: TextStyle(
                                    fontSize: size.height * 0.02,
                                    fontFamily: 'JosefinSans',
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Container(
                                    height: size.height * 0.025,
                                    width: size.width - 20,
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(4, 99, 128, 1)),
                                    child: Text(
                                      'Registro',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.height * 0.015,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text('ESL PM'),
                                  ToggleSwitch(
                                    customWidths: [50.0, 90.0],
                                    cornerRadius: 20.0,
                                    activeBgColors: [
                                      [const Color.fromARGB(255, 146, 28, 28)],
                                      [const Color.fromARGB(255, 28, 100, 26)]
                                    ],
                                    activeFgColor: Colors.white,
                                    inactiveBgColor:
                                        const Color.fromARGB(255, 61, 61, 61),
                                    inactiveFgColor: Colors.white,
                                    totalSwitches: 2,
                                    labels: ['', 'YES'],
                                    icons: [Icons.cancel, null],
                                    onToggle: (index) {
                                      if (index == 1) {
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(documentSnapshot['email'])
                                            .update({'ESLpm': 'inscrito'});
                                      } else {
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(documentSnapshot['email'])
                                            .update({'ESLpm': 'no inscrito'});
                                      }
                                      print('switched to: $index');
                                    },
                                  ),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  Text('ESL AM'),
                                  ToggleSwitch(
                                    customWidths: [50.0, 90.0],
                                    cornerRadius: 20.0,
                                    activeBgColors: [
                                      [const Color.fromARGB(255, 146, 28, 28)],
                                      [const Color.fromARGB(255, 28, 100, 26)]
                                    ],
                                    activeFgColor: Colors.white,
                                    inactiveBgColor:
                                        const Color.fromARGB(255, 61, 61, 61),
                                    inactiveFgColor: Colors.white,
                                    totalSwitches: 2,
                                    labels: ['', 'YES'],
                                    icons: [Icons.cancel, null],
                                    onToggle: (index) {
                                      print('switched to: $index');
                                    },
                                  ),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  Text('GED PM'),
                                  ToggleSwitch(
                                    customWidths: [50.0, 90.0],
                                    cornerRadius: 20.0,
                                    activeBgColors: [
                                      [const Color.fromARGB(255, 146, 28, 28)],
                                      [const Color.fromARGB(255, 28, 100, 26)]
                                    ],
                                    activeFgColor: Colors.white,
                                    inactiveBgColor:
                                        const Color.fromARGB(255, 61, 61, 61),
                                    inactiveFgColor: Colors.white,
                                    totalSwitches: 2,
                                    labels: ['', 'YES'],
                                    icons: [Icons.cancel, null],
                                    onToggle: (index) {
                                      print('switched to: $index');
                                    },
                                  ),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  Text('GED AM'),
                                  ToggleSwitch(
                                    customWidths: [50.0, 90.0],
                                    cornerRadius: 20.0,
                                    activeBgColors: [
                                      [const Color.fromARGB(255, 146, 28, 28)],
                                      [const Color.fromARGB(255, 28, 100, 26)]
                                    ],
                                    activeFgColor: Colors.white,
                                    inactiveBgColor:
                                        const Color.fromARGB(255, 61, 61, 61),
                                    inactiveFgColor: Colors.white,
                                    totalSwitches: 2,
                                    labels: ['', 'YES'],
                                    icons: [Icons.cancel, null],
                                    onToggle: (index) {
                                      print('switched to: $index');
                                    },
                                  ),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  )
                                ],
                              ),
                              SizedBox(
                                width: size.width * 0.1,
                              ),
                              Column(
                                children: [
                                  Text('CIUDADANIA'),
                                  ToggleSwitch(
                                    customWidths: [50.0, 90.0],
                                    cornerRadius: 20.0,
                                    activeBgColors: [
                                      [const Color.fromARGB(255, 146, 28, 28)],
                                      [const Color.fromARGB(255, 28, 100, 26)]
                                    ],
                                    activeFgColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    inactiveBgColor:
                                        const Color.fromARGB(255, 61, 61, 61),
                                    inactiveFgColor: Colors.white,
                                    totalSwitches: 2,
                                    labels: ['', 'YES'],
                                    icons: [Icons.cancel, null],
                                    onToggle: (index) {
                                      print('switched to: $index');
                                    },
                                  ),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  Text('COSTURA'),
                                  ToggleSwitch(
                                    customWidths: [50.0, 90.0],
                                    cornerRadius: 20.0,
                                    activeBgColors: [
                                      [const Color.fromARGB(255, 146, 28, 28)],
                                      [const Color.fromARGB(255, 28, 100, 26)]
                                    ],
                                    activeFgColor: Colors.white,
                                    inactiveBgColor:
                                        const Color.fromARGB(255, 61, 61, 61),
                                    inactiveFgColor: Colors.white,
                                    totalSwitches: 2,
                                    labels: ['', 'YES'],
                                    icons: [Icons.cancel, null],
                                    onToggle: (index) {
                                      print('switched to: $index');
                                    },
                                  ),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  Text('COSTURA 2'),
                                  ToggleSwitch(
                                    customWidths: [50.0, 90.0],
                                    cornerRadius: 20.0,
                                    activeBgColors: [
                                      [const Color.fromARGB(255, 146, 28, 28)],
                                      [const Color.fromARGB(255, 28, 100, 26)]
                                    ],
                                    activeFgColor: Colors.white,
                                    inactiveBgColor:
                                        const Color.fromARGB(255, 61, 61, 61),
                                    inactiveFgColor: Colors.white,
                                    totalSwitches: 2,
                                    labels: ['', 'YES'],
                                    icons: [Icons.cancel, null],
                                    onToggle: (index) {
                                      print('switched to: $index');
                                    },
                                  ),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  Text('GED AM'),
                                  ToggleSwitch(
                                    customWidths: [50.0, 90.0],
                                    cornerRadius: 20.0,
                                    activeBgColors: [
                                      [const Color.fromARGB(255, 146, 28, 28)],
                                      [const Color.fromARGB(255, 28, 100, 26)]
                                    ],
                                    activeFgColor: Colors.white,
                                    inactiveBgColor:
                                        const Color.fromARGB(255, 61, 61, 61),
                                    inactiveFgColor: Colors.white,
                                    totalSwitches: 2,
                                    labels: ['', 'YES'],
                                    icons: [Icons.cancel, null],
                                    onToggle: (index) {
                                      print('switched to: $index');
                                    },
                                  ),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ))
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}


