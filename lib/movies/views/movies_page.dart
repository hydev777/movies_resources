import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:movies_repository/movies_repository.dart';

import '../cubit/movie_cubit.dart';
import '../widgets/widgets.dart';

class MoviesPage extends StatelessWidget {
  const MoviesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return MovieCubit(
          moviesRepository: context.read<MoviesRepository>(),
        );
      },
      child: const MoviesBody(),
    );
  }
}

class MoviesBody extends StatefulWidget {
  const MoviesBody({
    super.key,
  });

  @override
  State<MoviesBody> createState() => _MoviesBodyState();
}

class _MoviesBodyState extends State<MoviesBody> {
  @override
  void initState() {
    super.initState();

    context.read<MovieCubit>().onGetAllMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<MovieCubit>().onGetAllMovies();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                BlocBuilder<MovieCubit, MovieState>(builder: (context, state) {
                  if (state.moviesStatus == MoviesStatus.initial) {
                    return const Text('No movies fetched');
                  }

                  if (state.moviesStatus == MoviesStatus.completed) {
                    final movies = state.movies;

                    return AnimationLimiter(
                      child: Column(
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 375),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            horizontalOffset: 50.0,
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                          children: [
                            ...movies!
                                .map(
                                  (movie) => MovieCard(
                                    movie: movie,
                                  ),
                                )
                                .toList()
                          ],
                        ),
                      ),
                    );
                  }

                  if (state.moviesStatus == MoviesStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state.moviesStatus == MoviesStatus.empty) {
                    return const Center(
                      child: Text("No movies available"),
                    );
                  }

                  if (state.moviesStatus == MoviesStatus.error) {
                    return const Center(
                      child: Text("An error has ocurred"),
                    );
                  }

                  return const Center(
                    child: Text("An unexpected error has ocurred"),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
