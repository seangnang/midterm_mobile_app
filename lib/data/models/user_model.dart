class UserModel {
  final int? id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? image;
  final String? token;
  final String? refreshToken;

  UserModel({
    this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.gender,
    this.image,
    this.token,
    this.refreshToken,
  });

  String get fullName {
    if ((firstName != null && firstName!.isNotEmpty) || (lastName != null && lastName!.isNotEmpty)) {
      return '${firstName ?? ''} ${lastName ?? ''}'.trim();
    }
    return username;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
      gender: json['gender']?.toString(),
      image: json['image']?.toString() ?? json['avatar']?.toString(),
      token: json['token']?.toString() ?? json['accessToken']?.toString(),
      refreshToken: json['refreshToken']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'image': image,
      'token': token,
      'refreshToken': refreshToken,
    };
  }
}

