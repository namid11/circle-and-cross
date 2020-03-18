import 'package:flutter/cupertino.dart';
import 'package:gameon33/component/sign_tile.dart';
import 'dart:math' as math;

class GameManager {
  List<SIGN> _gameField = [];
  List<SIGN> get gameField => this._gameField;
  set gameField(List<SIGN> value) {
    this._gameField = value;
  }

  int _gameTurn = 0;

  int get gameTurn => this._gameTurn;

  int _baseLength = 3;

  int get baseLength => this._baseLength;

  bool _userIsFirst = true;

  bool get UserIsFirst => _userIsFirst;

  GameManager(List<SIGN> field) {
    this.gameField = field;
  }

  GameManager.origin({bool userIsFirst, int baseLength}) {
    if (userIsFirst != null) this._userIsFirst = userIsFirst;
    if (baseLength != null) this._baseLength = baseLength;
    this._gameField =
        List<SIGN>.filled(math.pow(_baseLength, 2).toInt(), SIGN.NONE);
  }

  SIGN turnUser() => (_gameTurn % 2 == 0) ? SIGN.CROSS : SIGN.TICK;

  void play({int index}) {
    if (_gameField[index] == SIGN.NONE) {
      _gameTurn += 1;
      _gameField[index] = turnUser();
    }
  }

  RESULT result() {
    if (gameTurn < 5) return RESULT.NONE; // ５手目以上でないと決着がわからん

    for (int i = 0; i < _gameField.length; i++) {
      SIGN sign = _gameField[i];
      if (sign != SIGN.NONE) {
        bool signIsFirst = (SIGN.TICK == sign) ? true : false;
        // 縦軸チェック
        for (int j = i % baseLength;
            j <= math.pow(baseLength, 2);
            j += baseLength) {
          if (sign != _gameField[j]) break;
          if (j == (i % baseLength) + baseLength * (baseLength - 1))
            return !(signIsFirst ^ _userIsFirst)
                ? RESULT.USER_WIN
                : RESULT.USER_LOSE;
        }
        // 横軸チェック
        int axisIndex = i ~/ baseLength * baseLength;
        for (int j = 0; j < 3; j++) {
          if (_gameField[axisIndex + j] != sign) break;
          if (j == baseLength - 1)
            return !(signIsFirst ^ _userIsFirst)
                ? RESULT.USER_WIN
                : RESULT.USER_LOSE;
        }
        // 斜めチェック
        SIGN sign0_0 = _gameField[0];
        for (int j = 1; j < baseLength; j++) {
          if (sign0_0 != _gameField[j + baseLength * j]) break;
          if (j == baseLength - 1)
            return !(signIsFirst ^ _userIsFirst)
                ? RESULT.USER_WIN
                : RESULT.USER_LOSE;
        }
        SIGN sign0_l = _gameField[baseLength - 1];
        for (int j = 1; j < baseLength; j++) {
          if (sign0_l != _gameField[(baseLength - (j + 1)) + baseLength * j])
            break;
          if (j == baseLength - 1)
            return !(signIsFirst ^ _userIsFirst)
                ? RESULT.USER_WIN
                : RESULT.USER_LOSE;
        }
      }
    }

    if (gameTurn >= 9)
      return RESULT.DRAW;
    else
      return RESULT.NONE;
  }

  // 空白のマスのフィールド
  List<int> spaceField() {
    List<int> spaceField = [];
    for (int i = 0; i < this._gameField.length; i++) {
      if (this._gameField[i] == SIGN.NONE) spaceField.add(i);
    }
    return spaceField;
  }
}

enum RESULT { NONE, DRAW, USER_WIN, USER_LOSE }
