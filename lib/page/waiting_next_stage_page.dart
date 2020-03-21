import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gameon33/page/game_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaitingNextStagePage extends StatefulWidget {
  int drawCount;

  WaitingNextStagePage({this.drawCount});

  @override
  _WaitingNextStagePageState createState() => _WaitingNextStagePageState();
}


class _WaitingNextStagePageState extends State<WaitingNextStagePage> {
  double _progressValue = 0.0;
  
  bool _userIsFirst = true;
  Timer _timer;

  @override
  void initState() {
    const periodicTime = 10;
    const timeout = const Duration(milliseconds: periodicTime);
    _timer = Timer.periodic(timeout, (Timer t) {
      setState(() {
        _progressValue += 1.0 / (3000 / periodicTime);
        if (_progressValue > 1.0) {
          t.cancel();
//          Navigator.of(context).pushReplacementNamed("start");
          Navigator.pushReplacement(context, new MaterialPageRoute<Null>(
              settings: const RouteSettings(name: "/next-game"),
              builder: (BuildContext context) => GamePage.next(drawCount: widget.drawCount,)
          ));
        }
      });
    });

    SharedPreferences.getInstance().then((sp) {
      bool userIsFirst = sp.getBool("user_first") ?? true;
      setState(() {
        this._userIsFirst = userIsFirst;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: SafeArea(
          child: Container(
            constraints: BoxConstraints.expand(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: Text(
                      "次のステージまで",
                    style: GoogleFonts.mPLUSRounded1c(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Text(
                      "${(3.0 - _progressValue*3).ceil()}",
                      style: GoogleFonts.muli(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: CircularProgressIndicator(
                        value: _progressValue,
                        strokeWidth: 30,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 50),
                  child: RaisedButton(
                    onPressed: (){
                      if (_timer != null) _timer.cancel();
                      Navigator.of(context).pushReplacementNamed('start');
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    color: Colors.orange,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text(
                        "終了する",
                        style: GoogleFonts.mPLUSRounded1c(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
