import 'package:http/http.dart' as http;

import '../../config.dart';

class Request extends http.Request {

  Request(String method, String path, [Map<String, dynamic>? queryParameters]) : super(method, Uri(scheme: config['api']['scheme'], host: config['api']['host'], port: config['api']['port'], path: path, queryParameters: queryParameters));

}
