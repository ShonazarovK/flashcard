import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ownproject/features/collections/collections_screen.dart';
import 'package:ownproject/features/microphone/microphoen_page.dart';
import 'package:ownproject/features/onboard/choose_language.dart';
import 'package:ownproject/features/onboard/onboard1.dart';
import 'package:ownproject/features/photo/camera/capture_screen.dart';
import 'package:ownproject/features/photo/crop/crop_screen.dart';
import 'package:ownproject/features/premium_functions/next_exercicses.dart';
import 'package:ownproject/features/premium_functions/premium_page.dart';
import 'package:ownproject/features/profile/edit_page.dart';
import 'package:ownproject/features/profile/language_page.dart';
import 'package:ownproject/features/profile/profile_page.dart';
import 'package:ownproject/features/statistics/stats_page.dart';
import 'package:ownproject/features/vocabularies/vocabularies_screen.dart';
import 'package:ownproject/features/word_details/word_details_page.dart';


import '../features/activites/practice_flow_page.dart';
import '../features/add_screen/add_screen.dart';
import '../features/analyze/keep_analyze_screen.dart';
import '../features/analyze/keep_results_screen.dart';
import '../features/filter/filter_screen.dart';
import '../features/home/home_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',

    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),

      GoRoute(
        path: '/add-word',
        name: 'addWord',
        builder: (context, state) => const AddWordScreen(),
      ),
      GoRoute(
        path: '/stats',
        name: 'stats',
        builder: (context, state) => const StatisticsPage(),
      ),

      GoRoute(
        path: '/speak',
        name: 'speak',
        builder: (context, state) => const MicrophoneScreen(),
      ),

      GoRoute(
        path: '/language',
        name: 'language',
        builder: (context, state) => const LanguageScreen(),
      ),

      GoRoute(
        path: '/seeAll',
        name: 'seeAll',
        builder: (context, state) => const CollectionsScreen(),
      ),

      GoRoute(
        path: '/vocab',
        name: 'vocab',
        builder: (context, state) => const Vocebularies(),
      ),

      GoRoute(
        path: '/filter',
        name: 'filter',
        builder: (context, state) => const FiltersScreen(),
      ),
      GoRoute(
        path: '/edit',
        name: 'edit',
        builder: (context, state) => const EditProfilePage(),
      ),


      // GoRoute(
      //   path: '/ocr',
      //   name: 'ocr',
      //   builder: (context, state) {
      //     final autoStart = state.uri.queryParameters['auto'] == '1';
      //     return OfflineOcrScreen(autoStart: autoStart);
      //   },
      // ),
      GoRoute(
        path: '/photo',
        name: 'photo',
        builder: (context, state) => const CaptureScreen(),
      ),


      GoRoute(
        path: '/ai',
        name: 'ai',
        builder: (context, state) => const AiExercisePage(),
      ),

      GoRoute(
        path: '/next',
        name: 'next',
        builder: (context, state) => const AiExerciseLabPage(),
      ),

      GoRoute(
        path: '/chooseLanguage',
        name: 'chooseLanguage',
        builder: (context, state) => const ChooseLanguagePage(),
      ),
      GoRoute(
        path: '/onboard',
        name: 'onboard',
        builder: (context, state) => const OnboardingHeader(),
      ),


      GoRoute(
        path: '/worddetails',
        name: 'worddetails',
        builder: (context, state) {
          final autoStart = state.uri.queryParameters['auto'] == '1';
          return WordDetails();
        },
      ),


      GoRoute(
        path: '/crop',
        name: 'crop',
        builder: (context, state) {
          final path = state.extra as String?;
          if (path == null || path.isEmpty) {
            return const _RouteErrorScreen(message: "Crop route missing image path");
          }
          return CropScreen(imageFile: File(path));
        },
      ),


      GoRoute(
        path: '/test',
        name: 'test',
        builder: (context, state) => const PracticeFlowPage(),
      ),



      // =========================================================
      // ✅ KEEP FLOW (ANALYZE -> AUTO -> RESULTS)
      // =========================================================

      /// 1) General analyze route (mode + preview extra orqali keladi)
      GoRoute(
        path: '/keep-analyze',
        name: 'keepAnalyze',
        builder: (context, state) {
          KeepMode mode = KeepMode.sound;
          ImageProvider? preview;

          final extra = state.extra;
          if (extra is Map) {
            if (extra['mode'] is KeepMode) {
              mode = extra['mode'] as KeepMode;
            }
            if (extra['preview'] is ImageProvider) {
              preview = extra['preview'] as ImageProvider;
            }
          }

          return KeepAnalyzeScreen(
            mode: mode,
            previewImage: preview,
          );
        },
      ),

      /// 2) Results route (analyze tugaganda shu yerga otadi)
      GoRoute(
        path: '/keep-results',
        name: 'keepResults',
        builder: (context, state) {
          final extra = state.extra;
          final results =
          (extra is List<KeepWordItem>) ? extra : <KeepWordItem>[];
          return KeepResultsScreen(results: results);
        },
      ),

      /// 3) Convenience: keep-text -> keepAnalyze(image mode)
      GoRoute(
        path: '/keep-text',
        name: 'keepText',
        redirect: (context, state) => '/keep-analyze',
      ),

      /// 4) Convenience: keep-sound -> keepAnalyze(sound mode)
      GoRoute(
        path: '/keep-sound',
        name: 'keepSound',
        redirect: (context, state) => '/keep-analyze',
      ),
    ],

    // ✅ redirect orqali keep-text/keep-sound kelganda mode set qilish
    redirect: (context, state) {
      final loc = state.matchedLocation;

      if (loc == '/keep-text') {
        // keep-text ochilganda image analyze bo‘lsin (preview bermasa ham bo‘ladi)
        return '/keep-analyze';
      }

      if (loc == '/keep-sound') {
        return '/keep-analyze';
      }

      return null;
    },
  );
}


class _RouteErrorScreen extends StatelessWidget {
  final String message;
  const _RouteErrorScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Error")),
      body: Center(child: Text(message)),
    );
  }
}