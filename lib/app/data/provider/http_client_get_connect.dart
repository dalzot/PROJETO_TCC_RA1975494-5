import 'package:get/get_connect/connect.dart';

import 'http_client.dart';
import 'http_response.dart';

class HttpClientGetConnect implements HttpClient {
  final _client = GetConnect();
  final List<String> _messages = [];

  @override
  Future<HttpClientGetConnect> getInstance() async {
    return this;
  }

  @override
  Future<HttpResponse> delete(String url,
      {required Map<String, dynamic> body,
      Map<String, String>? headers}) async {
    final response = await _client.delete(url, headers: headers, query: body);
    _log(
        method: 'DELETE',
        url: url,
        headers: headers,
        body: body,
        response: response,
        statusCode: response.statusCode.toString());
    return HttpResponse(data: response.body, statusCode: response.statusCode);
  }

  @override
  Future<HttpResponse> get(String url,
      {Map<String, String>? headers, Map<String, dynamic>? params}) async {
    final response = await _client.get(url, headers: headers, query: params);
    _log(
        method: 'GET',
        url: url,
        headers: headers,
        body: {},
        response: response,
        params: params,
        statusCode: response.statusCode.toString());
    return HttpResponse(
      data: response.body,
      statusCode: response.statusCode,
    );
  }

  @override
  Future<HttpResponse> patch(String url,
      {required Map<String, dynamic> body,
      Map<String, String>? headers}) async {
    final response = await _client.patch(url, body, headers: headers);
    _log(
        method: 'PATCH',
        url: url,
        headers: headers,
        body: body,
        response: response,
        statusCode: response.statusCode.toString());
    return HttpResponse(data: response.body, statusCode: response.statusCode);
  }

  @override
  Future<HttpResponse> post(String url,
      {required Map<String, dynamic> body,
      Map<String, String>? headers}) async {
    final response = await _client.post(url, body, headers: headers);
    _log(
        method: 'POST',
        url: url,
        headers: headers,
        body: body,
        response: response,
        statusCode: response.statusCode.toString());
    return HttpResponse(data: response.body, statusCode: response.statusCode);
  }

  @override
  Future<HttpResponse> put(String url,
      {required Map<String, dynamic> body,
      Map<String, String>? headers}) async {
    final response = await _client.put(url, body, headers: headers);
    _log(
        method: 'PUT',
        url: url,
        headers: headers,
        body: body,
        response: response,
        statusCode: response.statusCode.toString());
    return HttpResponse(data: response.body, statusCode: response.statusCode);
  }

  void _log({
    required String method,
    required String url,
    required Map<String, String>? headers,
    required Map<String, dynamic>? body,
    required Response<dynamic> response,
    required String statusCode,
    Map<String, dynamic>? params,
  }) {
    method = ' $method ';
    int qnt = (40 - method.length) ~/ 2;
    String begin = method.padRight(qnt).padLeft(qnt);
    String end = ''.padLeft((qnt + method.length) * 2);
    append(begin.trim());
    append('URL: $url');
    append('StatusCode: $statusCode');
    append('BODY: $body');
    append('HEADERS: $headers');
    append('RESPONSE: ${response.body}');
    append('PARAMETER: $params');
    append(end);
    closeAppend();
  }

  void append(message) {
    _messages.add(message);
  }

  void closeAppend() {
    print(_messages.join('\n'));
    _messages.clear();
  }
}
