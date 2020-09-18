import 'package:flutter/material.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Colors.white,
          brightness : Brightness.light,
        title: Text('Chat',style: TextStyle(color: Colors.black ),), 
      ),
      body: Container(
        child: ListView.builder(
          itemCount: ChatModel.dummyData.length,
          itemBuilder: (context, index) {
            var _model = ChatModel.dummyData[index];
            return Column(
              children: <Widget>[
                Divider(
                  height: 12.0,
                ),
                ListTile(
                  leading:Icon(  Icons.message,  size: 32.0,  ),
                  title: Row(
                    children: <Widget>[
                      Text(_model.name),
                      SizedBox(
                        width: 16.0,
                      ),
                      Text(
                        _model.datetime,
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ],
                  ),
                  subtitle: Text(_model.message),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 14.0,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ChatModel { 
  ChatModel({this.avatarUrl, this.name, this.datetime, this.message});
  
  final String avatarUrl;
  final String name;
  final String datetime;
  final String message;
  static final List<ChatModel> dummyData = [
    ChatModel(
      avatarUrl: 'https://randomuser.me/api/portraits/women/34.jpg',
      name: 'Laurent',
      datetime: '20:18',
      message: 'How about meeting tomorrow?',
    ),
    ChatModel(
      avatarUrl: 'https://randomuser.me/api/portraits/women/49.jpg',
      name: 'Tracy',
      datetime: '19:22',
      message: 'I love that idea, it s great!',
    ),
    ChatModel(
      avatarUrl: 'https://randomuser.me/api/portraits/women/77.jpg',
      name: 'Claire',
      datetime: '14:34',
      message: 'I wasn t aware of that. Let me check',
    ),
    ChatModel(
      avatarUrl: 'https://randomuser.me/api/portraits/men/81.jpg',
      name: 'Joe',
      datetime: '11:05',
      message: 'Flutter just release 1.0 officially. Should I go for it?',
    ),
    ChatModel(
      avatarUrl: 'https://randomuser.me/api/portraits/men/83.jpg',
      name: 'Mark',
      datetime: '09:46',
      message: 'It totally makes sense to get some extra day-off.',
    ),
    ChatModel(
      avatarUrl: 'https://randomuser.me/api/portraits/men/85.jpg',
      name: 'Williams',
      datetime: '08:15',
      message: 'It has been re-scheduled to next Saturday 7.30pm',
    ),
  ];
}