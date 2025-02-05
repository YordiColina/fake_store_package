import 'package:dartz/dartz.dart';
import 'dart:io';

class ApiErrorHandler {
  static Either<String, T> handle<T>(dynamic error) {
    if (error is SocketException) {
      return const Left('Network error: No internet connection.');
    } else if (error is HttpException) {
      return const Left('HTTP error: Failed to fetch data from the server.');
    } else if (error is FormatException) {
      return const Left('Data format error: Invalid response format.');
    } else {
      return Left('Unexpected error: ${error.toString()}');
    }
  }

  static Future<Either<String, T>> execute<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Right(result);
    } catch (error) {
      return handle<T>(error);
    }
  }
}
