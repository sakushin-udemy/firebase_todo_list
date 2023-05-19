import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/db_user.dart';

part 'authentication_repository.g.dart';

@riverpod
Stream<String> firebaseUid(ref) {
  return FirebaseAuth.instance.userChanges().map((user) => user?.uid ?? '');
}

@riverpod
Stream<bool> firebaseLogin(ref) {
  return firebaseUid(ref).map((e) => e.isNotEmpty);
}

class AuthenticationRepository {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> register(DbUser user, String password) async {
    final result = await auth.createUserWithEmailAndPassword(
      email: user.email,
      password: password,
    );

    String? uid = result.user?.uid;
    if (uid == null) {
      throw Exception('Registering user in firebase was failed.');
    }

    final firebaseUser = result.user!;
    firebaseUser.updateDisplayName(user.loginName);

    return uid;
  }

  Stream<bool> isLogin() {
    return auth.userChanges().map((user) => user != null);
  }

  Stream<String> uid() {
    return auth.userChanges().map((user) => user?.uid ?? '');
  }

  Future<void> signOut() async {
    auth.signOut();
  }

  Future<void> login(String email, String password) async {
    auth.signInWithEmailAndPassword(email: email, password: password);
  }
}
