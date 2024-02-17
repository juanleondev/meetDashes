import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meet_dashes/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:meet_dashes/home_page.dart';
import 'package:meet_dashes/localizations/firebase_auth_es.dart';
import 'package:meet_dashes/qr_scanner_page.dart';
import 'package:meet_dashes/sign_in_page.dart';
import 'package:meet_dashes/user_repository.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final userRepository = UserRepository();
  await userRepository.getCurrentUser();
  runApp(MainApp(
    userRepository: userRepository,
  ));
}

final _router = GoRouter(
  redirect: (context, state) {
    if (FirebaseAuth.instance.currentUser != null) {
      return null;
    }
    return '/sign-in';
  },
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'camera',
          builder: (context, state) => const QRScannerPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/sign-in',
      builder: (context, state) => SignInPage(
        providers: [EmailAuthProvider()],
      ),
    ),
  ],
);

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.userRepository});

  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: userRepository,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          FirebaseUILocalizations.withDefaultOverrides(LabelOverrides()),
          FirebaseUILocalizations.delegate,
        ],
        theme: ThemeData.dark(useMaterial3: true).copyWith(
            dropdownMenuTheme: const DropdownMenuThemeData(
              textStyle: TextStyle(color: Colors.white),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: ButtonStyle(
                side: MaterialStateProperty.all(
                  const BorderSide(color: Colors.white),
                ),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                overlayColor: MaterialStateProperty.all(Colors.white12),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  const Color(0xffBD111A),
                ),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                overlayColor: MaterialStateProperty.all(Colors.white12),
              ),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              hintStyle: TextStyle(
                color: Colors.white,
              ),
              labelStyle: TextStyle(color: Colors.white60),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffBD111A))),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xff04162E),
              foregroundColor: Colors.white,
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color(0xffBD111A),
              foregroundColor: Colors.white,
            ),
            textTheme: GoogleFonts.montserratTextTheme().copyWith(
              displayLarge: const TextStyle(color: Colors.white),
              displayMedium: const TextStyle(color: Colors.white),
              displaySmall: const TextStyle(color: Colors.white),
              headlineLarge: const TextStyle(color: Colors.white),
              headlineMedium: const TextStyle(color: Colors.white),
              headlineSmall: const TextStyle(color: Colors.white),
              bodyLarge: const TextStyle(color: Colors.white),
              bodyMedium: const TextStyle(color: Colors.white),
              bodySmall: const TextStyle(color: Colors.white),
            ),
            scaffoldBackgroundColor: const Color(0xff04162E),
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xffBD111A))),
        routerConfig: _router,
      ),
    );
  }
}
