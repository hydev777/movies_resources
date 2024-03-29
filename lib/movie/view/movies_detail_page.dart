import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_repository/movies_repository.dart';

import '../../users/cubit/users_cubit.dart';
import '../cubit/movie_cubit.dart';

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
    print(context.read<UsersCubit>().state.currentUser);

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
            if (state.createReviewStatus == CreateReviewStatus.completed) {
              context.read<MovieCubit>().onGetMovieById(widget.id!);
            }

            if (state.deleteReviewStatus == DeleteReviewStatus.completed) {
              context.read<MovieCubit>().onGetMovieById(widget.id!);
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
                        background: Hero(
                          tag: "hero-movie-${widget.id}",
                          child: Image.network(
                            movieDetails!.imgUrl!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          movieDetails.title!,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
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
                          children: [
                            const Text(
                              "Reviews",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                context
                                    .read<MovieCubit>()
                                    .onGetMovieById(widget.id!);
                              },
                              icon: const Icon(Icons.refresh),
                            ),
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
                                                  context
                                                      .read<MovieCubit>()
                                                      .onDeleteReview(
                                                          review.id!);
                                                } else {
                                                  print('not connected');
                                                }
                                              } catch (err) {
                                                print(err);
                                                print('not connected');
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

class AddReviewPopUp extends StatefulWidget {
  const AddReviewPopUp({
    super.key,
    this.movieId,
  });

  final String? movieId;

  @override
  State<AddReviewPopUp> createState() => _AddReviewPopUpState();
}

class _AddReviewPopUpState extends State<AddReviewPopUp> {
  int ratingCount = 1;
  String title = '';
  String body = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        height: 450,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          children: [
            const Text(
              'Your Review',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Title'),
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Body'),
              onChanged: (value) {
                setState(() {
                  body = value;
                });
              },
              maxLines: 6,
            ),
            const SizedBox(
              height: 10,
            ),
            RatingBar.builder(
              initialRating: 1,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              tapOnlyMode: true,
              itemSize: 30,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                ratingCount = int.parse(rating.toInt().toString()).round();
              },
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    final currentUser =
                        context.read<UsersCubit>().state.currentUser;

                    await context.read<MovieCubit>().onCreateReview(
                          title,
                          body,
                          widget.movieId!,
                          ratingCount,
                          currentUser!.id!,
                        );

                    if (context.mounted) {
                      context.pop();
                    }
                  },
                  child: const Text('Send'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
