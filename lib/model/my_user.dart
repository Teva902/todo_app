class MyUser {
  static const String collectionName = 'users';
  String id;

  String name;

  String email;

  MyUser({required this.name, required this.email, required this.id});

  MyUser.fromFireStore(Map<String, dynamic> data)
      : this(
            id: data['id'] as String,
            name: data['name'] as String,
            email: data['email'] as String);

  Map<String, dynamic> toFireStore() {
    return {'id': id, 'name': name, 'email': email};
  }
}
