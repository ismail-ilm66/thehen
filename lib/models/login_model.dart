class TokenResponse {
  final String? token;
  final String? userEmail;
  final String? userNicename;
  final String? userDisplayName;
  final String? errorCode;
  final String? errorMessage;
  final int? status;

  TokenResponse({
    this.token,
    this.userEmail,
    this.userNicename,
    this.userDisplayName,
    this.errorCode,
    this.errorMessage,
    this.status,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('token')) {
      // Parsing for the Successful response
      return TokenResponse(
        token: json['token'],
        userEmail: json['user_email'],
        userNicename: json['user_nicename'],
        userDisplayName: json['user_display_name'],
      );
    } else if (json.containsKey('code')) {
      // Error response
      return TokenResponse(
        errorCode: json['code'],
        errorMessage: json['message'],
        status: json['data']?['status'],
      );
    }
    throw Exception("Unexpected response structure");
  }
}
