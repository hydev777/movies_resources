import 'package:coolmovies/users/view/users_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../movie/view/movies_detail_page.dart';
import '../movie/view/movies_page.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: '/users',
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(
      path: '/movies',
      builder: (context, state) => const MoviesPage(),
    ),
    GoRoute(
      path: '/movies/:id',
      builder: (context, state) => MovieDetailPage(
        id: state.pathParameters['id'],
      ),
    ),
    GoRoute(
      path: '/users',
      builder: (context, state) => const UsersPage(),
    ),
  ],
);
