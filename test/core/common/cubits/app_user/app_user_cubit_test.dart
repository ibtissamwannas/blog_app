import 'package:bloc_test/bloc_test.dart';
import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUser extends Mock implements User {}

void main() {
  group('AppUserCubit', () {
    late AppUserCubit appUserCubit;

    setUp(() {
      appUserCubit = AppUserCubit();
    });
    tearDown(() {
      appUserCubit.close();
    });
    test('initial state is AppUserInitial', () {
      expect(appUserCubit.state, isA<AppUserInitial>());
    });

    blocTest('emit [AppUserInitial] when user is null',
        build: () => appUserCubit,
        act: (cubit) => cubit.updateUser(null),
        expect: () => [AppUserInitial()]);

    blocTest('emit AppUserLoggedIn when user is not null',
        build: () => appUserCubit,
        act: (cubit) {
          final user = MockUser();
          cubit.updateUser(user);
        },
        expect: () => [
              isA<AppUserLoggedIn>()
                  .having((state) => state.user, 'user', isA<User>())
            ]);

    blocTest('check if user object is correct',
        build: () => appUserCubit,
        act: (cubit) {
          const user = User(
            id: '5',
            name: 'ibtissam',
            email: 'ibtisamwannas21@gmai.com',
          );
          cubit.updateUser(user);
        },
        expect: () => [
              isA<AppUserLoggedIn>()
                  .having((state) => state.user, 'user Model', isA<User>())
            ]);

    blocTest('check if user object is empty when it is in the model is null',
        build: () => appUserCubit,
        act: (cubit) {
          const user = User(
            id: '',
            name: 'ibtissam',
            email: 'ibtisamwannas21@gmai.com',
          );
          cubit.updateUser(user);
        },
        expect: () => [
              isA<AppUserLoggedIn>()
                  .having((state) => state.user.id, 'user Model', equals(''))
            ]);
  });
}
