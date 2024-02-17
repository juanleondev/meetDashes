import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meet_dashes/model/user_model.dart';
import 'package:rxdart/subjects.dart';

class UserRepository {
  UserRepository();

  final BehaviorSubject<UserModel?> _userSubject = BehaviorSubject.seeded(null);

  Stream<UserModel?> get userStream => _userSubject.stream;

  UserModel? get currentUser => _userSubject.value;

  CollectionReference<UserModel> get ref =>
      FirebaseFirestore.instance.collection('user').withConverter<UserModel>(
          fromFirestore: (data, _) => UserModel.fromJson(data.data()!),
          toFirestore: (user, _) => user.toJson());

  Future<UserModel?> getUser(String userId) async {
    try {
      final user = await ref.doc(userId).get();
      return user.data();
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUser(UserModel user) async {
    await ref.doc(user.uid).set(user);
  }

  Future<UserModel?> getCurrentUser() async {
    final authUser = FirebaseAuth.instance.currentUser;
    if (authUser == null) {
      return null;
    }
    final user = await ref.doc(authUser.uid).get();
    _userSubject.add(user.data());
    return user.data();
  }

  void reset() {
    _userSubject.add(null);
  }
}
