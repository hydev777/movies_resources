import 'package:graphql_flutter/graphql_flutter.dart';

import 'models/models.dart';

class HttpException implements Exception {}

class MoviesRepository {
  final GraphQLClient graphQLClient;

  MoviesRepository({
    required this.graphQLClient,
  }) : _graphQLClient = graphQLClient;

  final GraphQLClient _graphQLClient;

  Future<List<Movie>> allMovies() async {
    QueryResult result;

    try {
      result = await _graphQLClient.query(
        QueryOptions(
          document: gql("""
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

  Future<Movie> getMovieById(String id) async {
    QueryResult movieDetails;
    QueryResult reviews;

    try {
      movieDetails = await _graphQLClient.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.cacheFirst,
          document: gql('''
          {
              movieById(id: "$id") {
                        id,
                        imgUrl,
                        title,
                        movieDirectorId,
                        userCreatorId,
                        title,
                        releaseDate,
                        nodeId,
                        userByUserCreatorId {
                            id
                            name
                            nodeId
                          }
                      }
                    }
        '''),
          variables: {'id': id},
        ),
      );

      reviews = await _graphQLClient.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.cacheFirst,
          document: gql('''
          {
            allMovieReviews {
              nodes {
                id,
                title,
                body,
                rating,
                movieId
              }
            }
        }
        '''),
        ),
      );

      final reviewJson =
          (reviews.data!['allMovieReviews']['nodes'] as List<dynamic>)
              .where((review) => review['movieId'] == id)
              .toList();
      (movieDetails.data!['movieById'] as Map<String, dynamic>)
          .addEntries({"reviews": reviewJson}.entries);

      (movieDetails.data as Map<String, dynamic>).entries.forEach((value) {
        print(value);
      });

      return Movie.fromJson(movieDetails.data!['movieById']);
    } catch (err, stack) {
      print(err);
      print(stack);
      throw HttpException();
    }
  }
}
