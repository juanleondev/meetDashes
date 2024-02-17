import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_dashes/model/user_model.dart';
import 'package:meet_dashes/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  var isInProgress = false;

  Future<UserModel?> _getUser(String userId) async {
    try {
      final user = await FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .withConverter<UserModel>(
              fromFirestore: (snapshot, _) =>
                  UserModel.fromJson(snapshot.data()!),
              toFirestore: (user, _) => user.toJson())
          .get();
      return user.data()!;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: QRView(
        key: const Key('qr_view_key'),
        onQRViewCreated: (controller) {
          controller.scannedDataStream.listen((event) async {
            if (isInProgress) {
              return;
            }
            if (event.code?.isEmpty ?? true) {
              return;
            }
            final uri = Uri.parse(event.code!);
            if (uri.pathSegments.length != 2) {
              return;
            }
            if (uri.pathSegments[0] != 'user') {
              return;
            }
            isInProgress = true;
            final uid = uri.pathSegments[1];

            final user = await _getUser(uid);
            if (user == null) {
              return;
            }
            if (context.mounted) {
              await showDialog(
                  context: context,
                  builder: (context) {
                    return QRUserDialog(user: user);
                  });
              isInProgress = false;
            }
          });
        },
      ),
    );
  }
}

class QRUserDialog extends StatelessWidget {
  const QRUserDialog({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<UserRepository>().currentUser;
    final isSameUser = currentUser?.uid == user.uid;
    final isAlreadyConnected =
        currentUser?.connections.contains(user.uid) ?? false;

    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 300,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                      user.photoURL ?? 'https://via.placeholder.com/150'),
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.displayName ?? 'Usuario sin nombre'),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(user.shortDescription ?? 'Usuario sin descripción'),
                  ],
                ),
                const Expanded(child: SizedBox()),
                Visibility(
                  visible: !isSameUser && !isAlreadyConnected,
                  child: IconButton(
                    icon: const Icon(Icons.person_add),
                    onPressed: () async {
                      try {
                        if (currentUser == null) {
                          return;
                        }
                        final updatedCurrentUser = currentUser.copyWith(
                            connections: [
                              ...currentUser.connections,
                              user.uid
                            ]);
                        await context
                            .read<UserRepository>()
                            .updateUser(updatedCurrentUser);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Fuiste añadido a las conexiones de ${user.displayName ?? 'Desconocido'}'),
                            ),
                          );
                          context.pop();
                        }
                      } catch (_) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Error al agregar usuario a tus conexiones'),
                            ),
                          );
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
