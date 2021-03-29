import 'dart:convert';

import 'package:base_fluttter_source/common/utils.dart';
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

class RequestAPIResponse {
  bool success = false;
  String message = "";
  String status = "";
  int code = 0;
  bool isInternetError = false;
  dynamic data;

  static RequestAPIResponse internetError() {
    final response = RequestAPIResponse();
    response.success = false;
    response.isInternetError = true;
    return response;
  }
}

class BaseAPI {
  static String API_URL;
  String uri;
  String rootURL = BaseAPI.API_URL;
  Map<String, String> queryParams;
  List<String> splashParams;
  final bodyParams = Map<String, dynamic>();
  RequestMethod method = RequestMethod.Get;
  Map<String, String> headers = Map<String, String>();

  BaseAPI() {
    initalize();
  }
  initalize() async {}

  dynamic parseSuccessResponse(dynamic data) {}

  Future<RequestAPIResponse> request() async {
    final isInternetConnected = await Utils.isInternetConnected();
    if (!isInternetConnected) {
      return RequestAPIResponse.internetError();
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
      response =
          await http.post(_uri, headers: headers, body: bodyParams.toJSON());
    } else if (method == RequestMethod.Patch) {
      response = await http.patch(_uri, headers: headers, body: bodyParams);
    } else if (method == RequestMethod.Delete) {
      response = await http.delete(_uri, headers: headers);
    }
    final result = await parseResponse(response);
    return result;
  }

  Future<RequestAPIResponse> upload() async {
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
    final result = await parseResponse(response);
    print("uploaded ${result.data}");

    return result;
  }

  Future<RequestAPIResponse> parseResponse(Response response) async {
    var body;
    if (response.body != ArgumentError.notNull() && response.body.isNotEmpty)
      body = json.decode(response.body);
    if (response.statusCode == ResponseCode.FAILED.value &&
        response.body.isEmpty) body = "";
    if (body == null) return RequestAPIResponse.internetError();
    // print(body);
    final result = RequestAPIResponse();
    if (response.statusCode != ResponseCode.OK.value) {
      result.code = response.statusCode;
      result.success = false;
      if (body != "") {
        final message = body["Message"];
        result.message = message;
      }
      return result;
    }
    result.code = response.statusCode;
    result.success = true;
    result.data = parseSuccessResponse(body);
    return result;
  }
}
