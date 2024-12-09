import 'dart:developer';

import 'package:communicado/cade_overlays.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Cado {
  /// Tag for the class to identify the class in the logs.
  static const String _tag = 'Cado';

  // Private constructor
  Cado._privateConstructor();

  // Static instance of the class
  static final Cado _instance = Cado._privateConstructor();

  // Factory constructor to return the same instance
  factory Cado() {
    return _instance;
  }

  /// Get instance of Cado to access core methods for data handling and API requests.
  static Cado get instance => _instance;

  /// Set the context of the application to show dialogs and snackbars. If not set then there won't be any dialogs or snackbars shown.
  BuildContext? context;

  void setContext(BuildContext context) {
    this.context = context;
  }

  /// Set the base URL for the API requests. This is the URL that will be used for all the requests.
  String _baseUrl = "";

  /// Set the base URL for the API requests. Make sure dont' add / at the end of the URL.
  void setBaseUrl(String url) {
    _baseUrl = url;
  }

  /// To controller access to the API, set the accessControlAllowOrigin to the domain of the API.
  /// Default is set to "*". This allows access to all domains.
  String accessControlAllowOrigin = "*";

  ///Bearer token to access HTTP requests with authorization.
  String? _bearerToken;

  /// Set the bearer token for the API requests.
  void setBearerToken(String token) {
    _bearerToken = token;
  }

  /// Get the bearer token for the API requests.
  String? getBearerToken() {
    return _bearerToken;
  }

  final Dio _request = Dio();

  /// Send a GET request to the server. An [endPoint] is required to hit the api route .Set [data] to the data to be sent. Returns a Future<Response?>.
  Future<Response?> get({required String endPoint, data}) async {
    if (_baseUrl.isEmpty) {
      log('Base URL not set. Use setBaseUrl() to set the base URL.',
          name: _tag);
      return null;
    }
    //bool internet = await isInternetAvailable();
    bool internet=true;
    Response? req;
    if (internet) {
      _setRequestOptions();
      OverlayEntry entry = CadeOverlays.instance.showLoading(context: context!);

      try {
        req = await _request.get('$_baseUrl/$endPoint', queryParameters: data);
      } on DioError catch (e) {
        //when any other response comes than 200
        log('End Point: $endPoint', name: _tag);
        //log('Data Sent: $data', name: _tag);
        log('Error: ${e.error}', name: _tag);
        req = e.response;
      } finally {
        entry.remove();
      }
    }
    return req;
  }

  /// Send a POST request to the server. An [endPoint] is required to hit the api route .Set [data] to the data to be sent. Returns a Future<Response?>.
  /// Note: Make sure [endPoint] has no / at beginning.
  Future<Response?> post(
      {required String endPoint,
      data,
      Function(int, int)? onSendProgress,
      Function(int, int)? onReceiveProgress}) async {
    if (_baseUrl.isEmpty) {
      log('Base URL not set. Use setBaseUrl() to set the base URL.',
          name: _tag);
      return null;
    }
    bool internet = await isInternetAvailable();

    if (internet) {
      Response? req;
      _setRequestOptions();
      try {
        req = await _request.post("$_baseUrl/$endPoint",
            data: data,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress);
        return req;
      } on DioError catch (e) {
        //when any other response comes than 200
        log('End Point: $endPoint', name: _tag);
        //log('Data Sent: $data', name: _tag);
        log('Error: ${e.error}', name: _tag);

        return e.response;
      }
    }
    return null;
  }

  /// Send a DELETE request header on an [endPoint] to delete data from the server.
  Future<Response?> delete({required String endPoint}) async {
    if (_baseUrl.isEmpty) {
      log('Base URL not set. Use setBaseUrl() to set the base URL.',
          name: _tag);
      return null;
    }

    bool internet = await isInternetAvailable();

    if (internet) {
      _setRequestOptions();
      try {
        var req = await _request.delete("$_baseUrl/$endPoint");
        return req;
      } on DioError catch (e) {
        //Fluttertoast.showToast(msg: e.response.toString());
        log('End Point: $endPoint', name: _tag);
        return e.response;
      }
    }
    return null;
  }

  /// Send a PUT request to the server. An [endPoint] is required to hit the api route .
  Future<Response?> put(
      {required String endPoint,
      data,
      Function(int, int)? onSendProgress,
      Function(int, int)? onReceiveProgress}) async {
    if (_baseUrl.isEmpty) {
      log('Base URL not set. Use setBaseUrl() to set the base URL.',
          name: _tag);
      return null;
    }
    bool internet = await isInternetAvailable();

    if (internet) {
      Response? req;
      _setRequestOptions();
      try {
        req = await _request.put("$_baseUrl/$endPoint",
            data: data,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress);
        return req;
      } on DioError catch (e) {
        //when any other response comes than 200
        log('End Point: $endPoint', name: _tag);
        log('Data Sent: $data', name: _tag);
        log('Error: ${e.error}', name: _tag);

        return e.response;
      }
    }
    return null;
  }

  /// Send a multipart request to the server. Set [multipart] to true.
  bool multipart = false;

  _setRequestOptions({bool multipart = false}) {
    if (_bearerToken != null) {
      _request.options = BaseOptions(
        receiveDataWhenStatusError: true,
        contentType: Headers.formUrlEncodedContentType,
        headers: multipart
            ? {
                "Content-Type": "multipart/form-data",
                'Authorization': "Bearer $_bearerToken",
                'Access-Control-Allow-Origin': accessControlAllowOrigin
              }
            : {
                'Authorization': "Bearer $_bearerToken",
                'Access-Control-Allow-Origin': accessControlAllowOrigin
              },
      );
    }
  }

  ///Check if the internet is available or not. Returns true if available, false otherwise.
  Future<bool> isInternetAvailable() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        log('Mobile network available', name: _tag);
        // I am connected to a mobile network.
        return Future.value(true);
      } else if (connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a wifi network.
        log('WIFI network available', name: _tag);
        return Future.value(true);
      } else {
        // I am not connected to any network.
        log('No internet access', name: _tag);
        return Future.value(true);
      }
    } catch (e) {
      log(e.toString(), name: _tag);
    }
    return true;
  }
}
