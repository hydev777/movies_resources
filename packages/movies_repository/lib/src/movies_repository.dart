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
          fetchPolicy: FetchPolicy.noCache,
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
          fetchPolicy: FetchPolicy.noCache,
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
          fetchPolicy: FetchPolicy.noCache,
          document: gql('''
                    query {
                        allMovieReviews(filter: {
                            movieId: {
                                equalTo: "$id"
                            }
                            }
                            ) {
                                nodes {
                                    id
                                    title
                                    body
                                    rating
                                    movieId
                                    userReviewerId
                                }
                        }
                    }
        '''),
          variables: {'id': id},
        ),
      );

      final reviewsJson =
          (reviews.data!['allMovieReviews']['nodes'] as List<dynamic>).toList();

      (movieDetails.data!['movieById'] as Map<String, dynamic>)
          .addEntries({"reviews": reviewsJson}.entries);

      return Movie.fromJson(movieDetails.data!['movieById']);
    } catch (err, stack) {
      print(err);
      print(stack);
      throw HttpException();
    }
  }

  Future<void> createReview(
    String title,
    String body,
    String movieId,
    int rating,
    String userReviewerId,
  ) async {
    try {
      await _graphQLClient.mutate(
        MutationOptions(
          document: gql('''
                mutation {
                    createMovieReview(input: {
                        movieReview: {
                            title: "$title", body: "$body", movieId: "$movieId", rating: $rating, userReviewerId: "$userReviewerId"
                        }
                    }) {
                        movieReview{
                            id 
                            title
                            body
                            rating
                            movieByMovieId {
                                title
                            }
                            userByUserReviewerId {
                                name
                            }
                        }
                    }
                }
        '''),
          variables: {
            'title': title,
            'body': body,
            'movieId': movieId,
            'rating': rating,
            'userReviewerId': userReviewerId,
          },
        ),
      );
    } catch (err) {
      print(err);
      throw HttpException();
    }
  }

  Future<void> deleteMovieReviewById(
    String id,
  ) async {
    try {
      final deletedReview = await _graphQLClient.mutate(
        MutationOptions(
          document: gql('''
                  mutation {
                      deleteMovieReviewById(input: {
                          id: "$id"
                      }) {
                          movieReview{
                              id 
                              title
                              body
                              rating
                              movieByMovieId {
                                  title
                              }
                              userByUserReviewerId {
                                  name
                              }
                          }
                      }
                  }
        '''),
          variables: {
            'id': id,
          },
        ),
      );

      print(deletedReview);
    } catch (err) {
      print(err);
      throw HttpException();
    }
  }
}
