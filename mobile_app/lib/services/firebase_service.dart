import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final auth = FirebaseAuth.instance;
  final dbRef = FirebaseDatabase.instance.ref("nguoi_dung");

  Stream<DatabaseEvent> listenPlates() => dbRef.onValue;
  Stream<DatabaseEvent> listenAllPlates() {
    return FirebaseDatabase.instance.ref("nguoi_dung").onValue;
  }

  String getUserId() => auth.currentUser?.uid ?? 'unknown';

  Future<void> signIn(String email, String password) =>
      auth.signInWithEmailAndPassword(email: email, password: password);

  Future<void> register(String email, String password) =>
      auth.createUserWithEmailAndPassword(email: email, password: password);

  Future<void> signOut() => auth.signOut();

  Future<void> savePlate(String userId, Map<String, dynamic> data) async {
    await dbRef.child(userId).child('plates').push().set(data);
  }

  Future<String> getNgrokUrl() async {
    final snapshot = await FirebaseDatabase.instance.ref("ngrok_url").get();
    return snapshot.value?.toString() ?? '';
  }
}
