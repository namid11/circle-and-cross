import 'package:flutter/material.dart';
import 'package:gameon33/page/game_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      debugShowCheckedModeBanner: false,
      home: StartPage(title: 'Flutter Demo Home Page'),
      routes: {
        'start': (BuildContext context) => StartPage(),
        'game': (BuildContext context) => GamePage(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                color: Colors.blueAccent,
                onPressed: (){
                  Navigator.of(context).pushNamed("game");
                },
                child: Text("START", style: TextStyle(color: Colors.white, fontSize: 30),),)
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
