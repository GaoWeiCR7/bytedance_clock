import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

class StopWatchPage extends StatefulWidget{
  @override
  StopWatchPageState createState() => StopWatchPageState();
}

class StopWatchPageState extends State<StopWatchPage> with AutomaticKeepAliveClientMixin<StopWatchPage>{
  Stopwatch stopwatch = new Stopwatch();
  Timer timer;

  String time = '00:00:00';

  setTime(Timer timer){
    setState(() {
      int h = (stopwatch.elapsedMilliseconds/10).truncate();
      int s = (h/100).truncate();
      int m = (s/60).truncate();

      String hStr = (h%100).toString().padLeft(2,'0');
      String sStr = (s%60).toString().padLeft(2,'0');
      String mStr = (m%60).toString().padLeft(2,'0');
      time = '$mStr:$sStr:$hStr';
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: new Column(
        children: <Widget>[
          SizedBox(height: 100,),
          new Text(time,style: TextStyle(fontSize: 60.0,color: Colors.white,),),
          SizedBox(height: 50.0,),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: (){
                  stopwatch.start();
                  timer = new Timer.periodic(new Duration(milliseconds: 10), setTime);
                  },
                child: new Icon(Icons.play_arrow),
              ),
              SizedBox(width: 30.0,),
              new FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: (){
                  stopwatch.stop();
                  setTime(timer);
                },
                child: new Icon(Icons.stop),
              ),
              SizedBox(width: 30.0,),
              new FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: (){
                  stopwatch.stop();
                  stopwatch.reset();
                  setTime(timer);
                },
                child: new Icon(Icons.refresh),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}