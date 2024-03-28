import 'package:coolmovies/movie/cubit/movie_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movies_repository/movies_repository.dart';

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({Key? key, this.id}) : super(key: key);

  final String? id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return MovieCubit(
          moviesRepositories: context.read<MoviesRepository>(),
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
      await context.read<MovieCubit>().onGetMovieById(widget.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<MovieCubit, MovieState>(
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
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "Reviews",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  ...movieDetails.reviews!
                      .map(
                        (review) => SliverToBoxAdapter(
                          child: Card(
                            child: ListTile(
                              title: Text(review.title!),
                              subtitle: Column(
                                children: [
                                  Text(review.body!),
                                  RatingBar.builder(
                                    updateOnDrag: false,
                                    initialRating:
                                        double.parse(review.rating.toString()),
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
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
    );
  }
}
