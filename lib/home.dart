import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notification_crypto_coins/helper/helpers.dart';
import 'package:notification_crypto_coins/main.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    insertToken(tokenGlobale);
    print('token: $tokenGlobale');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(5),
        child: FutureBuilder<List<dynamic>>(
          future: getDataCoins(),

          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(snapshot.data[index][1]),
                        backgroundColor: Colors.transparent,
                      ),
                      title: Text(
                        snapshot.data[index][2].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(snapshot.data[index][3]),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_alert),
                        color:
                            snapshot.data[index][4] == true
                                ? Colors.yellowAccent
                                : Colors.grey,
                        onPressed: () async {
                          if (snapshot.data[index][4] == true) {
                            //favoriteCoin(snapshot.data[index][0], false);
                          } else {
                            //favoriteCoin(snapshot.data[index][0], true);
                          }

                          setState(() {
                            //addCoins(snapshot.data[index]['id']);
                          });
                        },
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
