import 'package:blog_app/core/error/exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should return the exception method', () {
    const message = 'Server error occurred';
    final exception = SeverException(message);

    final result = exception.toString();

    expect(result, message);
  });
}
