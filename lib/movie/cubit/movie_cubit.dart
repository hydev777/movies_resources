import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movies_repository/movies_repository.dart';

part 'movie_state.dart';

class MovieCubit extends Cubit<MovieState> {
  MovieCubit({
    required MoviesRepository moviesRepository,
  })  : _moviesRepository = moviesRepository,
        super(const MovieState());

  final MoviesRepository _moviesRepository;

  Future<void> onGetAllMovies() async {
    emit(
      state.copyWith(
        moviesStatus: MoviesStatus.loading,
      ),
    );

    try {
      final movies = await _moviesRepository.allMovies();

      emit(
        state.copyWith(
          moviesStatus: MoviesStatus.completed,
          movies: movies,
        ),
      );
    } catch (err) {
      emit(
        state.copyWith(
          moviesStatus: MoviesStatus.error,
        ),
      );
    }
  }

  Future<void> onGetMovieById(String id) async {
    emit(
      state.copyWith(
        movieDetailStatus: MovieDetailStatus.loading,
      ),
    );

    try {
      final movie = await _moviesRepository.getMovieById(id);

      emit(
        state.copyWith(
          movieDetailStatus: MovieDetailStatus.completed,
          movieDetails: movie,
        ),
      );

      print(
          "========================>>> onGetMovieById MovieDetailStatus.completed");
    } catch (err) {
      emit(
        state.copyWith(
          movieDetailStatus: MovieDetailStatus.error,
        ),
      );
    }
  }

  Future<void> onCreateReview(
    String title,
    String body,
    String movieId,
    int rating,
    String userReviewerId,
  ) async {
    emit(
      state.copyWith(
        createReviewStatus: CreateReviewStatus.loading,
      ),
    );

    try {
      await _moviesRepository.createReview(
        title,
        body,
        movieId,
        rating,
        userReviewerId,
      );

      emit(
        state.copyWith(
          createReviewStatus: CreateReviewStatus.completed,
        ),
      );
    } catch (err) {
      emit(
        state.copyWith(
          createReviewStatus: CreateReviewStatus.error,
        ),
      );
    }

    emit(
      state.copyWith(
        createReviewStatus: CreateReviewStatus.initial,
      ),
    );
  }
}
