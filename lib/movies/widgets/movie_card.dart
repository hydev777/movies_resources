import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_repository/movies_repository.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Hero(
          tag: 'hero-movie-title-${movie.id}',
          child: Text(
            movie.title!,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        onTap: () {
          context.push('/movies/${movie.id}');
        },
      ),
    );
  }
}
