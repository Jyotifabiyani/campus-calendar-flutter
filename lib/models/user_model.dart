class User {
  String username;
  String email;
  String password;
  String role;
  String extraField; // Can store branch (for students) or council name (for admins)

  User({
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    required this.extraField,
  });

  // Convert User object to Map (for database storage)
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'role': role,
      'extraField': extraField,
    };
  }

  // Create a User object from a Map (retrieved from database)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
      extraField: map['extraField'],
    );
  }
}
