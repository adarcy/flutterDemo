import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_module/constant/constants.dart';
import 'package:flutter_module/http/api.dart';
import 'package:flutter_module/http/http_util.dart';
import 'package:flutter_module/item/article_item.dart';
import 'package:flutter_module/widget/slide_view.dart';

class HomeListPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HomeListPageState();
  }
}

class HomeListPageState extends State<HomeListPage>{

  List listData = List();
  var bannerData;
  var curPage = 0;
  var listTotalSize = 0;

  ScrollController _controller = ScrollController();
  TextStyle titleTextStyle = TextStyle(fontSize: 15.0);
  TextStyle subtitleTextStyle = TextStyle(color: Colors.blue, fontSize: 12.0);

  HomeListPageState(){
    _controller.addListener(() {

    });
  }

  @override
  void initState() {
    super.initState();
    getBanner();
    getHomeArticleList();
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    if (listData == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }else{
      Widget listView = ListView.builder(
        itemCount: listData.length + 1,
        itemBuilder: (context,i) => buildItem(i),
        controller: _controller,
      );
      return RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
    }
  }

  Future<Null> _pullToRefresh() async{
    curPage = 0;
    getBanner();
    getHomeArticleList();
    return null;
  }

  SlideView _bannerView;

  void getBanner() {
    String bannerUrl = Api.BANNER;
    HttpUtil.get(bannerUrl,(data){
      if(data != null){
        print("success");
        setState(() {
          bannerData = data;
          _bannerView = SlideView(bannerData);
        });
      }else{
        print("fail");
      }
    });
  }

  void getHomeArticleList() {
    String url = Api.ARTICLE_LIST;
    url += "$curPage/json";

    HttpUtil.get(url, (data){
      if (data != null) {
        Map<String,dynamic> map = data;
        var _listData = map['datas'];
        listTotalSize = map['total'];

        setState(() {
          List list1 = List();
          if (curPage == 0) {
            listData.clear();
          }
          curPage++;
          list1.addAll(listData);
          list1.addAll(_listData);
          if (list1.length >= listTotalSize) {
            list1.add(Constants.END_LINE_TAG);
          }
          listData = list1;
        });
      }
    });
  }

  Widget buildItem(int i){
    if (i == 0) {
      return Container(
        height: 180,
        child: _bannerView,
      );
    }
    i -=1;
    var itemData = listData[i];
    if (itemData is String && itemData == Constants.END_LINE_TAG) {
      // return Endline(); 
    }

    return ArticleItem(itemData);
  }
}

