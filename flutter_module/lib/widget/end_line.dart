
import 'package:flutter/material.dart';

class EndLine extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: const Color(0xffeeeeee),
      padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Divider(height: 5,),
            flex: 1,
          ),
          Text("我是有底线的", style:TextStyle(color: Colors.blue)),
          Expanded(
            child: Divider(height: 5,),
            flex: 1,
          )
        ],
      ),
    );
  }
}