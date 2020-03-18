import 'package:gameon33/manager/game_manager.dart';
import 'dart:math' as math;

class CPUManager {
  GameManager gameManager;
  int previousIndex;

  CPUManager({this.gameManager});



  int play() {
    List<int> spaceField = gameManager.spaceField();
    var random = math.Random();
    if (gameManager.gameTurn < 2) {
      int ranIndex = random.nextInt(spaceField.length);
      previousIndex = spaceField[ranIndex];
      gameManager.play(index: previousIndex);

      return previousIndex;
    } else {
      if (previousIndex == null) throw NullThrownError();
      List<int> candidateIndex = [];
      // 左
      int targetIdx = previousIndex-1;
      if (previousIndex ~/ gameManager.baseLength == targetIdx ~/ gameManager.baseLength && spaceField.contains(targetIdx))
        candidateIndex.add(targetIdx);
      // 右
      targetIdx = previousIndex+1;
      if (previousIndex ~/ gameManager.baseLength == targetIdx ~/ gameManager.baseLength && spaceField.contains(targetIdx))
        candidateIndex.add(targetIdx);
      // 上
      targetIdx = previousIndex - gameManager.baseLength;
      if (targetIdx >= 0 && spaceField.contains(targetIdx))
        candidateIndex.add(targetIdx);
      // 下
      targetIdx = previousIndex+gameManager.baseLength;
      if (targetIdx < math.pow(gameManager.baseLength, 2) && spaceField.contains(targetIdx))
        candidateIndex.add(previousIndex + gameManager.baseLength);
      // 左上
      targetIdx = previousIndex-(gameManager.baseLength+1);
      if (previousIndex ~/ gameManager.baseLength == targetIdx ~/ gameManager.baseLength + 1 && spaceField.contains(targetIdx))
        candidateIndex.add(targetIdx);
      // 右上
      targetIdx = previousIndex-(gameManager.baseLength-1);
      if (previousIndex ~/ gameManager.baseLength == targetIdx ~/ gameManager.baseLength + 1 && spaceField.contains(targetIdx))
        candidateIndex.add(targetIdx);
      // 左下
      targetIdx = previousIndex+(gameManager.baseLength-1);
      if (previousIndex ~/ gameManager.baseLength == targetIdx ~/ gameManager.baseLength - 1 && spaceField.contains(targetIdx))
        candidateIndex.add(targetIdx);
      // 右下
      targetIdx = previousIndex+(gameManager.baseLength+1);
      if (previousIndex ~/ gameManager.baseLength == targetIdx ~/ gameManager.baseLength - 1 && spaceField.contains(targetIdx))
        candidateIndex.add(targetIdx);

      if (candidateIndex.length > 0) {
        int ranIndex = random.nextInt(candidateIndex.length);
        previousIndex = candidateIndex[ranIndex];
        gameManager.play(index: previousIndex);
      } else {
        int ranIndex = random.nextInt(spaceField.length);
        previousIndex = spaceField[ranIndex];
        gameManager.play(index: previousIndex);
      }

      return previousIndex;
    }
  }
}