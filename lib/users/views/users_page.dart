import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../cubit/users_cubit.dart';
import '../widgets/widgets.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const UsersBody();
  }
}

class UsersBody extends StatefulWidget {
  const UsersBody({
    super.key,
  });

  @override
  State<UsersBody> createState() => _UsersBodyState();
}

class _UsersBodyState extends State<UsersBody> {
  @override
  void initState() {
    super.initState();

    context.read<UsersCubit>().onGetAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<UsersCubit>().onGetAllUsers();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                BlocBuilder<UsersCubit, UsersState>(builder: (context, state) {
                  if (state.userStatus == UserStatus.initial) {
                    return const Text('No movies fetched');
                  }

                  if (state.userStatus == UserStatus.completed) {
                    final users = state.users;

                    return AnimationLimiter(
                      child: Column(
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 375),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            horizontalOffset: 50.0,
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                          children: [
                            ...users!
                                .map(
                                  (user) => UserCard(
                                    user: user,
                                  ),
                                )
                                .toList()
                          ],
                        ),
                      ),
                    );
                  }

                  if (state.userStatus == UserStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state.userStatus == UserStatus.empty) {
                    return const Center(
                      child: Text("No movies available"),
                    );
                  }

                  if (state.userStatus == UserStatus.error) {
                    return const Center(
                      child: Text("An error has ocurred"),
                    );
                  }

                  return const Center(
                    child: Text("An unexpected error has ocurred"),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
