import 'package:attendo/pages/form_page.dart';
import 'package:attendo/themes.dart';
import 'package:attendo/utils/shared_preferences_fetcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/error_screen.dart';
import 'pages/home_screen.dart';
import 'pages/loading_page.dart';
import 'pages/login_page.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPreferencesFetcher.init();

  runApp(ProviderScope(child: AttendoApp()));
}

final firebaseinitializerProvider = FutureProvider<FirebaseApp>((ref) async {
  return await Firebase.initializeApp();
});

class AttendoApp extends ConsumerWidget {
  const AttendoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final initialize = watch(firebaseinitializerProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.themes(context),
      home: initialize.when(
          data: (data) {
            return AuthChecker();
          },
          loading: () => LoadingScreen(),
          error: (e, stackTrace) => ErrorScreen(e, stackTrace)),
      routes: {
        '/login': (context) => LoginPage(),
        '/form': (context) => FormPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}

class AuthChecker extends ConsumerWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _authState = watch(authStateProvider);
    return _authState.when(
        data: (data) {
          if (data != null) return HomePage();
          return LoginPage();
        },
        loading: () => LoadingScreen(),
        error: (e, trace) => ErrorScreen(e, trace));
  }
}
