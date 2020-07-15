import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat_app/pages/create_account.dart';
import 'package:flutterchat_app/pages/home.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutterchat_app/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GroupChats extends StatefulWidget {
  final String challengeID;
  final String groupId;


  GroupChats({
    this.challengeID,
    this.groupId
  });

  @override
  _GroupChatsState createState() => _GroupChatsState(
    challengeID:this.challengeID,
    groupId:this.groupId
  );
}

class _GroupChatsState extends State<GroupChats> {
  TextEditingController chatController = TextEditingController();

  final String challengeID;
  final String groupId;
  bool memberExists;

  _GroupChatsState({ this.challengeID,
    this.groupId});
   @override


  buildGroupChat() {
    return StreamBuilder(
      stream:groupRef
          .document(currentUser.challengeID)
          .collection('chats')
          .orderBy("timestamp", descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        List<Chat> groupChats = [];
        snapshot.data.documents.forEach((doc) {
          groupChats.add(Chat.fromDocument(doc));
        });
        return ListView(children: groupChats);
      },
    );
  }
  addChat(){
    groupRef
        .document(currentUser.challengeID)
        .collection('chats')
        .add({
      "id": currentUser.id,
      "username": currentUser.username,
      "avatarUrl": currentUser.photoUrl,
      "timestamp": timestamp,
      "challengeId":currentUser.challengeID,
      "chatData": chatController.text,
      "timestamp": timestamp

    }
    );
    chatController.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('sckbkj'),),
      body: Column(children: <Widget>[
        Expanded(
          child: buildGroupChat(),
        ),
        Divider(),
        ListTile(
          title: TextFormField(
            controller: chatController,
            decoration: InputDecoration(labelText: "Write a message..."),
          ),
          trailing: OutlineButton(
            onPressed:addChat ,
            borderSide: BorderSide.none,
            child: Text("Post"),
          ),
        ),
      ]),
    );
  }
}
class Chat extends StatelessWidget {
  final String username;
  final String userId;
  final String avatarUrl;
  final String chatData;
  final Timestamp timestamp;

  Chat({
    this.username,
    this.userId,
    this.avatarUrl,
    this.chatData,
    this.timestamp,
  });

  factory Chat.fromDocument(DocumentSnapshot doc) {
    return Chat(
      username: doc['username'],
      userId: doc['userId'],
      chatData: doc['chatData'],
      timestamp: doc['timestamp'],
      avatarUrl: doc['avatarUrl'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(chatData),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(avatarUrl),
          ),
          subtitle: Text(timeago.format(timestamp.toDate())),
        )
      ],
    );
  }
}