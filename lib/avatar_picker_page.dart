import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AvatarPickerPage extends StatelessWidget {
  const AvatarPickerPage({super.key, required this.onAvatarSelected});

  final Function(String) onAvatarSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            context.pop();
          },
        ),
        title: const Text('Elige un avatar'),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('app')
              .doc('eaPEEIPhPVaJNus5lKxd')
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error al cargar los avatares'),
              );
            }
            if (snapshot.data?.data() == null) {
              return const Center(
                child: Text('No se encontraron avatares'),
              );
            }
            final avatarImages =
                snapshot.data!.data()!['avatarImages'] as List<dynamic>;
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: avatarImages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      onAvatarSelected(avatarImages[index]);
                      context.pop();
                    },
                    child: ClipOval(
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Image.network(
                            avatarImages[index],
                            fit: BoxFit.cover,
                          )),
                    ));
              },
            );
          }),
    );
  }
}
