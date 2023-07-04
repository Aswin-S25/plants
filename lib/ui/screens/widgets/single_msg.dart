import 'package:flutter/material.dart';

class SingleMessage extends StatelessWidget {
  final String? message;
  final bool? isMe;
  const SingleMessage({ required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe! ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          margin:EdgeInsets.all(16),
          constraints: BoxConstraints(
            maxWidth: 200,
          ),
          decoration:BoxDecoration(
            color:isMe! ? Color.fromARGB(255, 24, 227, 160) : Colors.grey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: isMe! ? Radius.circular(16) : Radius.circular(0),
              bottomRight: isMe! ? Radius.circular(0) : Radius.circular(16),
             ) ,
        )
        ,child: Text(message!, style: TextStyle(color: Colors.white),)
        ),
      ],
    );
  }
}
