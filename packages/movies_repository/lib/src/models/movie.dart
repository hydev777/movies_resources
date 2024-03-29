import 'package:equatable/equatable.dart';

import 'user.dart';

class Movie extends Equatable {
  const Movie({
    this.id,
    this.imgUrl,
    this.movieDirectorIdl,
    this.title,
    this.releaseDate,
    this.nodeId,
    this.userByUserCreatorId,
    this.reviews = const [],
  });

  final String? id;
  final String? imgUrl;
  final String? movieDirectorIdl;
  final String? title;
  final String? releaseDate;
  final String? nodeId;
  final User? userByUserCreatorId;
  final List<Review>? reviews;

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
      id: json["id"],
      imgUrl: json["imgUrl"],
      movieDirectorIdl: json["movieDirectorIdl"],
      title: json["title"],
      releaseDate: json["releaseDate"],
      nodeId: json["nodeId"],
      userByUserCreatorId: User.fromJson(json["userByUserCreatorId"]),
      reviews: json["reviews"] != null
          ? (json["reviews"] as List<dynamic>)
              .map(
                (review) => Review.fromJson(review),
              )
              .toList()
          : []);

  @override
  List<Object?> get props => [
        id,
        imgUrl,
        movieDirectorIdl,
        title,
        releaseDate,
        nodeId,
        userByUserCreatorId,
        reviews,
      ];
}

class Review extends Equatable {
  const Review({
    this.id,
    this.title,
    this.body,
    this.rating,
    this.movieId,
    this.userReviewerId,
  });

  final String? id;
  final String? title;
  final String? body;
  final int? rating;
  final String? movieId;
  final String? userReviewerId;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        title: json["title"],
        body: json["body"],
        rating: json["rating"],
        movieId: json["movieId"],
        userReviewerId: json["userReviewerId"],
      );

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        rating,
        movieId,
        userReviewerId,
      ];
}
