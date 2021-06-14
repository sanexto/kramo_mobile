import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import './req/req.dart' as req;
import './res/res.dart' as res;

Future<res.Response> send (dynamic request) async {

  if (request is req.Request || request is req.MultipartRequest) {

    final FlutterSecureStorage storage = FlutterSecureStorage();

    String? token;

    try {

      token = await storage.read(key: 'token');

    } catch (_) {}

    request.headers[HttpHeaders.authorizationHeader] = 'Bearer ${token ?? ''}';

    final res.Response jsonResponse = res.Response(0, {});

    http.StreamedResponse? streamedResponse;

    try {

      streamedResponse = await request.send();

    } catch (_) {}

    if (streamedResponse != null) {

      final http.Response response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode <= 299) {

        Map<String, dynamic>? json;

        try {

          json = jsonDecode(response.body);

        } catch (_) {}

        if (json != null && json is Map<String, dynamic> && json.containsKey('status') && json['status'] is int && json.containsKey('body') && json['body'] is Map<String, dynamic>) {

          jsonResponse.status = json['status'];
          jsonResponse.body = json['body'];

        } else {

          jsonResponse.status = res.Status.BadResponse;
          jsonResponse.body['message'] = 'Formato de respuesta inválido';

        }

      } else {

        jsonResponse.status = res.Status.ServerError;
        jsonResponse.body['message'] = 'Ocurrió un error en el servidor';

      }

    } else {

      jsonResponse.status = res.Status.FailedConnection;
      jsonResponse.body['message'] = 'No se pudo establecer una conexión';

    }

    return jsonResponse;

  } else {

    throw ArgumentError.value(request);

  }

}
