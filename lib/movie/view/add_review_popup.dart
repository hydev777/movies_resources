import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';

import '../../users/cubit/users_cubit.dart';
import '../cubit/movie_cubit.dart';

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
