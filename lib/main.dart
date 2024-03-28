import 'dart:io';

import 'package:coolmovies/app/app.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:movies_repository/movies_repository.dart';
import 'package:provider/provider.dart';

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
            ),
          ),
        )
      ],
      child: const MyApp(),
    ),
  );
}
