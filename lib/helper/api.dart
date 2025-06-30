import 'dart:convert';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

//const String urlIP = 'http://192.168.1.48:8000';

getHost() async {
  var response = await http.get(
    Uri.parse(
      'https://technodevwebsite.blogspot.com/p/https77da-105-155-176-99ngrok-freeapp.html',
    ),
  );
  //If the http request is successful the statusCode will be 200
  if (response.statusCode == 200) {
    var document = parse(response.body);
    var host = document.getElementsByTagName('title')[0].text;

    return host;
  }
}

Future<bool> getConnectionApi() async {
  // Update with your FastAPI server URL

  try {
    String urlIP = await getHost();
    final response = await http.get(
      Uri.parse(urlIP),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print('Response: $responseData');
      return true;
    } else {
      print('Failed to get data: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error: $e');
    return false;
  }
}

Future<void> sendDataToFastAPI(token) async {
  String urlIP = await getHost();

  final String url = '$urlIP/token/';
  final Map<String, String> queryParams = {'token': token};
  final Uri uri = Uri.parse(url).replace(queryParameters: queryParams);
  try {
    final response = await http.get(uri);
    // Check the response status
    if (response.statusCode == 200) {
      // Parse the JSON response
      final data = jsonDecode(response.body);
      print('Response: $data');
    } else {
      print('Failed to send data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> postToApiData(String token, int time) async {
  String urlIP = await getHost();
  final url = Uri.parse('$urlIP/send');
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({'token': token, 'time': time});

  try {
    final response = await http.post(url, headers: headers, body: body);
    //var response = await http.post(url, body: {'token': token});
    if (response.statusCode == 200) {
      print('Success: ${response.body}');
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Exception: $e');
  }
}
