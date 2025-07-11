import 'package:get/get.dart';
import 'package:postgres/postgres.dart';
import 'package:notification_crypto_coins/helper/api.dart';
import 'package:notification_crypto_coins/main.dart';
import 'package:url_launcher/url_launcher.dart';

Future<Connection> _getConnection() async {
  print('has connection!');
  return await Connection.open(
    Endpoint(
      host: 'pg-b7b4af8-notification-a9fb.b.aivencloud.com',
      port: 28691,
      database: 'defaultdb',
      username: 'avnadmin',
      password: 'AVNS_lCnbZGqy7vDH06IT2hO',
    ),
  );
}

Future<bool> insertToken(String token) async {
  bool connectApi = await getConnectionApi();
  print(token);
  
  if (connectApi == false) {
    print('Connection to API failed!');
    return false;
  }

  final conn = await _getConnection();

  final result = await conn.execute(
    Sql.named('SELECT count(1)>0 FROM public.cryptos WHERE token = @token'),
    parameters: {'token': token},
  );

  if (result.first[0] == true) {
    print('Token already exists!');
  } else {
    await conn.execute(
      Sql.named('INSERT INTO public.cryptos (token) VALUES (@token)'),
      parameters: {'token': token},
    );
    print('Token inserted successfully!');
  }

  conn.close();
  return true;

  //await findCoin();
}

/*Future<List<dynamic>> getcoinsInfo() async {
  final data = await rootBundle.loadString('assets/coins.json');
  final List<dynamic> coins = json.decode(data);

  return coins;
}*/

Future<void> findCoin() async {
  final conn = await _getConnection();
  final result = await conn.execute(
    Sql.named('SELECT crypto_name FROM public.cryptos WHERE token = @token'),
    parameters: {'token': tokenGlobale},
  );

  result[0].first as String;
  conn.close();
  //bool hasCoin = text.contains(coin);
}

Future<List<dynamic>> getDataCoins() async {
  final conn = await _getConnection();
  final List<dynamic> result = await conn.execute(
    'SELECT id, img, symbol, name, add_list FROM public.coins ORDER BY id ASC;',
  );

  return result;
}

Future<void> addCoin(String token, String coin) async {
  final conn = await _getConnection();
  final result = await conn.execute(
    Sql.named('SELECT crypto_name FROM public.cryptos WHERE token = @token'),
    parameters: {'token': token},
  );
  coin = '${result[0].first as String},$coin';
  await conn.execute(
    Sql.named(
      'update public.cryptos set crypto_name = @coin where token = @token',
    ),
    parameters: {'token': token, 'coin': coin},
  );
  print('Coin added to favorites!');
  conn.close();
}

Future<void> removeCoin(String token, String coin) async {
  final conn = await _getConnection();
  final result = await conn.execute(
    Sql.named('SELECT crypto_name FROM public.cryptos WHERE token = @token'),
    parameters: {'token': token},
  );
  var str = result[0].first as String;

  coin = str.replaceAll(",$coin", "");
  await conn.execute(
    Sql.named(
      'update public.cryptos set crypto_name = @coin where token = @token',
    ),
    parameters: {'token': token, 'coin': coin},
  );
  print('Coin removed!');
  conn.close();
}

Future<bool> chechStartApi(String token) async {
  final conn = await _getConnection();

  final result = await conn.execute(
    Sql.named('SELECT start FROM public.cryptos WHERE token = @token'),
    parameters: {'token': token},
  );
  bool start = result[0].first as bool;
  print('Start API: $start');
  conn.close();
  return start;
}

Future<void> startApiCoin(String token, bool start) async {
  final conn = await _getConnection();

  await conn.execute(
    Sql.named('update public.cryptos set start = @start  where token = @token'),
    parameters: {'token': token, 'start': start},
  );
  print('Api started!');
  conn.close();
}

Future<void> stopApiCoin(String token, bool stop) async {
  final conn = await _getConnection();

  await conn.execute(
    Sql.named('update public.cryptos set start = @stop  where token = @token'),
    parameters: {'token': token, 'stop': stop},
  );
  print('Api stopped!');
  conn.close();
}

Future<void> launchLink(String link, {bool isNewTab = true}) async {
  /* await launchUrl(
      Uri.parse(link),
      webOnlyWindowName: isNewTab ? '_blank' : '_self',
    );*/
  await Future.delayed(Duration(milliseconds: 500));
  await launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
}

/*Future<void> InsertCoins() async {
  final conn = await _getConnection();
  final data = await rootBundle.loadString('assets/coins.json');
  final List<dynamic> coins = json.decode(data);
  List<String> coinNoList = [
    'usdt',
    'usdc',
    'usds',
    'bsc-usd',
    'usde',
    'buidl',
  ];
  for (var element in coins) {
    bool hasCoin = true;
    for (var c in coinNoList) {
      if (element['symbol'] == c) {
        hasCoin = false;
      }
    }
    if (hasCoin) {
      await conn.execute(
        Sql.named(
          'INSERT INTO public.coins (img,symbol,name) VALUES (@img,@symbol,@name)',
        ),
        parameters: {
          'img': element['image'],
          'symbol': element['symbol'],
          'name': element['id'],
        },
      );
      print(element['symbol']);
    }
  }
}*/
