import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:users_repository/users_repository.dart';

import '../cubit/users_cubit.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(user.name!),
        onTap: () {
          context.read<UsersCubit>().currentUser = User(
            id: user.id,
            name: user.name,
          );
          context.push('/movies');
        },
      ),
    );
  }
}
