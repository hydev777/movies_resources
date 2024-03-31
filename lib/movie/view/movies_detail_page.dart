import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_repository/movies_repository.dart';

import '../../users/cubit/users_cubit.dart';
import '../cubit/movie_cubit.dart';
import 'add_review_popup.dart';

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
  void successDialog(String body) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  void errorDialog(String body) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

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

              errorDialog('An error ocurred creating your review!');
            }

            if (state.createReviewStatus == CreateReviewStatus.completed) {
              context.read<MovieCubit>().onGetMovieById(widget.id!);

              successDialog('Your Review has been added!');
            }

            if (state.deleteReviewStatus == DeleteReviewStatus.error) {
              context.read<MovieCubit>().onGetMovieById(widget.id!);

              errorDialog('An error ocurred deleting your review!');
            }

            if (state.deleteReviewStatus == DeleteReviewStatus.completed) {
              context.read<MovieCubit>().onGetMovieById(widget.id!);

              successDialog('Review has been deleted!');
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
                            child: Card(
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(review.title!),
                                    currentUser!.id == review.userReviewerId
                                        ? IconButton(
                                            onPressed: () async {
                                              try {
                                                final result =
                                                    await InternetAddress
                                                        .lookup('example.com');
                                                if (result.isNotEmpty &&
                                                    result[0]
                                                        .rawAddress
                                                        .isNotEmpty) {
                                                  if (context.mounted) {
                                                    context
                                                        .read<MovieCubit>()
                                                        .onDeleteReview(
                                                            review.id!);
                                                  }
                                                }
                                              } catch (err) {
                                                errorDialog(
                                                    'Not internet connection');
                                                print(err);
                                              }
                                            },
                                            icon: const Icon(Icons.delete),
                                          )
                                        : const SizedBox.shrink()
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(review.body!),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    RatingBar.builder(
                                      updateOnDrag: false,
                                      initialRating: double.parse(
                                          review.rating.toString()),
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      itemSize: 30,
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      ignoreGestures: true,
                                      onRatingUpdate: (rating) {},
                                    ),
                                  ],
                                ),
                              ),
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
