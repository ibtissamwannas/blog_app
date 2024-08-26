import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase/supabase.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockAuth extends Mock implements GoTrueClient {}

class MockAuthResponse extends Mock implements AuthResponse {}

class MockUser extends Mock implements User {}

void main() {
  late MockSupabaseClient mockSupabaseClient;
  late MockAuth mockAuth;
  late AuthRemoteDataSourceImpl authRemoteDataSourceImpl;
  late MockAuthResponse mockAuthResponse;
  late MockUser mockUser;

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockAuth = MockAuth();
    mockAuthResponse = MockAuthResponse();
    mockUser = MockUser();
    authRemoteDataSourceImpl = AuthRemoteDataSourceImpl(mockSupabaseClient);

    when(() => mockSupabaseClient.auth).thenReturn(mockAuth);
  });

  test('should return UserModel when login is successful', () async {
    // Arrange
    when(() => mockUser.toJson()).thenReturn({
      "id": "1",
      "name": "sam",
      "email": "ibtissamwanans21@gmail.com",
    });
    when(() => mockAuthResponse.user).thenReturn(mockUser);
    when(() => mockAuth.signInWithPassword(
            email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async => mockAuthResponse);

    // Act
    final result = await authRemoteDataSourceImpl.login(
      email: "ibtissamwanans21@gmail.com",
      password: "password",
    );

    // Assert
    expect(result, isA<UserModel>());
    expect(result.id, "1");
    expect(result.name, "sam");
    expect(result.email, "ibtissamwanans21@gmail.com");
  });

  test('when user is null should throw SeverException', () async {
    // Arrange
    when(() => mockAuth.signInWithPassword(
            email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async => mockAuthResponse);

    when(() => mockAuthResponse.user).thenReturn(null);

    // Act & Assert
    expect(
      () async => await authRemoteDataSourceImpl.login(
        email: "ibtissamwanans21@gmail.com",
        password: "password",
      ),
      throwsA(
        isA<SeverException>(),
      ),
    );
  });

  test('when login is return AuthException should throw SeverException',
      () async {
    // Arrange
    when(() => mockAuth.signInWithPassword(
        email: any(named: 'email'),
        password: any(named: 'password'))).thenThrow(
      const AuthException(
        'Auth error message',
      ),
    );

    // Act & Assert
    expect(
      () async => await authRemoteDataSourceImpl.login(
        email: "ibtissamwanans21@gmail.com",
        password: "password",
      ),
      throwsA(
        isA<SeverException>().having(
          (state) => state.message.toString(),
          'message',
          "Auth error message",
        ),
      ),
    );
  });
}
