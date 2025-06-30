import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:notification_crypto_coins/loading.dart';
import 'package:notification_crypto_coins/helper/push_notification.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

late String tokenGlobale;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  tokenGlobale = await PushNotification.init();
  runApp(GetMaterialApp(home: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _connectionStatus = false;
  final Connectivity _connectivity = Connectivity();
  void initState() {
    super.initState();
    _checkConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    _updateConnectionStatus(connectivityResult);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    setState(() {
      if (result.contains(ConnectivityResult.wifi)) {
        _connectionStatus = true;
      } else if (result.contains(ConnectivityResult.mobile)) {
        _connectionStatus = true;
      } else if (result.contains(ConnectivityResult.none)) {
        _connectionStatus = false;
      } else {
        _connectionStatus = false;
      }
    });
    print(_connectionStatus);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:
          _connectionStatus
              ? const Loading()
              : const Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off, size: 100, color: Colors.red),
                      SizedBox(height: 20),
                      Text(
                        'No Internet Connection',
                        style: TextStyle(fontSize: 24, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
