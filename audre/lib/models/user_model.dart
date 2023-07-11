// ignore_for_file: non_constant_identifier_names

class UserModal {
  final String? username;
  final String? email;
  final String? uid;
  final String? profile_pic;
  final String? intro;
  final String? created_at;
  final String? updated_at;

  UserModal({
    this.username,
    this.email,
    this.uid,
    this.profile_pic,
    this.intro,
    this.created_at,
    this.updated_at,
  });

  factory UserModal.fromJson(Map<String, dynamic> json) {
    return UserModal(
      username: json['username'],
      email: json['email'],
      uid: json['uid'],
      profile_pic: json['profile_pic'],
      intro: json['intro'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
    );
  }
}
