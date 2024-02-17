import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_dashes/enums/status.dart';
import 'package:meet_dashes/model/user_model.dart';

class ConnectionsPage extends StatefulWidget {
  const ConnectionsPage({super.key});

  @override
  State<ConnectionsPage> createState() => _ConnectionsPageState();
}

class _ConnectionsPageState extends State<ConnectionsPage> {
  late CollectionReference<UserModel> collectionRef;
  Status userLoadingStatus = Status.none;
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    collectionRef = FirebaseFirestore.instance.collection('user').withConverter(
        fromFirestore: (data, _) => UserModel.fromJson(data.data()!),
        toFirestore: (user, _) => user.toJson());
    _getUser();
  }

  Future<void> _getUser() async {
    setState(() {
      userLoadingStatus = Status.loading;
    });
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      setState(() {
        userLoadingStatus = Status.error;
      });
      return;
    }
    final user = await collectionRef.doc(currentUser.uid).get();
    if (!user.exists) {
      setState(() {
        userLoadingStatus = Status.error;
      });
      return;
    }
    setState(() {
      this.currentUser = user.data();
      userLoadingStatus = Status.success;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conexiones'),
        actions: [
          IconButton(
            onPressed: () {
              context.push('/camera');
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Builder(builder: (context) {
        if (userLoadingStatus == Status.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (userLoadingStatus == Status.error) {
          return SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Usuario no encontrado, completa tu información'),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _getUser();
                  },
                  child: const Text('Re-intentar'),
                )
              ],
            ),
          );
        }
        if (currentUser == null) {
          return const Center(
            child: Text('Usuario no encontrado'),
          );
        }
        return StreamBuilder(
            stream: collectionRef
                .where('connections', arrayContains: currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final userDocs = snapshot.data?.docs;
              if (!snapshot.hasData || userDocs == null || userDocs.isEmpty) {
                return const Center(
                  child: Text('Sin conexiones'),
                );
              }
              final users = userDocs.map((e) => e.data()).toList();
              return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            user.photoURL ?? 'https://via.placeholder.com/150'),
                      ),
                      title: Text(
                        user.displayName ?? 'Sin nombre',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      subtitle:
                          Text(user.shortDescription ?? 'Sin descripción'),
                    );
                  });
            });
      }),
    );
  }
}
