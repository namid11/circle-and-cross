import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChallengeResultPage extends StatefulWidget {
  int drawCount;

  ChallengeResultPage({this.drawCount});

  @override
  _ChallengeResultPageState createState() => _ChallengeResultPageState();
}

class _ChallengeResultPageState extends State<ChallengeResultPage> {
  int totalDrawCount = 0;
  Timer timer;

  @override
  void initState() {
    SharedPreferences.getInstance().then((sp) {
      int seriesCount = sp.getInt("total_draw_count") ?? 0;

      setState(() {
        totalDrawCount = seriesCount;
      });
    });
    Future.delayed(Duration(milliseconds: 500)).then((v) {
      timer = Timer.periodic(Duration(milliseconds: 200), (Timer t) {
        setState(() {
          if (widget.drawCount > 0) {
            widget.drawCount -= 1;
            totalDrawCount += 1;
          }
        });
      });
    });

    super.initState();
  }


  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: null,
        body: Container(
          constraints: BoxConstraints.expand(),
          color: Colors.white,
          child: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "RESULT",
                      style: GoogleFonts.mPLUSRounded1c(
                          fontSize: 50,
                          fontWeight: FontWeight.w800,
                          color: Colors.orange),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.thumb_up,
                          color: Colors.orange,
                          size: 50,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "${widget.drawCount}",
                            style: GoogleFonts.muli(
                                color: Colors.orange,
                                fontSize: 50,
                                fontWeight: FontWeight.w900),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.stars,
                          color: Colors.orange,
                          size: 50,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "$totalDrawCount",
                            style: GoogleFonts.muli(
                                color: Colors.orange,
                                fontSize: 50,
                                fontWeight: FontWeight.w900),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed("start");
                      },
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      color: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        "TOPへ",
                        style: GoogleFonts.mPLUSRounded1c(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ),
      ),
    );
  }
}
