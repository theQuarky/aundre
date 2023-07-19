// ignore_for_file: non_constant_identifier_names

class UserModal {
  final String? username;
  final String? email;
  final String? uid;
  final String? profile_pic;
  final String? name;
  final String? dob;
  final String? gender;
  final String? intro;
  final List<String?>? followers;
  final List<String?>? following;
  final List<String?>? requests;
  final List<String?>? pending_requests;
  final List<String?>? notes;
  final bool? is_private;
  final String? created_at;
  final String? updated_at;

  UserModal({
    this.username,
    this.email,
    this.uid,
    this.profile_pic,
    this.name,
    this.dob,
    this.intro,
    this.gender,
    this.followers,
    this.following,
    this.requests,
    this.pending_requests,
    this.notes,
    this.is_private,
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
      gender: json['gender'],
      followers: json['followers'].map<String>((e) => e.toString()).toList(),
      following: json['following'].map<String>((e) => e.toString()).toList(),
      requests: json['requests'].map<String>((e) => e.toString()).toList(),
      pending_requests:
          json['pending_requests'].map<String>((e) => e.toString()).toList(),
      is_private: json['is_private'],
      notes: json['notes'].map<String>((e) => e.toString()).toList(),
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      name: json['name'],
      dob: json['dob'],
    );
  }

  String toLocalString() {
    return '''
          UserModal(username: $username, 
                    email: $email, 
                    uid: $uid, 
                    profile_pic: $profile_pic, 
                    name: $name, 
                    dob: $dob, 
                    intro: $intro, 
                    followers: $followers, 
                    following: $following, 
                    requests: $requests, 
                    pending_requests: $pending_requests 
                    notes: $notes,
                    created_at: $created_at, 
                    updated_at: $updated_at)
          ''';
  }
}
