import 'package:fake_store_package/helpers/api_errors/api_error_handler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'dart:io';


void main() {
  group('ApiErrorHandler.handle', () {
    test('Debe retornar un mensaje de error de red cuando ocurre un SocketException', () {
      final result = ApiErrorHandler.handle<String>(const SocketException('No internet'));
      expect(result, const Left('Network error: No internet connection.'));
    });

    test('Debe retornar un mensaje de error HTTP cuando ocurre un HttpException', () {
      final result = ApiErrorHandler.handle<String>(const HttpException('Failed request'));
      expect(result, const Left('HTTP error: Failed to fetch data from the server.'));
    });

    test('Debe retornar un mensaje de error de formato cuando ocurre un FormatException', () {
      final result = ApiErrorHandler.handle<String>(const FormatException('Invalid JSON'));
      expect(result, const Left('Data format error: Invalid response format.'));
    });

    test('Debe retornar un mensaje de error inesperado para excepciones desconocidas', () {
      final result = ApiErrorHandler.handle<String>(Exception('Unknown error'));
      expect(result, const Left('Unexpected error: Exception: Unknown error'));
    });
  });

  group('ApiErrorHandler.execute', () {
    test('Debe devolver Right(T) si la función se ejecuta sin errores', () async {
      final result = await ApiErrorHandler.execute<String>(() async => 'Success');
      expect(result, const Right('Success'));
    });

    test('Debe capturar y manejar un SocketException dentro de execute', () async {
      final result = await ApiErrorHandler.execute<String>(() async {
        throw const SocketException('No internet');
      });
      expect(result, const Left('Network error: No internet connection.'));
    });

    test('Debe capturar y manejar un HttpException dentro de execute', () async {
      final result = await ApiErrorHandler.execute<String>(() async {
        throw const HttpException('Failed request');
      });
      expect(result, const Left('HTTP error: Failed to fetch data from the server.'));
    });

    test('Debe capturar y manejar un FormatException dentro de execute', () async {
      final result = await ApiErrorHandler.execute<String>(() async {
        throw const FormatException('Invalid JSON');
      });
      expect(result, const Left('Data format error: Invalid response format.'));
    });

    test('Debe capturar y manejar excepciones inesperadas dentro de execute', () async {
      final result = await ApiErrorHandler.execute<String>(() async {
        throw Exception('Unknown error');
      });
      expect(result, const Left('Unexpected error: Exception: Unknown error'));
    });
  });
}
