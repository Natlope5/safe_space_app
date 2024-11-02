// Create a User model
class AppUser {
  final String uid;
  final String email;

  AppUser({required this.uid, required this.email});

  // Override toString for better debugging
  @override
  String toString() {
    return 'AppUser{uid: $uid, email: $email}';
  }
}
