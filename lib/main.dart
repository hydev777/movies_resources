import 'dart:io';

import 'package:coolmovies/app/app.dart';
import 'package:coolmovies/provider_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

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
    GraphQLProvider(
      client: client,
      child: const ProviderWrapper(
        child: MyApp(),
      ),
    ),
  );
}
