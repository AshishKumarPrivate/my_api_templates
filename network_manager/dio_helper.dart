 import 'package:dio/dio.dart';
import 'api_response.dart';
import 'injection_container.dart';

class DioHelper {
  final Dio dio = getDio()

    ..interceptors.add(LogInterceptor(
      request: false,
      requestBody: false,
      responseBody: false,
      responseHeader: false,
      requestHeader: false,
      error: false,
    ));

  Options _buildOptions(bool isAuthRequired, {bool isMultipart = false}) {
    return Options(
      contentType: isMultipart ? 'multipart/form-data' : 'application/json',
      sendTimeout: const Duration(seconds: 120),
      receiveTimeout: const Duration(seconds: 120),
      headers: {
        // "x-api-key": "ayush_don_123",
        if (isAuthRequired)
          "x-api-key": "ayush_don_123",
          // "Authorization": "Bearer ${StorageHelper().getUserAccessToken()}",
      },
    );
  }

  ApiResponse<T> _handleError<T>(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return ApiResponse<T>(
        success: false,
        message: "Request timed out",
        statusCode: 408,
      );
    }

    if (e.response != null) {
      return ApiResponse<T>(
        success: false,
        message: e.response?.data['message'] ?? "Something went wrong",
        statusCode: e.response?.statusCode,
        data: e.response?.data is T ? e.response?.data : null,
      );
    }

    return ApiResponse<T>(
      success: false,
      message: "Network error",
      statusCode: 503,
    );
  }

  Future<ApiResponse<T>> get<T>({
    required String url,
    bool isAuthRequired = false,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await dio.get(
        url,
        queryParameters: queryParams,
        options: _buildOptions(isAuthRequired),
      );
      return ApiResponse<T>(
        success: true,
        data: response.data as T?,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<ApiResponse<T>> post<T>({
    required String url,
    Object? requestBody,
    bool isAuthRequired = false,
  }) async {
    try {
      final isMultipart = requestBody is FormData;
      final response = await dio.post(
        url,
        data: requestBody,
        options: _buildOptions(isAuthRequired, isMultipart: isMultipart),
      );
      return ApiResponse<T>(
        success: true,
        data: response.data as T?,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<ApiResponse<T>> put<T>({
    required String url,
    Object? requestBody,
    bool isAuthRequired = false,
  }) async {
    try {
      final isMultipart = requestBody is FormData;
      final response = await dio.put(
        url,
        data: requestBody,
        options: _buildOptions(isAuthRequired, isMultipart: isMultipart),
      );
      return ApiResponse<T>(
        success: true,
        data: response.data as T?,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<ApiResponse<T>> patch<T>({
    required String url,
    Object? requestBody,
    bool isAuthRequired = false,
  }) async {
    try {
      final isMultipart = requestBody is FormData;
      final response = await dio.patch(
        url,
        data: requestBody,
        options: _buildOptions(isAuthRequired, isMultipart: isMultipart),
      );
      return ApiResponse<T>(
        success: true,
        data: response.data as T?,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<ApiResponse<T>> delete<T>({
    required String url,
    Object? requestBody,
    bool isAuthRequired = false,
  }) async {
    try {
      final isMultipart = requestBody is FormData;
      final response = await dio.delete(
        url,
        data: requestBody,
        options: _buildOptions(isAuthRequired, isMultipart: isMultipart),
      );
      return ApiResponse<T>(
        success: true,
        data: response.data as T?,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<ApiResponse<T>> uploadFile<T>({
    required String url,
    required FormData requestBody,
    bool isAuthRequired = false,
  }) async {
    try {
      final response = await dio.post(
        url,
        data: requestBody,
        options: _buildOptions(isAuthRequired, isMultipart: true),
      );
      return ApiResponse<T>(
        success: true,
        data: response.data as T?,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }
}
