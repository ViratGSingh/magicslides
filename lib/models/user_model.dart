class UserModel {
  final String id;
  final String email;
  final String? displayName;

  UserModel({required this.id, required this.email, this.displayName});

  // Factory constructor to create a UserModel from a JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
    );
  }

  // Method to convert UserModel instance to a JSON map
  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'displayName': displayName};
  }
}
