import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RulePage extends StatefulWidget {
  @override
  _RulePageState createState() => _RulePageState();
}

class _RulePageState extends State<RulePage> {
  Widget headerText({String text}) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      height: 35,
      child: Text(
        "$text",
        style: GoogleFonts.mPLUSRounded1c(
          fontWeight: FontWeight.bold,
          fontSize: 25,
          color: Color(0xff333333),
        ),
      ),
    );
  }

  Widget contextText({String text}) {
    return Container(
        child: Text(
      "$text",
      style: GoogleFonts.mPLUS1p(
        fontSize: 20,
        color: Color(0xff333333),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "ルール",
          style: GoogleFonts.mPLUSRounded1c(
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            headerText(text: "ゲーム内容"),
            contextText(
                text: "主なルールは「三目並べ」と同じです。\n"
                    "縦、横、斜めのいずれかに自分のマークを揃えれば勝利となります。\n"
                    "しかし、このゲームでは「引き分け」を目指してください。"),
            SizedBox(
              height: 20,
            ),
            headerText(text: "CPUの動作"),
            contextText(
                text: "CPUの動作は、完全ランダムではありません。\n"
                    "前に打ったマスの周りのみ動きます。"),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              margin: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Color(0xffdddddd),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child:  Image(
                        image: AssetImage("images/moving_cpu_example_1.png")),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Image(
                        image: AssetImage("images/moving_cpu_example_2.png")),
                    ),
                  )
                ],
              ),
            ),
            contextText(text: "初手及び周りに空いているマスがない場合は、ランダムになります。"),
            SizedBox(
              height: 10,
            ),
            headerText(text: "攻略法"),
            contextText(
                text: "CPUの動作をうまく誘導しましょう。\n"
                    "CPUの動作範囲を狭めることで、次の動作をある程度予測できます。\n"
                    "また、「戻る」ボタンを押すことで１手前の状態に戻すことができます。有効に使いましょう。"),
          ],
        ),
      )),
    ));
  }
}
