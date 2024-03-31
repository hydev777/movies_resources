import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:movies_repository/movies_repository.dart' hide User;
import 'package:users_repository/users_repository.dart';

import '../../utils/utils.dart';
import '../cubit/movie_cubit.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({
    super.key,
    required this.review,
    required this.currentUser,
  });

  final Review review;
  final User currentUser;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(review.title!),
            currentUser.id == review.userReviewerId
                ? IconButton(
                    onPressed: () async {
                      try {
                        final result =
                            await InternetAddress.lookup('example.com');
                        if (result.isNotEmpty &&
                            result[0].rawAddress.isNotEmpty) {
                          if (context.mounted) {
                            context
                                .read<MovieCubit>()
                                .onDeleteReview(review.id!);
                          }
                        }
                      } catch (err) {
                        if (context.mounted) {
                          errorDialog('Not internet connection', context);
                        }
                      }
                    },
                    icon: const Icon(Icons.delete),
                  )
                : const SizedBox.shrink()
          ],
        ),
        subtitle: AnimationLimiter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => FadeInAnimation(
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                Text(review.body!),
                const SizedBox(
                  height: 10,
                ),
                RatingBar.builder(
                  updateOnDrag: false,
                  initialRating: double.parse(
                    review.rating.toString(),
                  ),
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
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
    );
  }
}
