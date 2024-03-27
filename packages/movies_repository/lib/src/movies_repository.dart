import 'package:graphql_flutter/graphql_flutter.dart';

import 'models/models.dart';

class HttpException implements Exception {}

class MoviesRepositories {
  final GraphQLClient graphQLClient;

  MoviesRepositories({
    required this.graphQLClient,
  }) : _graphQLClient = graphQLClient;

  final GraphQLClient _graphQLClient;

  Future<List<Movie>> allMovies() async {
    QueryResult result;

    try {
      result = await _graphQLClient.query(
        QueryOptions(
          document: gql(r"""
          query AllMovies {
            allMovies {
              nodes {
                id
                imgUrl
                movieDirectorId
                userCreatorId
                title
                releaseDate
                nodeId
                userByUserCreatorId {
                  id
                  name
                  nodeId
                }
              }
            }
          }
        """),
        ),
      );

      print(result.data!['allMovies']['nodes']);

      return (result.data!['allMovies']['nodes'] as List<dynamic>)
          .map(
            (movie) => Movie.fromJson(movie),
          )
          .toList();
    } catch (err) {
      print(err);
      throw HttpException();
    }
  }
}
