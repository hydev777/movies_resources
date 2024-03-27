part of 'movie_cubit.dart';

enum MoviesStatus { initial, loading, completed, empty, error }

class MovieState extends Equatable {
  const MovieState({
    this.moviesStatus = MoviesStatus.initial,
    this.movies = const [],
  });

  final MoviesStatus? moviesStatus;
  final List<Movie>? movies;

  MovieState copyWith({
    MoviesStatus? moviesStatus,
    List<Movie>? movies,
  }) {
    return MovieState(
      moviesStatus: moviesStatus ?? this.moviesStatus,
      movies: movies ?? this.movies,
    );
  }

  @override
  List<Object?> get props => [
        moviesStatus,
        movies,
      ];
}
