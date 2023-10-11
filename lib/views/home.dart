import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? messageBody;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
    initialize();
  }

  init() async {
    String deviceToken = await getDeviceToken();
    print("###################### DEVICE TOKEN #############");
    print(deviceToken);
    print("###################### DEVICE TOKEN #############");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        centerTitle: true,
        title: const Text(
          "Push Noti Testing",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            if (kDebugMode) {
              print("Messaging is : $messageBody");
            }
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Notification"),
                    content: Text(messageBody.toString()),
                    actions: [
                      TextButton(
                        child: Text("Ok"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                });
          },
          child: const Text("Send Noti"),
        ),
      ),
    );
  }

  Future getDeviceToken() async {
    FirebaseMessaging firebaseMessage = FirebaseMessaging.instance;
    String? deviceToken = await firebaseMessage.getToken();

    return (deviceToken == null) ? "" : deviceToken;
  }

  Future initialize() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Got a message whilst in the foreground!');
      }
      if (kDebugMode) {
        print('Message data: ${message.data}');
      }
      messageBody = message.notification!.body!;
      if (message.notification != null) {
        if (kDebugMode) {
          print(
              'Message also contained a notification: ${message.notification!.title}');
        }
      }
    });
  }
}
