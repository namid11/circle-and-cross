import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool userIsFirst = true;

  @override
  void initState() {
    SharedPreferences.getInstance().then((sp) {
      setState(() {
        userIsFirst = sp.getBool("user_first") ?? true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "設定",
          style: GoogleFonts.mPLUSRounded1c(
              textStyle: TextStyle(color: Colors.black),
              fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "モード：",
                    style: GoogleFonts.mPLUSRounded1c(
                      color: Color(0xff333333),
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  userIsFirst
                      ? Text("先攻",
                          style: GoogleFonts.mPLUSRounded1c(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w800,
                              fontSize: 30))
                      : Text("後攻",
                          style: GoogleFonts.mPLUSRounded1c(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w800,
                              fontSize: 30))
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            onPressed: () {
                              setState(() {
                                this.userIsFirst = true;
                              });
                            },
                            color: Colors.redAccent,
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Container(
                                  height: 150,
                                  child: Center(
                                    child: Text(
                                      "先攻",
                                      style: GoogleFonts.mPLUSRounded1c(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 30),
                                    ),
                                  )),
                            )),
                      )),
                  Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            onPressed: () {
                              setState(() {
                                this.userIsFirst = false;
                              });
                            },
                            color: Colors.blueAccent,
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Container(
                                  height: 150,
                                  child: Center(
                                    child: Text(
                                      "後攻",
                                      style: GoogleFonts.mPLUSRounded1c(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 30),
                                    ),
                                  )),
                            )),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          SharedPreferences.getInstance().then((sp) {
            sp.setInt(
                "theme_color", userIsFirst ? Colors.redAccent.value : Colors.blueAccent.value);
            sp.setBool("user_first", userIsFirst);
          });
          Navigator.of(context).pushReplacementNamed('start');
        },
        label: Text(
          '更新',
          style: GoogleFonts.mPLUSRounded1c(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        icon: Icon(
          Icons.update,
          color: Colors.white,
        ),
        backgroundColor: Colors.orangeAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
