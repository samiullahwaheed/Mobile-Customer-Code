class GoogleUserModel {
  final String userId;
  final String name;
  final String email;
  final String photo;
  // final String accessToken;
  final String idToken; // ✅ added

  GoogleUserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.photo,
    // required this.accessToken,
    required this.idToken,
  });
}


