import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget{
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context){
     //get the notification message and display on screen
  final message = ModalRoute.of(context)?.settings.arguments as RemoteMessage;
    return Scaffold(
      body: Column(
        children: [
          

          Text(message.notification!.title.toString()),
          //Text(message.notification!.body.toString()),
          //Text(message.data.toString())
        ],
      ),
    );
  }
}