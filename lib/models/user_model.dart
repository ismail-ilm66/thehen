class User {
  final int id;
  final String username;
  final String name;
  final String firstName;
  final String lastName;
  final String email;
  final String link;
  final String locale;
  final String nickname;
  final String slug;
  final List<String> roles;
  final DateTime registeredDate;

  User({
    required this.id,
    required this.username,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.link,
    required this.locale,
    required this.nickname,
    required this.slug,
    required this.roles,
    required this.registeredDate,
  });

  // Factory method to create a User object from a JSON response
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      link: json['link'],
      locale: json['locale'],
      nickname: json['nickname'],
      slug: json['slug'],
      roles: List<String>.from(json['roles']),
      registeredDate: DateTime.parse(json['registered_date']),
    );
  }
}
