import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class ChatRoom extends StatefulWidget {
  String uid;
  String pname;

  ChatRoom({Key key, @required this.uid, @required this.pname})
      : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _textController = new TextEditingController();
  String myuid;
  String ppuid;
  String groupChatId,aaa;
  var now;


  @override
  void initState() {

    myuid='';
    ppuid='';
    groupChatId='';

    ppuid = widget.uid.toString().trim();   // chat selected uid
    _getCurrentUserName();

   //now = new DateTime.now();

 //  aaa= DateFormat("H:m:s").format(now);

    super.initState();
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    Map<String, String> data = <String, String>{
      "content": text,
      "from": myuid.toString().trim(),
      "time": DateTime.now().toString()
    };
    Firestore.instance
        .collection("chat")
        .document(groupChatId.toString().trim())
        .collection('msg')
        .document()
        .setData(data);
  }

  _getCurrentUserName() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      myuid = user.uid.toString().trim();
    });
    if (myuid.hashCode <= ppuid.hashCode) {
        groupChatId = '$myuid-$ppuid';

    } else {
        groupChatId = '$ppuid-$myuid';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.pname),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 9,
              child:
                  sendChat(),
            ),
            _buildTextComposer()
          ],
        ));
  }

  Widget _buildTextComposer() {

    return new Container(
        color: Theme.of(context).cardTheme.color,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(children: <Widget>[
          new Flexible(
            child: new TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration:
              new InputDecoration.collapsed(hintText: widget.uid),
            ),
          ),
          new Container(
            margin: new EdgeInsets.symmetric(horizontal: 4.0),
            child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text)),
          ),
        ]));
  }

  sendChat() {
   return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('chat')
          .document(groupChatId.toString().trim())
          .collection('msg')
          .orderBy('time', descending: true)
          .snapshots(),

      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(                                              // my sender
              reverse: true,
              children: snapshot.data.documents
                  .map((DocumentSnapshot document) {
                if (myuid.toString().trim() == document['from']) {
                  return new Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[

                      Material(
                        color: Color(0xFFE7F9FE),
                        borderRadius: BorderRadius.circular(10.0),
                        elevation: 6.0,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                          child: Text(
                            document['content'],textAlign: TextAlign.right,

                          ),

                        ),
                      ),

                      Text(''),
                    ],
                  );

                } else {                                                      //receiver
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new
                      Material(
                        color: Colors.white ,
                        borderRadius: BorderRadius.circular(10.0),
                        elevation: 6.0,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                          child: Text(
                            document['content'].toString().trimLeft(),
                            textAlign: TextAlign.left,

                          ),
                        ),
                      ),

                    ],
                  );

                }
              }).toList(),
            );
        }
      },
    );

  }

}
