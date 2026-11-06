import 'dart:convert';

class ProfileData {
  final String name;
  final String title;
  final String bio;
  final String? lastEdited;

  const ProfileData({
    required this.name,
    required this.title,
    required this.bio,
    this.lastEdited,
  });

  static const defaults = ProfileData(
    name: 'Shoru Senpai',
    title: 'Junior Full Stack Dev',
    bio: 'Suka makan dan mengerjakan kerjaan.',
  );

  Map<String, dynamic> toMap() => {
        'name': name,
        'title': title,
        'bio': bio,
        'lastEdited': lastEdited,
      };

  factory ProfileData.fromMap(Map<String, dynamic> map) => ProfileData(
        name: map['name'] as String? ?? defaults.name,
        title: map['title'] as String? ?? defaults.title,
        bio: map['bio'] as String? ?? defaults.bio,
        lastEdited: map['lastEdited'] as String?,
      );

  String toJson() => jsonEncode(toMap());

  factory ProfileData.fromJson(String source) =>
      ProfileData.fromMap(jsonDecode(source) as Map<String, dynamic>);
}