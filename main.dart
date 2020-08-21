import 'package:hello_flutter/clock.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/alarm.dart';
import 'package:hello_flutter/stopwatch.dart';

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
  List<NavigationIconView> _navigationViews;

  @override
  // ignore: must_call_super
  void initState()
  {
    super.initState();
    _pageController = new PageController(
        initialPage: _currentIndex,
        keepPage: true,
    );
    _pages = [
      Center(
        child: ClockPage(),
      ),
      Center(
        child: AlarmPage(),
      ),
      Center(
        child: StopWatchPage(),
      ),
      Container(color: Colors.green,),
    ];
    _navigationViews = [
      NavigationIconView(
        title: "时钟",
        icon: Icon(Icons.ac_unit),
        activeIcon: Icon(Icons.access_alarm),
      ),
      NavigationIconView(
        title: "闹钟",
        icon: Icon(Icons.ac_unit),
        activeIcon: Icon(Icons.access_alarm),
      ),
      NavigationIconView(
        title: "秒表",
        icon: Icon(Icons.ac_unit),
        activeIcon: Icon(Icons.access_alarm),
      ),
      NavigationIconView(
        title: "计时器",
        icon: Icon(Icons.ac_unit),
        activeIcon: Icon(Icons.access_alarm),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar botNavBar = BottomNavigationBar(
      items: _navigationViews.map((NavigationIconView view){return view.item;}).toList(),
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      unselectedItemColor: Colors.black,
      selectedItemColor: Colors.blue,
      onTap: (int index){
        setState(() {
          _currentIndex = index;
          _pageController.animateToPage(_currentIndex, duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
        });
      },
    );
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
          onPageChanged: (int index){
              setState(() {
                _currentIndex = index;
              });
          },
        ),
      bottomNavigationBar: botNavBar,
    );
  }
}

class NavigationIconView{
  final String _title;
  final Widget _icon;
  final Widget _activeIcon;
  final BottomNavigationBarItem item;

  NavigationIconView({Key key, String title, Widget icon, Widget activeIcon}) :
        _title= title,
        _icon = icon,
        _activeIcon = activeIcon,
        item = BottomNavigationBarItem(
          icon: icon,
          activeIcon: activeIcon,
          title: Text(title),
  );
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
