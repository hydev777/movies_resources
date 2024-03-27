// import 'package:coolmovies/movie/cubit/movie_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class MoviesDetailBody extends StatefulWidget {
//   const MoviesDetailBody ({super.key, this.id});

//   final String? id;

//   @override
//   State<MoviesDetailBody> createState() => _MoviesDetailState();
// }

// class _MoviesDetailState extends State<MoviesDetailBody> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await context.read<MovieCubit>().onGetMovieById(widget.id!);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           SliverAppBar(
//             stretch: true,
//             onStretchTrigger: () async {},
//             stretchTriggerOffset: 300.0,
//             expandedHeight: 250.0,
//             flexibleSpace: FlexibleSpaceBar(
//               background: Hero(
//                 tag: "hero-movie-${widget.id}",
//                 child: Image.network(
//                   "https://assetsio.gnwcdn.com/death-stranding_0807KVj.jpg?width=1600&height=900&fit=crop&quality=100&format=png&enable=upscale&auto=webp",
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           ),
//           const SliverToBoxAdapter(
//             child: Padding(
//               padding: EdgeInsets.all(5),
//               child: Text(
//                 "Test",
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
