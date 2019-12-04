import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../SideDrawerNavgation.dart';
import '../Utils.dart';
import 'Chat.dart';

class ChatList extends StatefulWidget {

  String uid;

  ChatList({Key key, this.uid}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  String name;
  String myuid;
  @override
  void initState() {
    _getCurrentUserName();

    // TODO: implement initState
    super.initState();
  }
  _getCurrentUserName() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {

      name= user.displayName;
    });

    print(name);
  }
  @override
  Widget build(BuildContext context) {

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    Utils utils = new Utils();

    return Scaffold(

      endDrawer: SideDrawer(),

      appBar: utils.appbar_white(h / 35, h / 80, Colors.white,
          Colors.white, 'Messages', '', 1.0),
      body:

      _getData(),
    );
  }

  Widget _getData() {

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('userschat')
            .snapshots(),

        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');

          else if(snapshot.data != null)
          {
            int l=snapshot.data.documents.length;
            if(l==0)
              return Center(child: Image.asset("images/aadit.jpg"));
          }

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return new ListView(

                scrollDirection: Axis.vertical,
                children: snapshot.data.documents.map((DocumentSnapshot document) {

                  String name = document['name'].toString();
                  String uid= document['uid'].toString();
                  print(widget.uid.toString()+"myUid");

                  return Card(

                    elevation: 10.0,
                    child:

                    InkWell(
                      onTap: () {
                        print(uid);
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ChatRoom(uid: uid,pname:name)));
                      },

                      child: Padding(padding: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new Container(
                                  width: h/11,
                                  height: h/11,      //changes
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(width: 0.5),
                                    image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage("images/aadit.jpg")
                                    ),
                                  )),
                            ),


                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(name),
                            ),
                          ],
                        ),


                      ),
                    ),

                  );

                }).toList(),
              );
          }
        },
      );
  }
}
