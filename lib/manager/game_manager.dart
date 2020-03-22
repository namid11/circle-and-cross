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
  bool get userIsFirst => _userIsFirst;

  GameManager(List<SIGN> field) {
    this.gameField = field;
  }

  List<bool> connectTiles;

  GameManager.origin({bool userIsFirst, int baseLength}) {
    if (userIsFirst != null) this._userIsFirst = userIsFirst;
    if (baseLength != null) this._baseLength = baseLength;
    this._gameField = List<SIGN>.filled(math.pow(_baseLength, 2).toInt(), SIGN.NONE);
    this.connectTiles = List<bool>.filled(math.pow(_baseLength, 2).toInt(), false);
  }

  SIGN turnUser() => (_gameTurn % 2 == 0) ? SIGN.CROSS : SIGN.TICK;

  void play({int index}) {
    if (_gameField[index] == SIGN.NONE) {
      _gameTurn += 1;
      _gameField[index] = turnUser();
    }
  }

  void playBack({int index}) {
    _gameField[index] = SIGN.NONE;
    _gameTurn -= 1;
  }

  RESULT result() {
    if (gameTurn < 5) return RESULT.NONE; // ５手目以上でないと決着がわからん

    for (int i = 0; i < _gameField.length; i++) {
      SIGN sign = _gameField[i];
      if (sign != SIGN.NONE) {
        bool signIsFirst = (SIGN.TICK == sign) ? true : false;
        // 縦軸チェック
        for (int j = i % baseLength; j <= math.pow(baseLength, 2); j += baseLength) {
          int targetIndex = j;
          if (sign != _gameField[targetIndex]) break;
          this.connectTiles[targetIndex] = true;
          if (j == (i % baseLength) + baseLength * (baseLength - 1))
            return !(signIsFirst ^ _userIsFirst)
                ? RESULT.USER_WIN
                : RESULT.USER_LOSE;
        }
        this.connectTiles = List<bool>.filled(math.pow(_baseLength, 2).toInt(), false);

        // 横軸チェック
        int axisIndex = i ~/ baseLength * baseLength;
        for (int j = 0; j < 3; j++) {
          int targetIndex = axisIndex + j;
          if (_gameField[targetIndex] != sign) break;
          this.connectTiles[targetIndex] = true;
          if (j == baseLength - 1)
            return !(signIsFirst ^ _userIsFirst)
                ? RESULT.USER_WIN
                : RESULT.USER_LOSE;
        }
        this.connectTiles = List<bool>.filled(math.pow(_baseLength, 2).toInt(), false);

        // 斜めチェック
        SIGN sign0_0 = _gameField[0];
        this.connectTiles[0] = true;
        if (sign0_0 == sign) {
          for (int j = 1; j < baseLength; j++) {
            int targetIndex = j + baseLength * j;
            if (sign0_0 != _gameField[targetIndex]) break;
            this.connectTiles[targetIndex] = true;
            if (j == baseLength - 1)
              return !(signIsFirst ^ _userIsFirst)
                  ? RESULT.USER_WIN
                  : RESULT.USER_LOSE;
          }
        }
        this.connectTiles = List<bool>.filled(math.pow(_baseLength, 2).toInt(), false);

        SIGN sign0_l = _gameField[baseLength - 1];
        this.connectTiles[baseLength - 1] = true;
        if (sign0_l == sign) {
          for (int j = 1; j < baseLength; j++) {
            int targetIndex = (baseLength - (j + 1)) + baseLength * j;
            if (sign0_l != _gameField[targetIndex]) break;
            this.connectTiles[targetIndex] = true;
            if (j == baseLength - 1)
              return !(signIsFirst ^ _userIsFirst)
                  ? RESULT.USER_WIN
                  : RESULT.USER_LOSE;
          }
        }
        this.connectTiles = List<bool>.filled(math.pow(_baseLength, 2).toInt(), false);
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
