part of 'users_cubit.dart';

enum UserStatus { initial, loading, completed, empty, error }

class UsersState extends Equatable {
  const UsersState({
    this.userStatus = UserStatus.initial,
    this.users = const [],
    this.currentUser,
  });

  final UserStatus? userStatus;
  final List<User>? users;
  final User? currentUser;

  UsersState copyWith({
    UserStatus? userStatus,
    List<User>? users,
    User? currentUser,
  }) {
    return UsersState(
      userStatus: userStatus ?? this.userStatus,
      users: users ?? this.users,
      currentUser: currentUser ?? this.currentUser,
    );
  }

  @override
  List<Object?> get props => [
        userStatus,
        users,
        currentUser,
      ];
}
