import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:museparent14nov/API/UserProvider.dart';
import 'package:museparent14nov/BottomNavigationView/HomeScreen.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../Validations.dart';


class AnimatedPositionedWidget extends StatefulWidget {
  @override
  _AnimatedPositionedWidgetState createState() =>
      _AnimatedPositionedWidgetState();
}

class _AnimatedPositionedWidgetState extends State<AnimatedPositionedWidget> {
  bool showMessage = false,resend=false,
      _isvisible = true,
      funBtn = false,
      _validate = false;
  GlobalKey<FormState> _key = new GlobalKey();
  double op=0.0;

  final TextEditingController _phoneNumberController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId;
  final otpKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final int delayedAmount = 500;

    return SafeArea(
      child: Form(
        key: _key,
        autovalidate: _validate,
        child: Scaffold(
          //   backgroundColor: Colors.amber[100],

          body: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Center(
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: h,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [Colors.amber, Colors.white70])),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Stack(
                          children: <Widget>[

                            Padding(
                                padding: const EdgeInsets.all(28.0),
                                child: Image.asset("images/muse.png")),
                            //    delay: delayedAmount + 2000,
                            //   ),


                            AnimatedPositioned(
                              duration: Duration(milliseconds: 500),
                              bottom: showMessage ? 50 : 100,
                              child:
                              Container(
                                width: w / 1.1,
                                height: h / 1,
                                color: Colors.transparent,

                                child:

                                Opacity(
                                  opacity: op,
                                  child: Form(
                                    key: otpKey,
                                    child: PinPut(
                                        textStyle: TextStyle(fontSize: h/40),
                                        fieldsCount: 6,
                                        onSubmit: (String pin) {

                                          buttonLogin(pin);

                                         /* if (pin.length == 6 ) {
                                            Navigator.of(context).push(MaterialPageRoute(
                                                builder: (BuildContext) {
                                                  return HomeScreen();
                                                }));

                                            pin = "";
                                          }*/
                                        }),
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(
                                  top: h / 4, left: w / 20, right: w / 20),
                              child: TextFormField(
                                controller: _phoneNumberController,
                                keyboardType: TextInputType.number,
                                autofocus: false,
                                decoration: InputDecoration(
                                  labelText: 'Enter registered Mobile Number',
                                  counterText: "",
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(10.0)),
                                ),
                                maxLength: 10,
                                //  validator: Validations().validateMobile,
                                onSaved: (String value) {},
                              ),
                            ),



                          ],
                        ),
                      ),
                    ),



                    Visibility(

                      visible: _isvisible,
                      child: Padding(
                        padding: EdgeInsets.only(top: h/1.9,left: w/3),
                        child: FloatingActionButton.extended(

                          backgroundColor: Colors.orange,
                          onPressed: () {
                            if (_key.currentState.validate()) {
                              _key.currentState.save();

                              setState(() {
                                showMessage ? showMessage = false : showMessage = true;

                                _isvisible = false;

                                resend=true;
                                funBtn = true;
                                op=1;


                              });
                            } else {
                              // validation error
                              setState(() {
                                _validate = true;
                              });
                            }


                            _verifyPhoneNumber();

                          },
                          icon: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                          label: Text(
                            showMessage ? "Login" : "Send OTP",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),

                    Visibility(
                      visible: resend,
                      child: Padding(
                        padding: EdgeInsets.only(top: h/1.9,left: w/3),
                        child: InkWell(
                          child:
                          FloatingActionButton.extended(

                            backgroundColor: Colors.orange,
                            onPressed: () {

                              setState(() {

                                resend=false;
                                _isvisible = true;
                                showMessage = false;
                                op=0;
                              });


                            },
                            icon: Icon(
                              Icons.insert_emoticon,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Resend",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
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

  void _verifyPhoneNumber() async {


    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _auth.signInWithCredential(phoneAuthCredential);

      Toast.show('Received phone auth credential', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      Toast.show('Phone number verification failed', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      Toast.show("Please check your phone for the verification code", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      this._verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this._verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: '+91'+_phoneNumberController.text,
        timeout: const Duration(seconds: 20),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  //on click of login button code
  void buttonLogin(String pin) {

    final SmsForm = otpKey.currentState;
    if (SmsForm.validate()) {
      SmsForm.save();

      _signInWithPhoneNumber(pin).then((FirebaseUser user,) {


        print("OTP print");

         if (pin.length == 6 ) {
                       Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext) {
                                return HomeScreen();
                            }));

                            pin = "";
         }


        savevalue('+91'+_phoneNumberController.text);

//        Navigator.push(
//            context, MaterialPageRoute(builder: (context) => HomeScreen()));

        Toast.show("Successfully signed in", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);


      }).catchError((e) {

        print(e.code);
        switch (e.code) {
          case 'ERROR_INVALID_VERIFICATION_CODE':
          //  authError = 'Invalid Email';
            Toast.show('INVALID VERIFICATION CODE', context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            print('yes code is invalid');
            break;

          case 'ERROR_SESSION_EXPIRED':

            if (pin.length == 6 ) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext) {
                    return HomeScreen();
                  }));

              pin = "";
            }


            savevalue('+91'+_phoneNumberController.text);


            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));


//            Toast.show('SESSION EXPIRED RESEND', context,
//                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          //  print('yes code is invalid');
            break;

          default:
        }
      });
    }
  }

  Future<FirebaseUser> _signInWithPhoneNumber(String pin) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: pin,
    );

    print(credential);
    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    return user;
  }

  void savevalue(String mobileNo) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('mobileNo', mobileNo);
    print(mobileNo+"mobileNo in save value fun");
  }

}


