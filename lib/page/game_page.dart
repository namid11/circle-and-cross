import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gameon33/component/dialog_game_result.dart';
import 'dart:math' as math;
import 'package:gameon33/component/sign_tile.dart';
import 'package:gameon33/manager/cpu_manager.dart';
import 'package:gameon33/manager/game_manager.dart';
import 'package:gameon33/page/challenge_result_page.dart';
import 'package:gameon33/page/waiting_next_stage_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GamePage extends StatefulWidget {
  int drawCount;

  GamePage() {
    this.drawCount = 0;
  }

  GamePage.next({this.drawCount});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>
    with SingleTickerProviderStateMixin {
  int baseLength = 3;
  List<Widget> _gridList = [];
  GameManager _gameManager;
  CPUManager _cpuManager;

  int _userPreviousIndex;
  bool _userIsFirst = true;
  bool _playBackEnable = false;



  Future<void> resultDialog({RESULT result}) async {
    // Tile Effect
    await Future.delayed(Duration(milliseconds: 300));
    if (_gameManager.connectTiles.contains(true)) {
      for (int i = 0; i < _gameManager.connectTiles.length; i++) {
        _gameManager.connectTiles[i]
            ? (_gridList[i] as SignTile).effect()
            : (_gridList[i] as SignTile).disappear();
      }
    } else {
      _gridList.forEach((w) => (w as SignTile).drawEffect());
    }
    // ダイアログ表示
    await Future.delayed(Duration(milliseconds: 300));
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => DialogGameResult(
        result: result,
      ),
    );
    // 画面遷移
    await Future.delayed(Duration(milliseconds: 1300));
    Navigator.of(context).pop(true); // dispose dialog
    switch (result) {
      case RESULT.DRAW:
        // Add Total Draw Count
        SharedPreferences sp = await SharedPreferences.getInstance();
        int totalDrawCount = (sp.getInt("total_draw_count") ?? 0) + 1;
        sp.setInt("total_draw_count", totalDrawCount);

        Navigator.pushReplacement(
            context,
            new MaterialPageRoute<Null>(
                settings: const RouteSettings(name: "/next-game"),
                builder: (BuildContext context) => GamePage.next(
                  drawCount: widget.drawCount + 1,
                )
            ));
        return;
      case RESULT.USER_WIN:
        pushResult();
        return;
      case RESULT.USER_LOSE:
        pushResult();
        return;
      default:
        Navigator.of(context).pushReplacementNamed('start');
        return;
    }
  }

  void pushResult() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute<Null>(
            settings: RouteSettings(name: "/result"),
            builder: (BuildContext context) => ChallengeResultPage(
              drawCount: widget.drawCount,
            )
        ));
  }

  bool resultCheck(RESULT result) {
    if (result == RESULT.NONE) {
      return false;
    } else {
      resultDialog(result: result);
      return true;
    }
  }

  void _cpuPlay() {
    int playIndex = _cpuManager.play();
    (this._gridList[playIndex] as SignTile)
        .setStatusWidget(_gameManager.turnUser());
  }

  @override
  void initState() {
    for (int i = 0; i < math.pow(baseLength, 2); i++) {
      _gridList.add(SignTile(
        tileIndex: i,
        sign: SIGN.NONE,
        listener: (index) {
          // tileタップ時のListener //
          if (_gameManager.connectTiles.contains(true)) return;
          if (_gameManager.gameField[index] != SIGN.NONE) return;

          // User Play
          _gameManager.play(index: index);
          (this._gridList[index] as SignTile)
              .setStatusWidget(_gameManager.turnUser());
          if (resultCheck(_gameManager.result())) return;
          _userPreviousIndex = index;

          // CPU Play
          _cpuPlay();
          if (resultCheck(_gameManager.result())) return;

          // Enable PlayBack Button
          setState(() {
            _playBackEnable = true;
          });
        },
      ));
    }

    SharedPreferences.getInstance().then((sp) {
      bool userIsFirst = sp.getBool("user_first") ?? true;
      _gameManager = GameManager.origin(userIsFirst: userIsFirst);
      _cpuManager = CPUManager(gameManager: _gameManager);
      setState(() {
        this._userIsFirst = userIsFirst;
      });

      if (!userIsFirst) _cpuPlay();
      setState(() {
        _playBackEnable = false;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 60,
                height: 60,
                margin: EdgeInsets.only(top: 20, left: 20),
                child: FlatButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text(
                              "ATTENTION",
                            style: GoogleFonts.mPLUSRounded1c(
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                              color: Colors.orange,
                            ),
                          ),
                          content: Text(
                            "終了しますか？\nこのゲームの記録は反映されません",
                            style: GoogleFonts.notoSans(
                              fontSize: 14,
                              color: Colors.orange
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("OK", style: GoogleFonts.muli(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                              ),),
                              onPressed: () => Navigator.of(context).pushNamed('start'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  padding: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  color: Colors.orange,
                  child: Icon(Icons.close, color: Colors.white, size: 40,),
                ),
              )
          ),
          Container(
              constraints: BoxConstraints.expand(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.thumb_up,
                          size: 50,
                          color: Colors.orange,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            "${widget.drawCount}",
                            style: GoogleFonts.muli(
                              fontWeight: FontWeight.bold,
                              fontSize: 50,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      height: MediaQuery.of(context).size.width - 50,
                      width: MediaQuery.of(context).size.width - 50,
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                        color: Color(0xff555555),
                      ),
                      child: ScrollConfiguration(
                        // スクロール管理的な？
                        behavior: SimpleScrollBehavior(),
                        child: GridView.count(
                          padding: EdgeInsets.all(0),
                          crossAxisCount: 3,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          children: this._gridList,
                        ),
                      )),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30),
                    width: 120,
                    child: FlatButton(
                        onPressed: () {
                          if (_playBackEnable) {
                            _gameManager.playBack(index: _userPreviousIndex);
                            _cpuManager.playBackCPU();
                            (_gridList[_userPreviousIndex] as SignTile)
                                .setStatusWidget(SIGN.NONE);
                            (_gridList[_cpuManager.previousIndex] as SignTile)
                                .setStatusWidget(SIGN.NONE);
                            setState(() {
                              _playBackEnable = false;
                            });
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        color: _playBackEnable ? Colors.orange : Colors.grey,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              _playBackEnable
                                  ? Icon(
                                      Icons.refresh,
                                      color: Colors.white,
                                      size: 20,
                                    )
                                  : Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                              Text(
                                "戻す",
                                style: GoogleFonts.mPLUSRounded1c(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        )),
                  )
                ],
              )),
        ],
      )),
    );
  }
}

class SimpleScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
