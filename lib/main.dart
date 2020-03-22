import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gameon33/page/game_page.dart';
import 'package:gameon33/page/rule_page.dart';
import 'package:gameon33/page/total_result_page.dart';
import 'package:gameon33/page/setting_page.dart';
import 'package:gameon33/page/waiting_next_stage_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DRAW',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        accentColor: Colors.white,
        primaryColor: Colors.white,
        brightness: Brightness.light
      ),
      debugShowCheckedModeBanner: false,
      home: StartPage(title: 'DRAW'),
      routes: {
        'start': (BuildContext context) => StartPage(),
        'game': (BuildContext context) => GamePage(),
        'setting': (BuildContext context) => SettingPage(),
        'waiting': (BuildContext context) => WaitingNextStagePage(),
        'result': (BuildContext context) => TotalResultPage(),
        'rule': (BuildContext context) => RulePage()
      },
    );
  }
}

class StartPage extends StatefulWidget {
  StartPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  int themeColor = Colors.redAccent.value;
  int totalDrawCount = 0;

  @override
  void initState() {
    SharedPreferences.getInstance().then((sp){
      setState(() {
        totalDrawCount = sp.getInt("total_draw_count") ?? 0;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    SharedPreferences.getInstance().then((value) {
      setState(() {
        themeColor = value.getInt("theme_color") ?? Colors.redAccent.value;
      });
    });
    super.didChangeDependencies();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: SafeArea(
          child: Container(
            constraints: BoxConstraints.expand(),
            color: Color(themeColor),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 60,
                    height: 60,
                    margin: EdgeInsets.only(top: 20, right: 20),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('setting');
                      },
                      padding: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0))),
                      color: Colors.white,
                      child: Icon(Icons.settings, color: Color(themeColor),),
                    ),
                  )
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          width: 220,
                          height: 100,
                          margin: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.orange, width: 10),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.stars, color: Colors.orange, size: 45,),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  "$totalDrawCount",
                                  style: GoogleFonts.muli(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed("game");
                            },
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                            ),
                            child: Container(
                                width: 200,
                                height: 100,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.games, color: Color(themeColor), size: 35,),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                        "ゲーム",
                                        style: GoogleFonts.mPLUSRounded1c(
                                            textStyle: TextStyle(color: Color(themeColor), fontSize: 28),
                                            fontWeight: FontWeight.w900
                                        ),
                                      ),
                                    )
                                  ],
                                )
                            )
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('rule');
                            },
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20.0))
                            ),
                            child: Container(
                                width: 200,
                                height: 100,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.local_library, color: Color(themeColor), size: 35,),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                        "ルール",
                                        style: GoogleFonts.mPLUSRounded1c(
                                            textStyle: TextStyle(color: Color(themeColor), fontSize: 28),
                                            fontWeight: FontWeight.w900
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                            )
                        ),
                      ),
                    ],
                  )
                )
              ],
            ),
          ),
        ));
  }
}
