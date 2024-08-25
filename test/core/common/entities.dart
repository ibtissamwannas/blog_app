import 'package:blog_app/core/common/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('test user Model', () {
    test('check if two models with same values are equal', () {
      const user1 = User(id: '1', name: 'test', email: 'test');
      const user2 = User(id: '1', name: 'test', email: 'test');
      expect(user1, equals(user2));
    });
    test('should have correct props', () {
      const user = User(id: '1', name: 'John Doe', email: 'john@example.com');
      expect(user.props, equals(['1', 'John Doe', 'john@example.com']));
    });
  });
}
