import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movies_repository/movies_repository.dart';

part 'movie_state.dart';

class MovieCubit extends Cubit<MovieState> {
  MovieCubit({
    required MoviesRepositories moviesRepositories,
  })  : _moviesRepositories = moviesRepositories,
        super(const MovieState());

  final MoviesRepositories _moviesRepositories;

  Future<void> onGetAllMovies() async {
    emit(
      state.copyWith(moviesStatus: MoviesStatus.loading),
    );

    try {
      final movies = await _moviesRepositories.allMovies();

      emit(
        state.copyWith(
          moviesStatus: MoviesStatus.completed,
          movies: movies,
        ),
      );
    } catch (err) {
      emit(
        state.copyWith(moviesStatus: MoviesStatus.error),
      );
    }
  }
}
