import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../movies/movies.dart';
import '../users/users.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: '/users',
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(
      path: '/movies',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const MoviesPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
      routes: [
        GoRoute(
          path: ':id',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: MovieDetailPage(
              id: state.pathParameters['id'],
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/users',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const UsersPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
  ],
);
