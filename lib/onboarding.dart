import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('¡Bienvenido!'),
        ),
        body: const Column(
          children: <Widget>[
            Text('Para continuar, completa tus datos'),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nombre',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Descripción corta',
              ),
            ),
          ],
        ));
  }
}
