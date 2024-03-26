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
  });

  final String? id;
  final String? imgUrl;
  final String? movieDirectorIdl;
  final String? title;
  final String? releaseDate;
  final String? nodeId;
  final User? userByUserCreatorId;

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        id: json["id"],
        imgUrl: json["imgUrl"],
        movieDirectorIdl: json["movieDirectorIdl"],
        title: json["title"],
        releaseDate: json["releaseDate"],
        nodeId: json["nodeId"],
        userByUserCreatorId: json["userByUserCreatorId"],
      );

  @override
  List<Object?> get props => [
        id,
        imgUrl,
        movieDirectorIdl,
        title,
        releaseDate,
        nodeId,
        userByUserCreatorId,
      ];
}
