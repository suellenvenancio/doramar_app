import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class IHttpClient {
  Future get({required String url, required Map<String, String> headers});
  Future patch({required String url, Object? body});
  Future post({
    required String url,
    Object? body,
    Map<String, String>? headers,
  });
}

class HttpClient implements IHttpClient {
  final client = http.Client();
  @override
  Future get({
    required String url,
    required Map<String, String> headers,
  }) async {
    final uri = Uri.parse(url);

    return await client.get(uri, headers: headers);
  }

  @override
  Future patch({required String url, Object? body}) async {
    final uri = Uri.parse(url);

    return await client.patch(
      uri,
      headers: {"Content-Type": "application/json"},
      body: (body != null) ? jsonEncode(body) : null,
    );
  }

  @override
  Future post({
    required String url,
    Object? body,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse(url);

    return await client.post(
      uri,
      headers: {"Content-Type": "application/json", ...?headers},
      body: (body != null) ? jsonEncode(body) : null,
    );
  }
}
