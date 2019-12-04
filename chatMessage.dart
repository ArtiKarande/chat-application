/*
author  : Arti Karande
Date : 10/10/2019

Copyright  2019

*/

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../Utils.dart';

class chatMessage extends StatefulWidget {

  chatMessage({Key key, this.selection}) : super(key: key);

  final int selection;

  @override
  _chatMessageState createState() => _chatMessageState();
}

class _chatMessageState extends State<chatMessage> with SingleTickerProviderStateMixin{

  Utils utils = new Utils();
  final color1 = const Color(0xffF2F2F2);
  final color2 = const Color(0xFFF2F2F2);
  int index = 0;
  TabController _controller;

  @override
  void initState() {
    _controller = new TabController(length: 2, vsync: this);
    _controller.addListener(() {

    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return LayoutBuilder(builder: (context, constrain) {
      if (constrain.maxWidth <= 600) {
        return Stack(
          children: <Widget>[
            SafeArea(
              child: DefaultTabController(
                length: 2,
                child: Scaffold(

                  appBar: AppBar(
                    elevation: 0,
                    flexibleSpace:  utils.Appbar_Image(h / 25, h / 70,'images/kids_activity.png' , Colors.white, 2.0,'Message','Important messages'),

                    //fun_Appbar(h/25,h/70),

                    bottom:  PreferredSize(
                  preferredSize: Size.fromHeight(h / 12),
                  child: Column(
                    children: <Widget>[
                      Card(
                        shape: Border.all(color: Colors.green),
                        color: Colors.white,
                        child: fun_tabBar(h / 40),
                      ),
                    ],
                  ),
                ),
                  ),
                  floatingActionButton: fun_floating_actionButton(50.0),
                  body: fun_tabbarView(h / 45,h / 50),
                ),
              ),
            ),
          ],
        );
      }
      else{
        return Stack(
          children: <Widget>[
            SafeArea(
              child: DefaultTabController(
                length: 2,
                child: Scaffold(

                  appBar: AppBar(
                    elevation: 0,
                    flexibleSpace: utils.Appbar(context, 28, 60, Colors.black, Colors.black, 'Message', '',2.0,5.0),

                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(h / 12),
                      child: Column(
                        children: <Widget>[
                          Card(
                            shape: Border.all(color: Colors.blue),
                            color: Colors.white,
                            child: fun_tabBar(h / 30),
                          ),
                        ],
                      ),
                    ),
                  ),
                  floatingActionButton: fun_floating_actionButton(50.0),
                  body: fun_tabbarView(h / 45,h / 50),
                ),
              ),
            ),
          ],
        );
      }
    }
    );
  }



  //inbox and send tabs
  fun_tabBar(double fontSize){
    return TabBar(
      controller: _controller,

      //indicatorWeight: 20,
      indicatorSize: TabBarIndicatorSize.label,
      labelPadding: EdgeInsets.only(left: 0, right: 0),
      dragStartBehavior: DragStartBehavior.start,
      unselectedLabelColor: Colors.black,

      indicatorColor: Colors.red,
      indicator: new BubbleTabIndicator(
        indicatorHeight: 40.0,
        indicatorColor: Colors.green,
        //padding: EdgeInsets.all(20),
        tabBarIndicatorSize: TabBarIndicatorSize.tab,
        indicatorRadius: .0,
      ),

      tabs: <Widget>[
        Tab(
          child: Container(
            alignment: Alignment.center,

            child: Text(
              "Inbox",
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: fontSize,
              ),
            ),
          ),
        ),
        Tab(
          child: Container(
            alignment: Alignment.center,

            child: Text(
              "Sent",
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: fontSize,
              ),
            ),
          ),
        ),
      ],
    );
  }

  //action button
  fun_floating_actionButton(double btn_size){

    return FloatingActionButton(
      onPressed: () {
        /* Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>CreateMessage()),
                    );*/
      },
      child: Icon(
        Icons.add,
        size: btn_size,
      ),
      backgroundColor: Colors.green,

    );

  }

  //tab declaration - inbox and sent
  fun_tabbarView(double text_fontSize,double btn_fontSize){

    return TabBarView(
      controller: _controller,
      children: <Widget>[
        InboxTabBar(color2,text_fontSize,btn_fontSize),
        SentTabBar(color2,text_fontSize,btn_fontSize),
      ],
    );
  }

  InboxTabBar(Color color, double text_fontSize,btn_fontSize) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    TextStyle textStyle = new TextStyle(
        fontSize: text_fontSize, fontFamily: 'Nunito', color: Colors.black);

    return Container(
      height: h,
      width: w,
      color: color,
      child: ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Colors.white,
            thickness: 8,
          ),
          itemCount: 10,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("From : ", style: textStyle),

                            Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Abhijit Deshmukha",
                                      style: textStyle,
                                    ),
                                    Text(
                                      "(LKG A)",
                                      style: textStyle,
                                    )
                                  ],
                                )),

                            //
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          children: <Widget>[
                            Text("Roll No : ", style: textStyle),
                            Text("30", style: textStyle),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          children: <Widget>[
                            Text("Date : ", style: textStyle),
                            Flexible(
                                child: Text("10 may,2019", style: textStyle)),
                          ],
                        ),
                      ),

                      /*  Container(
                          height: h/20,
                          width: w/2,

                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.yellow
                          ),
                          child: Center(child: Text("List of Students added",style: textStyle,)))*/
                    ],
                  ),
                ),
                trailing: Container(
                  height: h / 25,
                  width: w / 3.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white, boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],),

                  child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          "View message",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: btn_fontSize,
                              fontFamily: 'Nunito'),
                        ),
                      )),
                ),
              ),
            );
          }),
    );
  }

  SentTabBar(Color color, double text_fontSize,btn_fontSize) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    TextStyle textStyle = new TextStyle(
        fontSize: text_fontSize, fontFamily: 'Nunito', color: Colors.black);

    return Container(
      height: h,
      width: w,
      color: color,
      child: ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Colors.white,
            thickness: 8,
          ),
          itemCount: 10, //users.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("To : ", style: textStyle),

                            Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Abhijit Deshmukha",
                                      style: textStyle,
                                    ),
                                    Text(
                                      "(LKG A)",
                                      style: textStyle,
                                    )
                                  ],
                                )),

                            //
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          children: <Widget>[
                            Text("Roll No : ", style: textStyle),
                            Text("30", style: textStyle),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          children: <Widget>[
                            Text("Date : ", style: textStyle),
                            Flexible(
                                child: Text("10 may,2019", style: textStyle)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                trailing: Container(
                  height: h / 25,
                  width: w / 3.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    color: Colors.white, boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],),
                  child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          "View message",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: btn_fontSize,
                              fontFamily: 'Nunito'),
                        ),
                      )),
                ),
              ),
            );
          }),
    );
  }


}
