import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:pelanggan/layanan_page/chat.dart';
import 'package:pelanggan/model/class_model.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Rethinkdb r = Rethinkdb();

class Chat1 extends StatelessWidget {
  Chat1(
      {Key key,
      @required this.dataP,
      @required this.peerId,
      @required this.peerAvatar})
      : super(key: key);
  final String peerId;
  final String peerAvatar;
  final Map<String, dynamic> dataP;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat Pesanan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        //centerTitle: true,
      ),
      body: ChatScreen(
        dataP: dataP,
        peerId: peerId,
        peerAvatar: peerAvatar,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  ChatScreen(
      {Key key,
      @required this.dataP,
      @required this.peerId,
      @required this.peerAvatar})
      : super(key: key);
  final String peerId;
  final String peerAvatar;
  final Map<String, dynamic> dataP;
  @override
  State createState() =>
      ChatScreenState(dataP: dataP, peerId: peerId, peerAvatar: peerAvatar);
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState(
      {Key key,
      @required this.dataP,
      @required this.peerId,
      @required this.peerAvatar});
  final Map<String, dynamic> dataP;
  var connection;
  final f = new DateFormat('yyyy-MM-dd hh:mm');
  var now = new DateTime.now();
  var berlinWallFell = new DateTime.utc(1989, 11, 9);
  StreamController<List<ChatItem>> aa = StreamController<List<ChatItem>>();

  List<ChatItem> event = [];

  String peerId;
  String peerAvatar;
  String id;

  var listMessage;
  String groupChatId;

  File imageFile;
  bool isLoading;
  bool isShowSticker;
  String imageUrl;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    if (connection != null) {
      // print("Error: null");
      connection.close();
    }
    super.dispose();
  }

  @override
  void initState() {
    focusNode.addListener(onFocusChange);

    groupChatId = '';

    isLoading = false;
    isShowSticker = false;
    imageUrl = '';

    // readLocal();
    koneksi();
    super.initState();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  void tes() async {
    try {
      // Create the database connection.

      // Drop the table if it exists.
      /*await r
          .db('test')
          .tableList()
          .contains('tv_shows')
          .not()
          .rqlDo((databaseExists) {
        return r.branch(
            databaseExists, r.tableList(), r.db('test').tableDrop('tv_shows'));
      }).run(connection);

      // Create the table if it doesn't exist.
      await r
          .db('test')
          .tableList()
          .contains('tv_shows')
          .rqlDo((databaseExists) {
        return r.branch(databaseExists, r.tableList(),
            r.db('test').tableCreate('tv_shows'));
      }).run(connection);*/

      // Insert some data.  final String id;

      await r.table('tv_shows').insert([
        {
          'idFrom': '1',
          'idTo': '2',
          'type': 0,
          'content': "tesss",
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString()
          //f.format(new DateTime.now())
        }
      ]).run(connection);

      // Display the data count.
      var count = await r.table('tv_shows').count().run(connection);
      print("count: $count");
    } catch (e) {
      print("Error: $e");
    } finally {
      //print("null");
      if (connection != null) {
        // print("Error: null");
        //connection.close();
      }
    }
  }

  void koneksi() async {
    id = widget.dataP['uid'].toString() ?? '';
    print('hhhhhhhhh $id');
    groupChatId = '$peerId-$id';

    if (id.hashCode <= peerId.hashCode) {
      groupChatId = 'd_c_$id-$peerId';
    } else {
      groupChatId = 'd_c_$peerId-$id';
    }

    try {
      // Create the database connection.
      // connection = await r.connect(db: "test", host: "10.0.2.2", port: 28015);
      connection =
          await r.connect(db: "test", host: "192.168.1.44", port: 28015);
      // print(r.table('tv_shows').changes().run(connection).asStream());

      // List<ChatItem> event = [ChatItem(id: 1)];
      //  movieListSink.add(event);
      //   _movieListController.add(event);
      // movieListSink
      //     .addStream(r.table('tv_shows').changes().run(connection).asStream());
      //  _movieListController.close();
      //movieListSink.close();
      //.addStream(r.table('tv_shows').changes().run(connection).asStream());
      //Iterable list =r.table('tv_shows').changes().run(connection).asStream();
      // var promosi = list.map((season) => ChatItem.fromJson(season)).toList();
      //movieListStream1.map((event) => ChatItem.fromJson(event)).toList());

      await r.table('tv_shows').changes().run(connection).then((value) {
        Cursor aaa = value;

        //  print(" aaa=${aaa.toList().toString()}   ");
        // print(" value=$value   ");
        //var body = json.decode("[" + value + "]");
        // print(" body=$body   ");
        aaa.forEach((element) {
          //  print(" element=$element   ");
          final Map<String, dynamic> e = element;
          // var body = json.decode("[" + element.toString() + "]");
          ChatItem orderan = ChatItem.fromJson(e["new_val"]);

          // event.insert(0, orderan);
          // event.add(orderan);
          // Iterable list = event;
          print(" orderan=${e["new_val"].toString()}   ");
          print(event.length);
          setState(() {
            event.insert(event.length, orderan);

            // event.length = isShowSticker;
            aa.add(event);
          });
          //    element1.map((season) => ChatItem.fromJson(season)).toList();
          // e.map((key, value) => (season) => ChatItem.fromJson(season)).toList())
          // var orderan = ChatItem.fromJson(element["new_val"]).;
          //   Iterable list = orderan.toString();
          //  Iterable list = body['data'];
          // var promosi =
          //   list.map((season) => ChatItem.fromJson(season)).toList();
          //  print(promosi);
          /*    // aa.add(element["new_val"]);
          aa.add(promosi);
          setState(() {
            isShowSticker = isShowSticker + 1;
          });*/
          // aa.addStream(aa, cancelOnError: false);
          // var body = json.decode("[" + element.toString() + "]");
          //    print(" orderan=$orderan.  ");
        });
        //Map<String, dynamic> dataP = value;
        /* aaa.forEach((element) {
          final Map<String, dynamic> e = element;
          print(" element=$element   ");
          e.forEach((key, value) {
            print(" value=$value   ");
            var body = json.decode("[" + value + "]");
            //  Iterable list = body["new_val"];
            //var promosi =
            //  list.map((season) => ChatItem.fromJson(season)).toList();
            // print(" promosi=$promosi   ");

            if (key == "new_val" && value != null) {
              //final Map<String, dynamic> dataP = value;
              // dataP.addAll(other)
              // print(" id=${dataP["id"]}  time= ${dataP["time"]}");
            }
          });
        });*/
      }).whenComplete(() {
        print("whenComplete");
      });
    } catch (e) {
      print("Error: $e");
    } finally {
      //print("null");
      if (connection != null) {
        // print("Error: null");
        // connection.close();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/chat/wa.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            // color: Colors.grey,
            child: Column(
              children: <Widget>[
                // List of messages
                //mengambil chat sebelumnya satu hari aja 20 jam dari sekarang
                buildListMessage(),

                // Sticker
                (isShowSticker ? buildSticker() : Container()),
                // Input content
                buildInput(),
              ],
            ),
          ),
          // Loading
          buildLoading()
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  //tempat emotion
  Widget buildSticker() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi1', 2),
                child: Image.asset(
                  'assets/images/chat/mimi1.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi2', 2),
                child: Image.asset(
                  'assets/images/chat/mimi2.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi3', 2),
                child: Image.asset(
                  'assets/images/chat/mimi3.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi4', 2),
                child: Image.asset(
                  'assets/images/chat/mimi4.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi5', 2),
                child: Image.asset(
                  'assets/images/chat/mimi5.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi6', 2),
                child: Image.asset(
                  'assets/images/chat/mimi6.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi7', 2),
                child: Image.asset(
                  'assets/images/chat/mimi7.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi8', 2),
                child: Image.asset(
                  'assets/images/chat/mimi8.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi9', 2),
                child: Image.asset(
                  'assets/images/chat/mimi9.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xffE8E8E8), width: 0.5)),
          color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Widget buildItem(int index, ChatItem document) {
    print(index);
    if (document.idFrom == id) {
      // Right (my message)
      return Row(
        children: <Widget>[
          document.type == 0
              // Text
              ? Container(
                  child: Text(
                    document.content,
                    style: TextStyle(color: Color(0xff203152)),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(
                      bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                      right: 10.0),
                )
              : document.type == 1
                  // Image
                  ? Container(
                      child: FlatButton(
                        child: Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xfff5a623)),
                              ),
                              width: 200.0,
                              height: 200.0,
                              padding: EdgeInsets.all(70.0),
                              decoration: BoxDecoration(
                                color: Color(0xffE8E8E8),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Material(
                              child: Image.asset(
                                'assets/images/chat/img_not_available.jpeg',
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                            imageUrl: document.content,
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      FullPhoto(url: document.content)));
                        },
                        padding: EdgeInsets.all(0),
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                          right: 10.0),
                    )
                  // Sticker
                  : Container(
                      child: Image.asset(
                        'assets/images/chat/${document.content}.gif',
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.cover,
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                          right: 10.0),
                    ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMessageLeft(index)
                    ? Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xfff5a623)),
                            ),
                            width: 35.0,
                            height: 35.0,
                            padding: EdgeInsets.all(10.0),
                          ),
                          imageUrl: peerAvatar,
                          width: 35.0,
                          height: 35.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(width: 35.0),
                document.type == 0
                    ? Container(
                        child: Text(
                          document.content,
                          style: TextStyle(color: Colors.black87),
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: 200.0,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0)),
                        margin: EdgeInsets.only(left: 10.0),
                      )
                    : document.type == 1
                        ? Container(
                            child: FlatButton(
                              child: Material(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(0xfff5a623)),
                                    ),
                                    width: 200.0,
                                    height: 200.0,
                                    padding: EdgeInsets.all(70.0),
                                    decoration: BoxDecoration(
                                      color: Color(0xffE8E8E8),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Material(
                                    child: Image.asset(
                                      'assets/images/chat/img_not_available.jpeg',
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  imageUrl: document.content,
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FullPhoto(url: document.content)));
                              },
                              padding: EdgeInsets.all(0),
                            ),
                            margin: EdgeInsets.only(left: 10.0),
                          )
                        : Container(
                            child: Image.asset(
                              'assets/images/chat/${document.content}.gif',
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                            margin: EdgeInsets.only(
                                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                                right: 10.0),
                          ),
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(document.timestamp))),
                      style: TextStyle(
                          color: Color(0xffaeaeae),
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

//mengambil chat sebelumnya satu hari aja 20 jam dari sekarang
  Widget buildListMessage() {
    return Expanded(
      flex: 1,
      child: groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xfff5a623))))
          : StreamBuilder(
              stream: aa.stream,
              initialData: [],
              builder: (context, AsyncSnapshot<List> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xfff5a623))));
                } else {
                  //  listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(index, snapshot.data[index]),
                    itemCount: snapshot.data.length,
                    // reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }

  Future<void> onSendMessage(String content, int type) async {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      try {
        await r.table('tv_shows').insert([
          {
            'idFrom': '1',
            'idTo': '2',
            'type': 0,
            'content': content,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString()
            //f.format(new DateTime.now())
          }
        ]).run(connection);

        // Display the data count.
        var count = await r.table('tv_shows').count().run(connection);
        print("count: $count");
      } catch (e) {
        print("Error: $e");
      } finally {
        //print("null");
        if (connection != null) {
          // print("Error: null");
          //connection.close();
        }
      }
      //  listScrollController.animateTo(0.0,
      //     duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  Future uploadFile() async {
    /* var fileName = DateTime.now().millisecondsSinceEpoch.toString();
    var reference = FirebaseStorage.instance.ref().child(fileName);
    var uploadTask = reference.putFile(imageFile);
    var storageTaskSnapshot = await uploadTask.onComplete;
    await storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'This file is not an image');
    });*/
    setState(() {
      isLoading = false;
    });
    Fluttertoast.showToast(msg: 'This file is not an image');
  }

  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      await uploadFile();
    }
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  //inputan pesan
  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: getImage,
                color: Colors.grey,
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.face),
                onPressed: getSticker,
                color: Colors.grey,
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Expanded(
            child: Container(
              width: 111,
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                minLines: 1,
                maxLength: 100,
                style: TextStyle(color: Colors.black, fontSize: 15.0),
                controller: textEditingController,
                //  decoration: InputDecoration.collapsed(
                //   hintText: 'Type your message...',
                //   hintStyle: TextStyle(color: Color(0xffaeaeae)),
                //  ),

                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Color(0xffaeaeae)),
                  counterText: '',
                  contentPadding:
                      EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
                ),
                focusNode: focusNode,
              ),
            ),
          ),
          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: Color(0xff006666),
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xffE8E8E8), width: 0.5)),
          color: Colors.white),
    );
  }

  //loading saat aplikasi dibuka
  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xfff5a623))),
              ),
              //color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  Future<bool> onBackPress() {
    /*Firestore.instance
          .collection('flutter_customer')
          .document(id)
          .updateData({'chattingWith': null});*/
    Navigator.pop(context);

    return Future.value(false);
  }
}
