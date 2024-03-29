import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:movies_repository/movies_repository.dart';
import 'package:users_repository/users_repository.dart';

import 'users/cubit/users_cubit.dart';

class ProviderWrapper extends StatefulWidget {
  const ProviderWrapper({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  State<ProviderWrapper> createState() => _ProviderWrapperState();
}

class _ProviderWrapperState extends State<ProviderWrapper> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(
          value: MoviesRepository(
            graphQLClient: GraphQLProvider.of(context).value,
          ),
        ),
        BlocProvider.value(
          value: UsersCubit(
            usersRepository: UsersRepository(
              graphQLClient: GraphQLProvider.of(context).value,
            ),
          ),
        )
      ],
      child: widget.child,
    );
  }
}
