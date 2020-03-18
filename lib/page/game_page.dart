import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:gameon33/component/sign_tile.dart';
import 'package:gameon33/manager/cpu_manager.dart';
import 'package:gameon33/manager/game_manager.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int baseLength = 3;
  List<Widget> _gridList = [];
  GameManager _gameManager;
  CPUManager _cpuManager;

  void resultDialog({String title, String msg}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(msg),
            actions: <Widget>[
              // ボタン領域
              FlatButton(
                child: Text("ホームへ"),
                onPressed: () => Navigator.of(context).pushReplacementNamed('start'),
              ),
            ],
          );
        });
  }

  bool resultCheck(result) {
    switch (result) {
      case RESULT.USER_WIN:
        print("USER_WIN");
        resultDialog(title: "WIN", msg: "勝っちゃったね...");
        return true;
      case RESULT.USER_LOSE:
        print("USER_LOSE");
        resultDialog(title: "LOSE", msg: "負けちゃったね...");
        return true;
      case RESULT.DRAW:
        print("DRAW");
        resultDialog(title: "DRAW", msg: "引き分け成功！");
        return true;
      case RESULT.NONE:
        print("NONE");
        return false;
    }
  }

  @override
  void initState() {
    for (int i = 0; i < math.pow(baseLength, 2); i++) {
      _gridList.add(SignTile(
        tileIndex: i,
        sign: SIGN.NONE,
        listener: (index) {
          // tileタップ時のListener
          _gameManager.play(index: index);
          (this._gridList[index] as SignTile).statusWidget =
              _gameManager.turnUser();
          if (resultCheck(_gameManager.result())) return;

          int playIndex = _cpuManager.play();
          (this._gridList[playIndex] as SignTile).statusWidget =
              _gameManager.turnUser();
          if (resultCheck(_gameManager.result())) return;
        },
      ));
    }
    _gameManager = GameManager.origin();
    _cpuManager = CPUManager(gameManager: _gameManager);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            constraints: BoxConstraints.expand(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                  child: Center(
                    child: Text("先攻"),
                  ),
                ),
                Container(
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    color: Color(0xff555555),
                    child: ScrollConfiguration(
                      // スクロール管理的な？
                      behavior: MyBehavior(),
                      child: GridView.count(
                        padding: EdgeInsets.all(0),
                        crossAxisCount: 3,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        children: this._gridList,
                      ),
                    ))
              ],
            )));
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
