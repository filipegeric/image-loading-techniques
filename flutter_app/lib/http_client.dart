import 'package:dio/dio.dart';

Dio _httpClient;

Dio getHttpClient() {
  if (_httpClient == null) {
    _httpClient = Dio();
    _httpClient.options.baseUrl = 'http://192.168.1.78:3000/';
  }

  return _httpClient;
}
