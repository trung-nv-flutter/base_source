import 'dart:convert';

import 'package:base_flutter_source/common/utils.dart';
import 'package:http/http.dart';
import '../extensions/string_extensions.dart';
import '../extensions/map_extensions.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

enum RequestMethod { Get, Post, Patch, Put, Delete }

extension RequestMethodExtension on RequestMethod {
  String get name {
    switch (this) {
      case RequestMethod.Get:
        return "GET";
      case RequestMethod.Post:
        return "POST";
      case RequestMethod.Put:
        return "PUt";
      default:
    }
    return "";
  }
}

enum ResponseCode { OK, FAILED, TokenExpire }

extension ResponseCodeExtension on ResponseCode {
  int get value {
    switch (this) {
      case ResponseCode.OK:
        return 200;
        break;
      case ResponseCode.FAILED:
        return 204;
      default:
    }
    return 0;
  }
}

class BaseAPI {
  bool encodeJSONBodyParams = false;
  //request
  static String API_URL;
  String uri;
  String rootURL = BaseAPI.API_URL;
  Map<String, String> queryParams;
  List<String> splashParams;
  final bodyParams = Map<String, dynamic>();
  RequestMethod method = RequestMethod.Get;
  Map<String, String> headers = Map<String, String>();

  //response
  bool success = false;
  String message = "";
  int code = 0;
  bool isInternetError = false;
  dynamic data;

  internetError() {
    success = false;
    isInternetError = true;
  }

  BaseAPI() {
    initalize();
  }
  initalize() async {}

  parseSuccessResponse(dynamic body) async {}

  request() async {
    try {
      final isInternetConnected = await Utils.isInternetConnected();
      if (!isInternetConnected) {
        internetError();
        return;
      }
      var url = "$rootURL$uri";

      if (queryParams != null) url += "?" + queryParams.toQuery();
      if (splashParams != null) {
        final _uri = splashParams.join("/");
        url += "/" + _uri;
      }
      print(
          "url $url \n headers ${headers.toPostManParams()} \n params ${bodyParams?.toJSON()}");

      http.Response response;
      final _uri = Uri.parse(url);
      if (method == RequestMethod.Get) {
        response = await http.get(_uri, headers: headers);
      } else if (method == RequestMethod.Post) {
        final _body = encodeJSONBodyParams ? bodyParams.toJSON() : bodyParams;
        response = await http.post(_uri, headers: headers, body: _body);
      } else if (method == RequestMethod.Patch) {
        response = await http.patch(_uri, headers: headers, body: bodyParams);
      } else if (method == RequestMethod.Delete) {
        response = await http.delete(_uri, headers: headers);
      }
      await parseResponse(response);
    } catch (e) {
      print("error ${e}");
      success = false;
      message = e.toString();
    }
  }

  upload() async {
    var url = "$rootURL$uri";
    final request = http.MultipartRequest(
      method.name,
      Uri.parse(url),
    );
    final map = Map<String, dynamic>();
    for (var key in headers.keys) {
      request.headers[key] = headers[key];
    }
    print("url $url body ${bodyParams.toQuery()}");
    for (var key in bodyParams.keys) {
      var value = bodyParams[key];
      if (value is String) {
        bool isFile = await value.isPath();
        if (isFile) {
          final fileName = "${DateTime.now().millisecondsSinceEpoch}.jpeg";
          final file = await http.MultipartFile.fromPath(key, value,
              contentType: MediaType("image", "jpeg/png"), filename: fileName);
          map[key] = file;
          request.files.add(file);
          continue;
        }
      }
      map[key] = value;
      request.fields[key] = value;
    }
    http.StreamedResponse _response = await request.send();
    http.Response response = await http.Response.fromStream(_response);
    await parseResponse(response);
  }

  parseResponse(Response response) async {
    var body;
    if (response.body != ArgumentError.notNull() && response.body.isNotEmpty)
      body = json.decode(response.body);
    if (response.statusCode == ResponseCode.FAILED.value &&
        response.body.isEmpty) body = "";
    if (body == null) return internetError();
    // print(body);

    if (response.statusCode != ResponseCode.OK.value) {
      code = response.statusCode;
      success = false;
      if (body != "") {
        message = body["Message"];
      }
      return;
    }
    code = response.statusCode;
    success = true;
    parseSuccessResponse(body);
  }
}
