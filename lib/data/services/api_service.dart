import 'package:dio/dio.dart';
import '../models/expense_model.dart';

class ApiService {
  final Dio _dio;
  static const String baseUrl = 'https://api.example.com'; // Replace with actual API URL

  ApiService() : _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
    },
  )) {
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  Future<List<Expense>> fetchExpenses() async {
    try {
      final response = await _dio.get('/expenses');
      final List<dynamic> data = response.data;
      return data.map((json) => Expense.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Expense> createExpense(Expense expense) async {
    try {
      final response = await _dio.post('/expenses', data: expense.toJson());
      return Expense.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      await _dio.delete('/expenses/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Expense> updateExpense(Expense expense) async {
    try {
      final response = await _dio.put(
        '/expenses/${expense.id}',
        data: expense.toJson(),
      );
      return Expense.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return '连接超时，请检查网络';
      case DioExceptionType.badResponse:
        return '服务器错误: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return '请求已取消';
      default:
        return '网络连接失败';
    }
  }
}

