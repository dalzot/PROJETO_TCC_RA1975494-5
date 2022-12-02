import 'http_response.dart';

abstract class HttpClient {
  Future<HttpClient> getInstance();

  Future<HttpResponse> get(String url,
      {Map<String, String>? headers, Map<String, dynamic>? params});

  Future<HttpResponse> post(String url,
      {required Map<String, dynamic> body, Map<String, String>? headers});

  Future<HttpResponse> put(String url,
      {required Map<String, dynamic> body, Map<String, String>? headers});

  Future<HttpResponse> delete(String url,
      {required Map<String, dynamic> body, Map<String, String>? headers});

  Future<HttpResponse> patch(String url,
      {required Map<String, dynamic> body, Map<String, String>? headers});
}
