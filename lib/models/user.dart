class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String website;
  final String company;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.website,
    required this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
      company: json['company']['name'],
    );
  }
}
