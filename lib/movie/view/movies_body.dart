// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// import '../cubit/movie_cubit.dart';

// class MoviesBody extends StatefulWidget {
//   const MoviesBody({
//     super.key,
//   });

//   @override
//   State<MoviesBody> createState() => _MoviesBodyState();
// }

// class _MoviesBodyState extends State<MoviesBody> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Movies'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 OutlinedButton.icon(
//                   onPressed: () {
//                     context.read<MovieCubit>().onGetAllMovies();
//                   },
//                   icon: const Icon(Icons.download),
//                   label: const Text('Fetch data'),
//                 ),
//                 const SizedBox(height: 16),
//                 BlocBuilder<MovieCubit, MovieState>(builder: (context, state) {
//                   if (state.moviesStatus == MoviesStatus.initial) {
//                     return const Text('No movies fetched');
//                   }

//                   if (state.moviesStatus == MoviesStatus.completed) {
//                     final movies = context.watch<MovieCubit>().state.movies;

//                     return Column(
//                       children: [
//                         ...movies!
//                             .map(
//                               (movie) => Card(
//                                 child: ListTile(
//                                   title: Text(movie.title!),
//                                   onTap: () {
//                                     context.go('/movies/${movie.id}');
//                                   },
//                                 ),
//                               ),
//                             )
//                             .toList()
//                       ],
//                     );
//                   }

//                   if (state.moviesStatus == MoviesStatus.loading) {
//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }

//                   if (state.moviesStatus == MoviesStatus.empty) {
//                     return const Center(
//                       child: Text("No movies available"),
//                     );
//                   }

//                   if (state.moviesStatus == MoviesStatus.error) {
//                     return const Center(
//                       child: Text("An error has ocurred"),
//                     );
//                   }

//                   return const Center(
//                     child: Text("An unexpected error has ocurred"),
//                   );
//                 }),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
