import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrCodePage extends StatelessWidget {
  const QrCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
          title: const Text('Comparte tu código QR'),
          leading: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              context.pop();
            },
          )),
      backgroundColor: Colors.white,
      body: Center(
          child: SizedBox(
        width: 200,
        height: 200,
        child: currentUser == null
            ? const Text('Hubo un error al obtener el usuario')
            : PrettyQrView.data(
                data: 'https://meet-dashes.web.app/user/${currentUser.uid}',
                decoration: const PrettyQrDecoration(
                  shape: PrettyQrSmoothSymbol(
                    color: Colors.black,
                  ),
                  // image: PrettyQrDecorationImage(
                  //     colorFilter:
                  //         ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  //     scale: 0.4,
                  //     image: AssetImage('assets/images/logo.png'),
                  //     ),
                ),
              ),
      )),
    );
  }
}
