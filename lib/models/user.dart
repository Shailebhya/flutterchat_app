import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
   String username;
  final String email;
  final String photoUrl;
  final String realName;
  final String bio;
   String challengeID;

  User(
      {this.id,
      this.username,
      this.email,
      this.photoUrl,
      this.realName,
      this.bio,
      this.challengeID
      });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
        id: doc['id'],
        email: doc['email'],
        username: doc['username'],
        photoUrl: doc['photoUrl'],
        realName: doc['displayName'],
        bio: doc['bio'],
        challengeID : doc['challengeID']
    );
  }
}
