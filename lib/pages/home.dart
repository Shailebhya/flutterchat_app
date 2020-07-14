import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterchat_app/models/user.dart';
import 'package:flutterchat_app/pages/create_account.dart';
import 'package:flutterchat_app/pages/groupChat.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn =GoogleSignIn();
final usersRef = Firestore.instance.collection('users');
final groupRef = Firestore.instance.collection('groups');
final groupChatRef = Firestore.instance.collection('groupChats');
User currentUser;
final timestamp = DateTime.now();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController chatController = TextEditingController();
  final _scaffoldKey=GlobalKey<ScaffoldState>();
  bool isAuth = false;
  String groupId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  handleSignIn(GoogleSignInAccount account)async{
    if(account!= null) {
      //print('User Signed in!:$account');
      await createUserInFirestore();
      setState(() {
        isAuth =true;
      });
//      configurePushNotifications();
    }
    else{
      setState(() {
        isAuth = false;
      },
      );
    }
  }
  createUserInFirestore()async {
    //check if user exists in users collection in database according to their id
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc =await usersRef.document(user.id).get();

    if(!doc.exists){
      // if the ussr doesnt exist then we want to tske them to create account page

      final username =await Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateAccount()));

      //get username from create account , use it to make new user doc.
      //in user collection
      usersRef.document(user.id).setData({
        "id": user.id,
        "username": username,
        "photoUrl":user.photoUrl,
        "email": user.email,
        'displayName': user.displayName,
        "bio":"",
        "timestamp":timestamp,
        "challengeID":currentUser.challengeID
      });
      doc =await usersRef.document(user.id).get();
    }
    currentUser = User.fromDocument(doc);
    print(currentUser);
    print(currentUser.username);

  }
  login(){
    googleSignIn.signIn().then((action){setState(() {
      isAuth=true;
    });});
  }
  logout(){
    googleSignIn.signOut();
  }
  createGroup() async {
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc =await groupRef.document(currentUser.challengeID).get();

    if(!doc.exists){
      groupRef
          .document(currentUser.challengeID)
          .collection('groupId')
          .document(groupId)
          .collection('members')
          .document(user.id)
          .setData({
        "id": user.id,
        "username": currentUser.username,
        "timestamp": timestamp,
        "challengeId":currentUser.challengeID,
        "chatData": chatController.text,
        'timestamp': timestamp

      });
    }
  }
  Widget buildAuthScreen() {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: GestureDetector(
          child: Container(height: 100,
            width: 100,
            child: Center(child: Text('Challenege 1')),
            color: Colors.red,),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>GroupChats() ));

          },
        ),
      ),
    );
  }
  Scaffold buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Theme.of(context).accentColor,
                  Theme.of(context).primaryColor,


                ]
            )
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("FLutterChat", style: TextStyle(
              fontSize: 30,
              color: Colors.white,
            ),
            ),
            GestureDetector(
              onTap: () => login(),
              child: Container(
                width: 260,
                height: 60,
                child: Text("GOOgle"),
              ),
            )
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    },
        onError: (err){
          print('Error signing in : $err');
        }
    );//Reauthenticate when app is opened!!
    googleSignIn.signInSilently(suppressErrors: false)
        .then((account){
      handleSignIn(account);

    }).catchError((err){
      print('Error signing in : $err');
    });
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
