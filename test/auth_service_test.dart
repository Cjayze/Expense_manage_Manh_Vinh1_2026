import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Auth Test', () {
    test('Email format valid', () {
      String email = "test@gmail.com";

      expect(
        email.contains("@"),
        true,
      );
    });

    test('Password length', () {
      String password = "123456";

      expect(
        password.length >= 6,
        true,
      );
    });
  });
}