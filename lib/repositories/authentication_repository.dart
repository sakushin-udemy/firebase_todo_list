import 'package:firebase_auth/firebase_auth.dart';
import '../data/db_user.dart';

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
}
