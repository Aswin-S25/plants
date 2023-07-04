// screens/chat_screen.dart

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plant/constants.dart';
import 'package:plant/models/doctors.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:plant/ui/screens/widgets/single_msg.dart';

class ChatScreen extends StatelessWidget {
  final Doctor? doctor;
  final Map<String, dynamic>? userMap;
  final String? chatRoomId;

  ChatScreen({
    Key? key,
    this.doctor,
    this.userMap,
    this.chatRoomId,
  });

  TextEditingController _messageController = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    log(chatRoomId!);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Chat with ${doctor!.id}',
            style: TextStyle(
              color: Constants.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height / 1.3,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: _firestore
                        .collection('doctors')
                        .doc('currentUser')
                        .collection('messages')
                        .doc(doctor!.id)
                        .collection('chats')
                        .orderBy('time', descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        log('chatroom');
                        if (snapshot.data!.docs.length < 1) {
                          return const Center(
                            child: Text('Say Hi!'),
                          );
                        }
                        // QuerySnapshot<Map<String, dynamic>>? querySnapshot =
                        //     snapshot.data;
                        // log(querySnapshot!.docs.length.toString());

                        // log(snapshot.data!.docs.toString() + " ");
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          reverse: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            bool isMe =
                                snapshot.data!.docs[index]['sender'] == 1;
                            // Map<String, dynamic> map =
                            //     snapshot.data!.docs[index].data()
                            //         as Map<String, dynamic>;

                            return SingleMessage(message:snapshot.data!.docs[index]['message'], isMe: isMe);
                            // ChatBubble(
                            //   alignment: (map['sendBy'] == userMap!['name'])
                            //       ? Alignment.centerRight
                            //       : Alignment.centerLeft,
                            //   backGroundColor:
                            //       (map['sendBy'] == userMap!['name'])
                            //           ? Colors.blue
                            //           : Colors.grey[300],
                            //   clipper: CustomChatBubbleClipper(
                            //       20.0), // Adjust the radius value as needed
                            //   child: Text(
                            //     map['message'],
                            //     style: TextStyle(
                            //       color: (map['sendBy'] == userMap!['name'])
                            //           ? Colors.white
                            //           : Colors.black,
                            //       fontWeight: FontWeight.w500,
                            //     ),
                            //   ),
                            //   // Add any other properties you want to customize the chat bubble
                            // );
                          },
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  )),
              const SizedBox(height: 10),

              // Input
              Container(
                  height: MediaQuery.of(context).size.height / 10,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.bottomCenter,
                  color: Colors.white,
                  child: Container(
                      height: MediaQuery.of(context).size.height / 12,
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            height: MediaQuery.of(context).size.height / 12,
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: 'Type a message',
                                border: OutlineInputBorder(
                                  // borderSide:
                                  //     BorderSide(color: Colors.),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                              onPressed: //sendMessage,
                                  () async {
                                String message = _messageController.text;
                                _messageController.clear();
                                await _firestore
                                    .collection('doctors')
                                    .doc("currentUser")
                                    .collection('messages')
                                    .doc(doctor!.id)
                                    .collection('chats')
                                    .add({
                                  'message': message,
                                  'sender': 1,
                                  'recevier': doctor!.id,
                                  'time': DateTime.now(),
                                }).then((value) {
                                  _firestore
                                      .collection('doctors')
                                      .doc(doctor!.id)
                                      .collection('messages')
                                      .doc("currentUser")
                                      .set({
                                    'last_msg': message,
                                  });
                                });
                                await _firestore
                                    .collection('doctors')
                                    .doc(doctor!.id)
                                    .collection('messages')
                                    .doc("currentUser")
                                    .collection('chats')
                                    .add({
                                  'message': message,
                                  'sender': 1,
                                  'recevier': doctor!.id,
                                  'time': DateTime.now(),
                                  'last_msg': message,
                                }).then((value) {
                                  _firestore
                                      .collection('doctors')
                                      .doc(doctor!.id)
                                      .collection('messages')
                                      .doc('currentUser')
                                      .set({
                                    'last_msg': message,
                                  });
                                });
                              },
                              icon: const Icon(Icons.send))
                        ],
                      ))),
            ],
          ),
        ));
  }

  //
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        'message': _messageController.text,
        'sendBy': userMap!['name'],
        'timestamp': FieldValue.serverTimestamp(),
      };

      _messageController.clear();
      await _firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .add(messages);
      log('Message sent');
    } else {
      log('Enter some text');
    }
  }
}

class CustomChatBubbleClipper extends CustomClipper<Path> {
  final double radius;

  CustomChatBubbleClipper(this.radius);

  @override
  Path getClip(Size size) {
    final path = Path();
    final double radiusToUse = radius.clamp(0, size.width / 2);

    path.lineTo(size.width - radiusToUse, 0);
    path.arcToPoint(
      Offset(size.width, radiusToUse),
      radius: Radius.circular(radiusToUse),
    );
    path.lineTo(size.width, size.height - radiusToUse);
    path.arcToPoint(
      Offset(size.width - radiusToUse, size.height),
      radius: Radius.circular(radiusToUse),
    );
    path.lineTo(radiusToUse, size.height);
    path.arcToPoint(
      Offset(0, size.height - radiusToUse),
      radius: Radius.circular(radiusToUse),
    );
    path.lineTo(0, radiusToUse);
    path.arcToPoint(
      Offset(radiusToUse, 0),
      radius: Radius.circular(radiusToUse),
    );

    return path;
  }

  @override
  bool shouldReclip(CustomChatBubbleClipper oldClipper) => false;
}
