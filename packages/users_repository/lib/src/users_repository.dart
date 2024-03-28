import 'package:graphql_flutter/graphql_flutter.dart';

import 'models/model.dart';

class HttpException implements Exception {}

class UsersRepository {
  final GraphQLClient graphQLClient;

  UsersRepository({
    required this.graphQLClient,
  }) : _graphQLClient = graphQLClient;

  final GraphQLClient _graphQLClient;

  Future<List<User>> allUsers() async {
    QueryResult usersList;

    try {
      usersList = await _graphQLClient.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.cacheFirst,
          document: gql('''
        {
            allUsers {
              nodes {
                id,
                name,
              }
            }
        }
        '''),
        ),
      );

      return (usersList.data!['allUsers']['nodes'] as List<dynamic>)
          .map(
            (user) => User.fromJson(user),
          )
          .toList();
    } catch (err, stack) {
      print(err);
      print(stack);
      throw HttpException();
    }
  }

  Future<User> getUserById(String id) async {
    QueryResult userDetails;

    try {
      userDetails = await _graphQLClient.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql('''
        {
            userById(id: "$id") {
                id,
                name,
            }
        }
        '''),
          variables: {'id': id},
        ),
      );

      return User.fromJson(userDetails.data!['userById']);
    } catch (err) {
      print(err);
      throw HttpException();
    }
  }
}
