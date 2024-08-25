part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState extends Equatable {}

final class AppUserInitial extends AppUserState {
  @override
  List<Object?> get props => [];
}

final class AppUserLoggedIn extends AppUserState {
  final User user;
  AppUserLoggedIn({required this.user});

  @override
  List<Object?> get props => [user];
}

// core cannot be depend on ther features
// other feature can be depent on core