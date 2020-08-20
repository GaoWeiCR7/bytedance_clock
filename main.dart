import 'package:hello_flutter/clock.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        canvasColor: Colors.black,
      ),
      home: MyHomePage(title: 'Clock'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  PageController _pageController;
  List<Widget> _pages;

  @override
  // ignore: must_call_super
  void initState()
  {
    super.initState();
    _pageController = new PageController(initialPage: _currentIndex);
    _pages = [
      Center(
        child: ClockPage(),
      ),
      Container(color: Colors.red,),
      Container(color: Colors.blue,),
    ];

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Clock"),
        ),
        body: PageView.builder(
            // ignore: missing_return
            itemBuilder: (BuildContext context,int index){
              return _pages[index];
            },
          controller: _pageController,
          itemCount: _pages.length,
        ),
    );
  }
}

/*
body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            verticalDirection: VerticalDirection.up,
            children: <Widget>[
              new ButtonBar(
                children: <Widget>[
                  new FlatButton(onPressed: () {}, child: new Text('闹钟'),textColor: Colors.white,minWidth: 100,height: 60,),
                  Spacer(),
                  new FlatButton(onPressed: () {}, child: new Text('秒表'),textColor: Colors.white,minWidth: 100,height: 60,),
                  Spacer(),
                  new FlatButton(onPressed: () {}, child: new Text('计时器'),textColor: Colors.white,minWidth: 100,height: 60,),
                ],
                alignment: MainAxisAlignment.center,
              ),
              SizedBox(height: 50,),
              Center(
                  child: ClockPage(),
              ),
        ]
          )
        )
 */
