import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:sohyah_api/sohyah_api.dart';



/// Dart API Client for accessing weather data from the [Open Meteo API](https://llm-teide.fly.dev).
/// This client provides methods to fetch weather model data and manage HTTP requests seamlessly.
/// It utilizes the `http` package for network requests and `teide_api` package for serialization.
///
/// Usage Example:
/// ```dart
/// final client = OpenMeteoApiClient();
/// try {
///   final modelList = await client.getModelList('your_query_here');
///   // Use the retrieved modelList for further operations
/// } catch (e) {
///   // Handle exceptions
/// } finally {
///   client.close(); // Close the HTTP client when done
/// }
/// ```
/// This client handles HTTP responses gracefully, parsing JSON responses and throwing `ApiException`
/// if errors occur during the process.
///
class TiedeApiClient {
  /// {@macro teide_api_client}
  TiedeApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrlWeather = 'llm-teide.fly.dev';

  final http.Client _httpClient;

  // /// Fetach a [ModelData] `/v1/models`.
  // Future<List<ModelData>> getModelList() async {
  //   final modelListRequest = Uri.https(
  //     _baseUrlWeather,
  //     '/v1/models',
  //   );

  //   final headers = {
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer ${Env.teideApiKey}'
  //   };

  //   final modelListResponse = await _getResponse(modelListRequest, headers);
  //   final modelDataJson = _parseJsonResponse(modelListResponse);

  //   if (!modelDataJson.containsKey('data')) {
  //     throw ApiException(code: modelListResponse.statusCode);
  //   }

  //   return ModelListSerializer.fromJson(modelDataJson).data;
  // }

  // /// Fetach a [CompletionSerializer] `/v1/models`.
  // Future<CompletionSerializer> completions(
  //     CompletionRequestSerializer completionRequestSerializer) async {
  //   final completionRequest = Uri.https(
  //     _baseUrlWeather,
  //     '/chat/completions',
  //   );

  //   final headers = {
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer ${Env.teideApiKey}'
  //   };

  //   final completionResponse = await _postRequst(
  //     completionRequest,
  //     headers,
  //     json.encode(completionRequestSerializer.toJson()),
  //   );

  //   final completionDataJson = _parseJsonResponse(completionResponse);
  //   return CompletionSerializer.fromJson(completionDataJson);
  // }

  // Future<http.Response> _getResponse(
  //   Uri uri,
  //   Map<String, String> headers,
  // ) async {
  //   final response = await _httpClient.get(uri, headers: headers);

  //   if (response.statusCode != HttpStatus.ok) {
  //     throw ApiException(code: response.statusCode);
  //   }

  //   return response;
  // }

  Future<http.Response> _postRequst(
    Uri uri,
    Map<String, String> headers,
    String body,
  ) async {
    final response = await _httpClient.post(
      uri,
      headers: headers,
      body: body,
    );

    return response;
  }

  // Map<String, dynamic> _parseJsonResponse(http.Response response) {
  //   try {
  //     return jsonDecode(response.body) as Map<String, dynamic>;
  //   } catch (e) {
  //     throw ApiException(
  //         message: 'Failed to parse JSON response', code: response.statusCode);
  //   }
  // }

  /// Closes the underlying HTTP client.
  void close() {
    _httpClient.close();
  }
}
