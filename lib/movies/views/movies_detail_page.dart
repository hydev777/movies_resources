import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_repository/movies_repository.dart';

import '../../users/cubit/users_cubit.dart';
import '../cubit/movie_cubit.dart';
import '../../utils/utils.dart';
import '../widgets/widgets.dart';

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({Key? key, this.id}) : super(key: key);

  final String? id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return MovieCubit(
          moviesRepository: context.read<MoviesRepository>(),
        );
      },
      child: MovieDetailBody(id: id),
    );
  }
}

class MovieDetailBody extends StatefulWidget {
  const MovieDetailBody({super.key, this.id});

  final String? id;

  @override
  State<MovieDetailBody> createState() => _MovieDetailBodyState();
}

class _MovieDetailBodyState extends State<MovieDetailBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<MovieCubit>().onGetMovieById(widget.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UsersCubit>().state.currentUser;

    return SafeArea(
      child: Scaffold(
        body: BlocListener<MovieCubit, MovieState>(
          listener: (context, state) {
            if (state.createReviewStatus == CreateReviewStatus.error) {
              context.read<MovieCubit>().onGetMovieById(widget.id!);

              errorDialog('An error ocurred creating your review!', context);
            }

            if (state.createReviewStatus == CreateReviewStatus.completed) {
              context.read<MovieCubit>().onGetMovieById(widget.id!);

              successDialog('Your Review has been added!', context);
            }

            if (state.deleteReviewStatus == DeleteReviewStatus.error) {
              context.read<MovieCubit>().onGetMovieById(widget.id!);

              errorDialog('An error ocurred deleting your review!', context);
            }

            if (state.deleteReviewStatus == DeleteReviewStatus.completed) {
              context.read<MovieCubit>().onGetMovieById(widget.id!);

              successDialog('Review has been deleted!', context);
            }
          },
          child: BlocBuilder<MovieCubit, MovieState>(
            builder: (context, state) {
              if (state.movieDetailStatus == MovieDetailStatus.initial ||
                  state.movieDetailStatus == MovieDetailStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state.movieDetailStatus == MovieDetailStatus.completed) {
                final movieDetails = state.movieDetails;

                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      stretch: true,
                      onStretchTrigger: () async {},
                      stretchTriggerOffset: 300.0,
                      expandedHeight: 250.0,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Image.network(
                          movieDetails!.imgUrl!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Hero(
                          tag: 'hero-movie-title-${widget.id}',
                          child: Text(
                            movieDetails.title!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FilledButton.icon(
                              onPressed: () {
                                final movieCubit = context.read<MovieCubit>();

                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return BlocProvider.value(
                                      value: movieCubit,
                                      child: AddReviewPopUp(
                                        movieId: widget.id,
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Add review'),
                            )
                          ],
                        ),
                      ),
                    ),
                    ...movieDetails.reviews!
                        .map(
                          (review) => SliverToBoxAdapter(
                            child: ReviewCard(
                              currentUser: currentUser!,
                              review: review,
                            ),
                          ),
                        )
                        .toList()
                  ],
                );
              }

              if (state.movieDetailStatus == MovieDetailStatus.error) {
                return const Center(
                  child: Text("An error occurred!"),
                );
              }

              return const Center(
                child: Text("An unexpected error occurred!"),
              );
            },
          ),
        ),
      ),
    );
  }
}
