import 'dart:io';

import 'package:coolmovies/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:movies_repository/movies_repository.dart';
import 'package:provider/provider.dart';
import 'package:users_repository/users_repository.dart';

import 'users/cubit/users_cubit.dart';

void main() async {
  final HttpLink httpLink = HttpLink(
    Platform.isAndroid
        ? 'http://10.0.2.2:5001/graphql'
        : 'http://localhost:5001/graphql',
  );

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(
        store: InMemoryStore(),
      ),
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        Provider.value(
          value: MoviesRepository(
            graphQLClient: client.value,
          ),
        ),
        BlocProvider.value(
          value: UsersCubit(
            usersRepository: UsersRepository(
              graphQLClient: client.value,
            ),
          ),
        )
      ],
      child: const MyApp(),
    ),
  );
}
