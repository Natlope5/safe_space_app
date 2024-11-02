import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Logger logger = Logger();

  // Method to sign in a user
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; // Return the user if successful
    } catch (e) {
      logger.e('Error signing in: $e'); // Log the error
      return null; // Return null if there's an error
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Register with email and password
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user; // Return the Firebase User directly
    } catch (e) {
      logger.e('Error registering user: $e'); // Log the error
      return null; // Return null if registration fails
    }
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
