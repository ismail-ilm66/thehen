class RegisterItem {
  final String registerDestination;
  final String registerText;

  RegisterItem({
    required this.registerDestination,
    required this.registerText,
  });

  // Factory constructor to create an instance from a map
  factory RegisterItem.fromMap(Map<String, dynamic> map) {
    return RegisterItem(
      registerDestination:
          map['register_destination'] ?? 'https://thehen.io/registration/',
      registerText:
          map['register_text'] ?? 'Not registered yet? Click here to register',
    );
  }

  // Method to convert an instance into a map
  Map<String, dynamic> toMap() {
    return {
      'register_destination': registerDestination,
      'register_text': registerText,
    };
  }
}
