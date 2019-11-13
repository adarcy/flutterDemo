import 'package:flutter/material.dart';
import 'package:flutter_module/http/api.dart';
import 'package:flutter_module/http/http_util_with_cookie.dart';
import 'package:flutter_module/pages/article_detail_page.dart';
import 'package:flutter_module/pages/search_page.dart';

class HotPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HotPageState();
  }
}

class HotPageState extends State<HotPage>{
  List<Widget> hotKeyWidget = List();
  List<Widget> friendWidget = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getHotKey();
    _getFriend();
  }

  void _getHotKey(){
    HttpUtil.get(Api.HOTKEY, (data){
      setState(() {
        List datas = data;
        hotKeyWidget.clear();
        for (var value in datas) {
          Widget actionChip = ActionChip(
            backgroundColor: Colors.blue,
            label: Text(
              value['name'],
              style:TextStyle(color: Colors.white)
            ),
            onPressed: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                return SearchPage(value['name']);
              }));
            },
          );
          hotKeyWidget.add(actionChip);
        }
      });
    });
  }

  void _getFriend(){
    HttpUtil.get(Api.FRIEND, (data){
      setState(() {
        List datas = data;
        friendWidget.clear();
        for (var value in datas) {
          Widget actionChip = ActionChip(
            backgroundColor: Colors.blue,
            label: Text(
              value['name'],
              style:TextStyle(color: Colors.white)
            ),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return ArticleDetailPage(
                  title: value['name'],
                  url: value['link'],
                );
              }));
            },
          );
          friendWidget.add(actionChip);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            '大家都在搜',
            style: TextStyle(color: Colors.blue, fontSize: 20),
          ),
        ),

        Wrap(
          spacing: 5,
          runSpacing: 5,
          children: hotKeyWidget,
        ),

        Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            '常用网站',
            style: TextStyle(color: Colors.blue, fontSize: 20),
          ),
        ),

        Wrap(
          spacing: 5,
          runSpacing: 5,
          children: friendWidget,
        )
      ],
    );
  }
}