import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_dashes/avatar_picker_page.dart';
import 'package:meet_dashes/enums/status.dart';
import 'package:meet_dashes/model/user_model.dart';
import 'package:meet_dashes/user_repository.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? currentAuthUser;
  UserModel? currentUser;
  TextEditingController nameController = TextEditingController();
  TextEditingController shortDescriptionController = TextEditingController();
  FlutterExperience experience = FlutterExperience.none;
  DocumentReference<UserModel>? userRef;
  Status userUpdateStatus = Status.none;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    currentAuthUser = FirebaseAuth.instance.currentUser;
    if (currentAuthUser == null) {
      return;
    }
    userRef = FirebaseFirestore.instance
        .collection('user')
        .doc(currentAuthUser!.uid)
        .withConverter<UserModel>(
            fromFirestore: (snapshot, _) =>
                UserModel.fromJson(snapshot.data()!),
            toFirestore: (user, _) => user.toJson());
    final user = await userRef?.get();
    if (user == null) {
      return;
    }
    setState(() {
      currentUser = user.data();
      nameController.text = currentUser?.displayName ?? '';
      shortDescriptionController.text = currentUser?.shortDescription ?? '';
      experience = currentUser?.flutterExperience ?? FlutterExperience.none;
    });
  }

  Future<void> _updateUser() async {
    try {
      if (userRef == null) {
        return;
      }
      setState(() {
        userUpdateStatus = Status.loading;
      });
      await userRef?.set(currentUser == null
          ? UserModel(
              uid: currentAuthUser!.uid,
              displayName: nameController.text,
              shortDescription: shortDescriptionController.text,
              flutterExperience: experience)
          : currentUser!.copyWith(
              displayName: nameController.text,
              shortDescription: shortDescriptionController.text,
              flutterExperience: experience,
            ));
      setState(() {
        userUpdateStatus = Status.success;
      });
    } catch (_) {
      setState(() {
        userUpdateStatus = Status.error;
      });
    }
  }

  Future<void> _updateAvatar(String avatarImage) async {
    try {
      if (userRef == null) {
        return;
      }
      setState(() {
        userUpdateStatus = Status.loading;
      });
      await userRef?.set(currentUser == null
          ? UserModel(
              uid: currentAuthUser!.uid,
              photoURL: avatarImage,
              displayName: nameController.text,
              shortDescription: shortDescriptionController.text)
          : currentUser!.copyWith(
              photoURL: avatarImage,
              displayName: nameController.text,
              shortDescription: shortDescriptionController.text,
            ));
      setState(() {
        userUpdateStatus = Status.success;
      });
    } catch (_) {
      setState(() {
        userUpdateStatus = Status.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Perfil',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xff04162E),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  context.read<UserRepository>().reset();
                  context.go('/sign-in');
                }
              },
            )
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 50,
                      backgroundImage: NetworkImage(currentUser?.photoURL ??
                          'https://via.placeholder.com/150'),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                          width: 30,
                          height: 30,
                          child: OpenContainer(
                              closedShape: const CircleBorder(),
                              closedBuilder: (_, __) {
                                return Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xffBD111A),
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                );
                              },
                              openBuilder: (_, __) {
                                return AvatarPickerPage(
                                  onAvatarSelected: (avatarImage) async {
                                    await _updateAvatar(avatarImage);
                                    setState(() {
                                      currentUser = currentUser?.copyWith(
                                          photoURL: avatarImage);
                                    });
                                  },
                                );
                              })),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Nombre',
                hintText: 'Nombre',
                border: OutlineInputBorder(),
              ),
              controller: nameController,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Descripción corta',
                hintText: 'Descripción corta',
                border: OutlineInputBorder(),
              ),
              controller: shortDescriptionController,
            ),
            const SizedBox(height: 16),
            // menu
            const Text('Experiencia con Flutter'),
            DropdownButton<FlutterExperience>(
              value: experience,
              isExpanded: true,
              onChanged: (FlutterExperience? value) {
                setState(() {
                  experience = value!;
                });
              },
              items: FlutterExperience.values
                  .map<DropdownMenuItem<FlutterExperience>>(
                      (FlutterExperience value) {
                return DropdownMenuItem<FlutterExperience>(
                  value: value,
                  child: Text(value.description,
                      style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
            ),

            if (userUpdateStatus == Status.loading)
              const Center(child: CircularProgressIndicator()),
            if (userUpdateStatus != Status.loading)
              ElevatedButton(
                onPressed: () => _updateUser(),
                child: const Text('Actualizar'),
              ),
          ],
        ));
  }
}

extension FlutterExperienceX on FlutterExperience {
  String get description {
    switch (this) {
      case FlutterExperience.none:
        return 'Ninguna';
      case FlutterExperience.beginner:
        return 'Principiante';
      case FlutterExperience.intermediate:
        return 'Intermedio';
      case FlutterExperience.advanced:
        return 'Avanzado';
    }
  }
}
