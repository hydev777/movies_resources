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

  runApp(
    MultiProvider(
      providers: [
        Provider.value(
          value: MoviesRepository(
            graphQLClient: GraphQLClient(
              link: httpLink,
              cache: GraphQLCache(store: InMemoryStore()),
              alwaysRebroadcast: true,
            ),
          ),
        ),
        BlocProvider(
          create: (context) {
            return UsersCubit(
              usersRepository: UsersRepository(
                graphQLClient: GraphQLClient(
                  link: httpLink,
                  cache: GraphQLCache(store: InMemoryStore()),
                ),
              ),
            );
          },
        )
      ],
      child: const MyApp(),
    ),
  );
}
