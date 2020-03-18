import 'dart:math';
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

  set statusWidget(value) {
    _signTileState.statusWidget = value;
  }

  @override
  _SignTileState createState() => _signTileState;
}

class _SignTileState extends State<SignTile> {
  Widget get statusWidget {
    switch (widget.sign) {
      case SIGN.NONE:
        return tileWeight(icon: null,);
      case SIGN.CROSS:
        return tileWeight(icon: Icons.close, color: Colors.blueAccent);
      case SIGN.TICK:
        return tileWeight(icon: Icons.panorama_fish_eye, color: Colors.redAccent);
      default:
        return Container();
    }
  }
  set statusWidget(value) {
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
      });
    }
  }

  Widget tileWeight({IconData icon, Color color}) {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(color: Colors.white
//            border: Border.all(color: Color(0xff444444), width: 2),
          ),
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
        child: statusWidget);
  }
}

enum SIGN { TICK, CROSS, NONE }
