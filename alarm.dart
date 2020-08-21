import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class AlarmPage extends StatefulWidget{
  @override
  AlarmPageState createState() => AlarmPageState();
}

class AlarmPageState extends State<AlarmPage> with AutomaticKeepAliveClientMixin<AlarmPage>{

  List<Offset> itemList = [];

  DateTime datetime;
  Timer timer;

  @override
  void initState()
  {
    super.initState();
    datetime = DateTime.now();
    timer = Timer.periodic(Duration(seconds: 1), (timer){
      datetime = DateTime.now();
      bool flag = itemList.contains(Offset(datetime.hour.toDouble(), datetime.minute.toDouble()));
      if(flag)
        /*Fluttertoast.showToast(
          msg: "alarm!",
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white
        );*/
        print(11111);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.add),
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
                      actions: <Widget>[
                        FlatButton(
                            onPressed:(){
                              if(inhour>=0&&inhour<24&&inminute>=0&&inminute<60)
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
                  Text(
                    hourStr+':'+minStr,
                    style: TextStyle(fontSize: 30.0),
                  ),
                  Spacer(),
                  FlatButton(
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