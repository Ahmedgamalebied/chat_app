import 'package:chat_app/constant/constant.dart';
import 'package:chat_app/models/Chat_Bubble.dart';
import 'package:chat_app/models/Messages.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  static String id = 'ChatScreen';
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollection);
  TextEditingController controller = TextEditingController();
  final _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy('creatAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messageList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messageList.add(Message.fromjson(snapshot.data!.docs[i]));
          }
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: KprimaryColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(Klogo),
                  ),
                  const Text('Chat App'),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                      reverse: true,
                      controller: _controller,
                      itemCount: messageList.length,
                      itemBuilder: (context, index) {
                        return messageList[index].id == email
                            ? ChatBubble(message: messageList[index])
                            : ChatBubbleFriend(message: messageList[index]);
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: controller,
                    onSubmitted: (data) {
                      messages.add({
                        'message': data,
                        'creatAt': DateTime.now(),
                        'id': email,
                      });
                      controller.clear();
                      _controller.animateTo(0,
                          curve: Curves.fastOutSlowIn,
                          duration: const Duration(seconds: 1));
                    },
                    decoration: InputDecoration(
                        hintText: 'Send your message',
                        suffixIcon: GestureDetector(
                          child: const Icon(
                            Icons.send,
                            color: KprimaryColor,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                        )),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Scaffold(
            body: Text('loading...........'),
          );
        }
      },
    );
  }
}
