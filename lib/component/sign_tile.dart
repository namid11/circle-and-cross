import 'dart:math' as math;
import 'package:flutter/material.dart';

typedef void TileListener(int);

class SignTile extends StatefulWidget {
  int tileIndex;
  SIGN sign = SIGN.NONE;
  TileListener listener;
  _SignTileState _signTileState = _SignTileState();

  SignTile({this.tileIndex, this.sign, this.listener});

  SignTile.origin({this.listener}) {
    this.sign = SIGN.NONE;

  }

  void setStatusWidget(dynamic value, {bool previousFlag}) {
    _signTileState.setStatusWidget(value, previousFlag: previousFlag);
  }

  void previousMark({bool flag}) => _signTileState.previousMark(flag: flag);

  void disappear() => _signTileState.disappear();

  void effect() => _signTileState.effect();

  void drawEffect() => _signTileState.drawEffect();

  @override
  _SignTileState createState() => _signTileState;
}



class _SignTileState extends State<SignTile> {

  EdgeInsetsGeometry aniPadding = EdgeInsets.all(100);
  Duration aniDuration = Duration(milliseconds: 200);
  Curve aniCurve = Curves.bounceOut;
  Matrix4 aniTransform = Matrix4.rotationX(0)..setTranslationRaw(0, 0, 0);
  Color aniColor = Colors.white;

  Widget get statusWidget {
    setState(() {
      aniPadding = EdgeInsets.all(10);
    });
    switch (widget.sign) {
      case SIGN.NONE:
        return tileWeight(icon: null,);
      case SIGN.CROSS:
        return tileWeight(icon: Icons.close, color: Colors.blueAccent);
      case SIGN.TICK:
        return tileWeight(icon: Icons.panorama_fish_eye, color: Colors.redAccent);
      case SIGN.DRAW:
        return tileWeight(icon: Icons.thumb_up, color: Colors.orangeAccent);
      default:
        return Container();
    }
  }
  void setStatusWidget(dynamic value, {bool previousFlag}) {
    previousMark(flag: previousFlag);

    if (value is int) {
      switch (value) {
        case 0:
          setState(() {
            widget.sign = SIGN.NONE;
          });
          break;
        case 1:
          setState(() {
            widget.sign = SIGN.CROSS;
          });
          break;
        case 2:
          setState(() {
            widget.sign = SIGN.TICK;
          });
          break;
      }
    } else if (value is SIGN) {
      setState(() {
        widget.sign = value;
        if (value == SIGN.NONE) {
          aniPadding = EdgeInsets.all(100);
        }
      });
    }
  }

  void disappear() {
    setState(() {
      aniDuration = Duration(milliseconds: 300);
      aniPadding = EdgeInsets.all(100);
      aniCurve = Curves.easeIn;
    });
  }

  void previousMark({bool flag}) {
    if (flag == null) flag = false;
    setState(() {
      aniDuration = Duration(milliseconds: 200);
      aniColor = flag ? Color(0xffFED1B2): Colors.white;
    });
  }

  void effect() {
    setState(() {});
  }

  void drawEffect() {
    setState(() {
      aniDuration = Duration(milliseconds: 300);
      aniPadding = EdgeInsets.all(20);
      aniCurve = Curves.easeIn;
      setStatusWidget(SIGN.DRAW);
    });
  }

  Widget tileWeight({IconData icon, Color color}) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: Icon(icon, color: color,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: () {
          widget.listener(widget.tileIndex);
        },
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        child: AnimatedContainer(
          duration: aniDuration,
          padding: aniPadding,
          curve: aniCurve,
          color: aniColor,
          transform: aniTransform,
          child: statusWidget,));
  }
}

enum SIGN { TICK, CROSS, NONE, DRAW }
