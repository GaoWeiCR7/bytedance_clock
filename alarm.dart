import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AlarmPage extends StatefulWidget{
  @override
  AlarmPageState createState() => AlarmPageState();
}

class AlarmPageState extends State<AlarmPage> with AutomaticKeepAliveClientMixin<AlarmPage>{

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  List<Offset> itemList = [];

  DateTime datetime;
  Timer timer;

  bool pressed = false;

  DateTime lastTime = DateTime.now();
  DateTime curTime;

  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
        actions: <Widget>[
          FlatButton(
              onPressed: (){
                pressed = true;
                Navigator.of(context).pop();
              },
              child: Text('OK')
          )
        ],
      ),
    );
  }

  showNotification(String str) async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High,importance: Importance.Max
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, 'Alarm', '$str', platform,
        payload: '$str');
  }


  @override
  void initState()
  {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings, onSelectNotification: onSelectNotification);
    datetime = DateTime.now();
    timer = Timer.periodic(Duration(seconds: 5), (timer){
      datetime = DateTime.now();
      curTime = DateTime.now();
      bool flag = itemList.contains(Offset(datetime.hour.toDouble(), datetime.minute.toDouble()));
      if(flag)
      {
        if(lastTime.year!=curTime.year||lastTime.month!=curTime.month||lastTime.day!=curTime.day||lastTime.hour!=curTime.hour||lastTime.minute!=curTime.minute)
        {
          pressed = false;
          lastTime = curTime;
        }
        if(!pressed)
          showNotification(datetime.hour.toString().padLeft(2,'0')+':'+datetime.minute.toString().padLeft(2,'0'));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(

        //上面的任务栏，主要是一个‘+’action

        actions: [
          IconButton(
              icon: Icon(Icons.add),

              //点击‘+’action弹出对话框

              onPressed: (){
                int inhour = -1;
                int inminute = -1;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context){
                    return AlertDialog(
                      title: Text('新建'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[

                            //下面两个Row是接受用户输入的对话框
                            //hour:_______
                            //minute:_______


                            Row(
                              children: <Widget>[
                                Text('hour'),
                                SizedBox(width: 20,),
                                Container(
                                  width: 100,
                                  child:TextField(
                                    decoration: InputDecoration(
                                        labelText: '请输入hour',
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                        )
                                    ),
                                    controller: TextEditingController(),
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    maxLines: 1,
                                    maxLength: 2,
                                    maxLengthEnforced: false,
                                    onChanged: (String value){
                                      inhour = int.parse(value);
                                    },
                                    onSubmitted: (String value){
                                      inhour = int.parse(value);
                                    },
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              children: <Widget>[
                                Text('minute'),
                                SizedBox(width: 20,),
                                Container(
                                  width: 100,
                                  child:TextField(
                                    decoration: InputDecoration(
                                        labelText: '请输入minute',
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                        )
                                    ),
                                    controller: TextEditingController(),
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    maxLines: 1,
                                    maxLength: 2,
                                    maxLengthEnforced: false,
                                    onChanged: (String value){
                                      inminute = int.parse(value);
                                    },
                                    onSubmitted: (String value){
                                      inminute = int.parse(value);
                                    },
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),

                      //弹出的对话框右下角确定button，点击之后确定设置闹钟

                      actions: <Widget>[
                        FlatButton(
                            onPressed:(){
                              if(inhour>=0&&inhour<24&&inminute>=0&&inminute<60&&!itemList.contains(Offset(inhour.toDouble(),inminute.toDouble())))
                                itemList.add(Offset(inhour.toDouble(),inminute.toDouble()));
                              Navigator.of(context).pop();
                              setState(() {
                              });
                            },
                            child: Text('确定'))
                      ],
                    );
                  }
                );
              }
          )
        ],
      ),
      body: ListView.builder(
        itemBuilder:(BuildContext context, int index){
          int hour = itemList[index].dx.toInt();
          int minute = itemList[index].dy.toInt();
          String hourStr = hour.toString().padLeft(2,'0');
          String minStr = minute.toString().padLeft(2,'0');

          return Container(

            //listview组件，即每一个闹钟行的显示

              height: 60.0,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.grey,
                          width: 1.0
                      )
                  )
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  //显示闹钟时间，即每一个item左边的时间

                  Text(
                    hourStr+':'+minStr,
                    style: TextStyle(fontSize: 30.0),
                  ),
                  Spacer(),
                  FlatButton(

                    //每一个item右边的删除按钮

                    height: 40,
                    onPressed: (){
                      itemList.remove(Offset(hour.toDouble(),minute.toDouble()));
                      setState(() {

                      });
                    },
                    child: Text('删除',style: TextStyle(fontSize: 20.0),),
                    color: Colors.redAccent,
                  )
                ],
              )
          );
        },
        itemCount: itemList.length,
      ),
    );
  }
  @override
  bool get wantKeepAlive => true;

}