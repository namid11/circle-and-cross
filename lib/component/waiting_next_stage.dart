import 'package:flutter/material.dart';

class WaitingNextStageComponent extends StatefulWidget {
  @override
  _WaitingNextStageComponentState createState() => _WaitingNextStageComponentState();
}

class _WaitingNextStageComponentState extends State<WaitingNextStageComponent> with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 150,
            height: 150,
            child: CircularProgressIndicator(
              value: 0.5,
              strokeWidth: 30,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          )
        ],
      ),
    );
  }
}
