import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key, required this.providers});

  final List<AuthProvider> providers;

  @override
  Widget build(BuildContext context) {
    final providers = [EmailAuthProvider()];
    return SignInScreen(
      providers: providers,
      headerMaxExtent: 300,
      headerBuilder: (context, constraints, shrinkOffset) {
        return Center(
          child: Container(
            width: 250,
            height: 250,
            color: const Color(0xff04162E),
            child: Image.asset('assets/images/logo.png'),
          ),
        );
      },
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          context.go('/');
        }),
        AuthStateChangeAction<UserCreated>((context, state) async {
          context.go('/');
        }),
      ],
    );
  }
}
