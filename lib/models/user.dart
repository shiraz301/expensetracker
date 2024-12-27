class User {
  String username;
  String password;

  User({required this.username, required this.password});

  // Convert User object to map
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
    };
  }

  // Convert map to User object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'],
      password: map['password'],
    );
  }
}
