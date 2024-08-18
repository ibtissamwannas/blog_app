import 'package:blog_app/core/constants/constant.dart';
import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final ConnectionChecker connectionChecker;
  AuthRepositoryImpl(
    this.authRemoteDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, User>> loginUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () => authRemoteDataSource.login(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(
      () => authRemoteDataSource.signUp(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
    if (!await (connectionChecker.isConnected)) {
      return left(Failure(Constants.noConnectionErrorMessage));
    }
    try {
      final user = await fn();
      return Right(user);
    } on SeverException catch (e) {
      return Left(
        Failure(e.message),
      );
    }
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    if (!await (connectionChecker.isConnected)) {
      final session = authRemoteDataSource.currentUserSession;

      if (session == null) {
        return left(Failure('User not logged in!'));
      }

      return right(
        UserModel(
          id: session.user.id,
          email: session.user.email ?? '',
          name: '',
        ),
      );
    }
    final user = await authRemoteDataSource.getCurrentUserData();
    if (user == null) {
      return left(Failure('User not logged in!'));
    }

    return right(user);
  }
}
