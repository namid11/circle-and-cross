import 'package:flutter/material.dart';
import 'package:gameon33/manager/game_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class DialogGameResult extends StatefulWidget {
  RESULT result;

  Widget get resultText {
    switch (result) {
      case RESULT.USER_WIN:
        return Text(
            "WIN",
            style: GoogleFonts.mPLUSRounded1c(
              fontWeight: FontWeight.w900,
              fontSize: 50,
              color: Colors.red,
            ));
      case RESULT.USER_LOSE:
        return Text(
            "LOSE",
            style: GoogleFonts.mPLUSRounded1c(
              fontWeight: FontWeight.w900,
              fontSize: 50,
              color: Colors.blue,
            ));
      case RESULT.DRAW:
        return Text(
            "DRAW",
            style: GoogleFonts.mPLUSRounded1c(
              fontWeight: FontWeight.w900,
              fontSize: 50,
              color: Colors.orange,
            ));
      default:
        return Text("NONE");
    }
  }

  DialogGameResult({this.result});

  @override
  State<StatefulWidget> createState() => DialogGameResultState();
}

class DialogGameResultState extends State<DialogGameResult>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0))),
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: widget.resultText,
            ),
          ),
        ),
      ),
    );
  }
}
