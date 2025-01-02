class User {
  String email;
  String password;

  User({required this.email, required this.password});

  // Convert User object to map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }

  // Convert map to User object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'],
      password: map['password'],
    );
  }
}
// Model for Users
