import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notification_crypto_coins/helper/database_helper.dart';
import 'package:notification_crypto_coins/model/model_coins.dart';
import 'package:flutter/services.dart';
import 'package:notification_crypto_coins/controller/controller_send.dart';
import 'package:notification_crypto_coins/helper/api.dart';
import 'package:notification_crypto_coins/helper/helpers.dart';
import 'package:notification_crypto_coins/main.dart';
import 'package:get/get.dart';

class Send extends StatefulWidget {
  const Send({super.key});

  @override
  State<Send> createState() => _SendState();
}

class _SendState extends State<Send> {
  List<int> listTime = [1, 5, 15, 30, 60];
  int? selectedTime; // Variable to store the selected time

  @override
  void initState() {
    super.initState();
    print('token: $tokenGlobale');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Crypto Coins'),
        leading: Image.asset('assets/icon.png'),
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.amber,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder<List<ModelCoins>>(
            future: DatabaseHelper().getCoins(),

            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                        border: Border.all(color: Colors.amber, width: 1),
                      ),
                      child: ListTile(
                        onTap: () {
                          var link =
                              "https://www.coingecko.com/en/coins/${snapshot.data[index].name}";
                          launchLink(link, isNewTab: true);
                        },
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(
                            snapshot.data[index].img,
                          ),
                        ),

                        title: Text(
                          snapshot.data[index].symbol.toUpperCase(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(snapshot.data[index].name),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.notifications_on_outlined,
                            color:
                                snapshot.data[index].selected == 1
                                    ? Colors.green
                                    : Colors.grey,
                            size: 30,
                          ),
                          onPressed: () async {
                            if (snapshot.data[index].selected == 1) {
                              await removeCoin(
                                tokenGlobale,
                                snapshot.data[index].name,
                              );
                              await DatabaseHelper().removeCoinNotification(
                                snapshot.data[index].id,
                              );
                            } else {
                              await addCoin(
                                tokenGlobale,
                                snapshot.data[index].name,
                              );
                              await DatabaseHelper().addCoinNotification(
                                snapshot.data[index].id,
                              );
                            }
                            setState(() {});
                          },
                        ),
                      ),
                    );
                  },
                );
              }
              return Text('');
            },
          ),

          // ignore: deprecated_member_use
          FutureBuilder(
            future: chechStartApi(tokenGlobale),

            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return GetBuilder(
                  init: ControllerSend(),
                  builder:
                      (controller) =>
                          controller.SendNotif == true
                              ? Container(color: Colors.grey.withOpacity(0.6))
                              : Text(''),
                );
              }
              return Container(
                alignment: Alignment.center,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Waiting for Connection',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
              ); // Show a loading indicator while waiting for data
            },
          ),
        ],
      ),

      bottomNavigationBar: GetBuilder(
        init: ControllerSend(),
        builder:
            (controller) => BottomNavigationBar(
              backgroundColor: Colors.amber,
              unselectedItemColor: Colors.black,
              selectedItemColor: Colors.black,
              iconSize: 30,
              items:
                  //snapshot.data == false
                  controller.SendNotif == false
                      ? [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.play_arrow),
                          label: 'Start',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.timelapse_sharp),
                          label:
                              selectedTime == null
                                  ? 'Time'
                                  : '$selectedTime min',
                        ),
                      ]
                      : [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.pause),
                          label: 'Stop',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.timelapse_sharp),
                          label: 'Click Stop to change time ',
                        ),
                      ],
              onTap:
                  controller.pressStop
                      ? null
                      : (index) async {
                        if (index == 0) {
                          if (controller.SendNotif == true) {
                            selectedTime = null;
                            controller.waitStop();
                            await stopApiCoin(tokenGlobale, false);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Wait please...'),
                                duration: Duration(seconds: 15),
                                backgroundColor: Colors.black,
                              ),
                            );

                            await Future.delayed(
                              const Duration(seconds: 15),
                              () {
                                controller.sendStop();
                              },
                            );
                          }

                          if (selectedTime != null &&
                              controller.SendNotif == false) {
                            await startApiCoin(tokenGlobale, true);
                            await Future.delayed(
                              const Duration(seconds: 1),
                              () {
                                controller.sendStart();
                              },
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'You will receive notifications every $selectedTime minutes',
                                ),
                                duration: Duration(seconds: 3),
                                action: SnackBarAction(
                                  label: 'Close',
                                  textColor: const Color.fromRGBO(
                                    255,
                                    193,
                                    7,
                                    1,
                                  ),
                                  onPressed: () async {
                                    SystemNavigator.pop();
                                  },
                                ),

                                backgroundColor: Colors.black,
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.all(10),
                              ),
                            );

                            await postToApiData(tokenGlobale, selectedTime!);
                          }
                          //////////////////////////////////////////////////////////////////////////////
                          if (selectedTime == null &&
                              controller.SendNotif == false) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please select a time !'),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.black,
                              ),
                            );
                          }
                        } else if (index == 1) {
                          // if (snapshot.data == false) {
                          if (controller.SendNotif == false) {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Select Time',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      DropdownButton<int>(
                                        value: selectedTime,
                                        hint: Text('Choose time'),
                                        items:
                                            listTime.map((int value) {
                                              return DropdownMenuItem<int>(
                                                value: value,
                                                child: Text('$value minutes'),
                                              );
                                            }).toList(),
                                        onChanged: (int? newValue) {
                                          selectedTime = newValue;
                                          print(selectedTime);

                                          Navigator.pop(context);
                                          controller
                                              .changeBar(); // Close the modal
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        }
                        // Update the UI
                      },
            ),
      ),
    );
  }
}
