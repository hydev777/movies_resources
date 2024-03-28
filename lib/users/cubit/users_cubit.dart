import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:users_repository/users_repository.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit({
    required UsersRepository usersRepository,
  })  : _usersRepository = usersRepository,
        super(const UsersState());

  final UsersRepository _usersRepository;

  set user(User user) {
    emit(
      state.copyWith(
        currentUser: user,
      ),
    );
  }

  Future<void> onGetAllUsers() async {
    emit(
      state.copyWith(
        userStatus: UserStatus.loading,
      ),
    );

    try {
      final users = await _usersRepository.allUsers();

      emit(
        state.copyWith(
          userStatus: UserStatus.completed,
          users: users,
        ),
      );
    } catch (err) {
      emit(
        state.copyWith(
          userStatus: UserStatus.error,
        ),
      );
    }
  }
}
