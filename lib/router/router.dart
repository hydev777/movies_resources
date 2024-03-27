import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../movie/view/movies_detail_page.dart';
import '../movie/view/movies_page.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: '/movies',
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
  ],
);
