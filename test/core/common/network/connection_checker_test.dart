import 'package:blog_app/core/network/connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';

class MockInternetConnection extends Mock implements InternetConnection {}

void main() {
  late MockInternetConnection mockInternetConnection;
  late ConnectionCheckerImpl connectionCheckerImpl;

  setUp(() {
    mockInternetConnection = MockInternetConnection();
    connectionCheckerImpl = ConnectionCheckerImpl(mockInternetConnection);
  });
  test('check if internet is connected', () async {
    // arrange
    when(() => mockInternetConnection.hasInternetAccess)
        .thenAnswer((_) async => true);
    // act
    final result = await connectionCheckerImpl.isConnected;

    // Assert
    expect(result, isTrue);
  });
  test('check if internet is not connected', () async {
    // arrange
    when(() => mockInternetConnection.hasInternetAccess)
        .thenAnswer((_) async => false);
    // act
    final result = await connectionCheckerImpl.isConnected;

    // Assert
    expect(result, isFalse);
  });
}
