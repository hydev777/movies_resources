part of 'movie_cubit.dart';

enum MoviesStatus { initial, loading, completed, empty, error }

enum MovieDetailStatus { initial, loading, completed, empty, error }

class MovieState extends Equatable {
  const MovieState({
    this.moviesStatus = MoviesStatus.initial,
    this.movieDetailStatus = MovieDetailStatus.initial,
    this.movies = const [],
    this.movieDetails,
  });

  final MoviesStatus? moviesStatus;
  final MovieDetailStatus? movieDetailStatus;
  final List<Movie>? movies;
  final Movie? movieDetails;

  MovieState copyWith({
    MoviesStatus? moviesStatus,
    MovieDetailStatus? movieDetailStatus,
    List<Movie>? movies,
    Movie? movieDetails,
  }) {
    return MovieState(
      moviesStatus: moviesStatus ?? this.moviesStatus,
      movieDetailStatus: movieDetailStatus ?? this.movieDetailStatus,
      movies: movies ?? this.movies,
      movieDetails: movieDetails ?? this.movieDetails,
    );
  }

  @override
  List<Object?> get props => [
        moviesStatus,
        movieDetailStatus,
        movies,
        movieDetails,
      ];
}
