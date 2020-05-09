import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseUser loguser;
final _firestore = Firestore.instance;
final textcontroller = TextEditingController();

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    getcurrentuser();
  }

  String messagetext;
  final _auth = FirebaseAuth.instance;

  void getcurrentuser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loguser = user;
        print(loguser.email);
      }
    } catch (e) {}
  }

//void getmessages() async {
//    final messages = await _firestore.collection('messages').getDocuments();
//    for(var message in messages.documents)
//      {
//        print(message.data);
//      }
//
//
//}
//  void mstream() async {
//    await for (var snap in _firestore.collection('messages').snapshots()) {
//      for (var message in snap.documents) {
//        print(message.data);
//      }
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text(
          ' Chat',
          style:
              new TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.black87,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/chat.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              messagestream(),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: textcontroller,
                        onChanged: (value) {
                          messagetext = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        textcontroller
                            .clear(); //for clearing text in the message to be sent
                        _firestore.collection('messages').add(
                          {
                            'text': messagetext,
                            'sender': loguser.email,
                            'time': FieldValue.serverTimestamp(),
                          },
                        );
                      },
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class messagestream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('time').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.lightBlueAccent,
          ));
        }
        {
          final mesgs = snapshot.data.documents.reversed;
          List<Bubblemes> bubblemes1 = [];
          for (var msg in mesgs) {
            final msgtxt = msg.data['text'];
            final msgsender = msg.data['sender'];
            final currentuser = loguser.email;

            final bubblemes = Bubblemes(
              sender: msgsender,
              text: msgtxt,
              isme: currentuser == msgsender,
            );
            bubblemes1.add(bubblemes);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              children: bubblemes1,
            ),
          );
        }
      },
    );
  }
}

class Bubblemes extends StatelessWidget {
  Bubblemes({this.sender, this.text, this.isme});
  final String sender;
  final String text;
  final bool isme;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(sender,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
              )),
          Material(
            borderRadius: isme
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
            elevation: 5,
            color: isme ? Colors.lightBlue : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(
                '$text',
                style: TextStyle(
                  fontSize: 15,
                  color: isme ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
