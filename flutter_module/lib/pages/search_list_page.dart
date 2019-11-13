import 'package:flutter/material.dart';
import 'package:flutter_module/constant/constants.dart';
import 'package:flutter_module/http/api.dart';
import 'package:flutter_module/http/http_util_with_cookie.dart';
import 'package:flutter_module/item/article_item.dart';
import 'package:flutter_module/widget/end_line.dart';

class SearchListPage extends StatefulWidget{
  String id;
    //这里为什么用含有key的这个构造,大家可以试一下不带key 直接SearchListPage(this.id) ,看看会有什么bug;
  SearchListPage(ValueKey<String> key):super(key:key){
    this.id = key.value.toString();
  }

  SearchListPageState searchListPageState;

  @override
  State<StatefulWidget> createState() {
    return SearchListPageState();
  }
}

class SearchListPageState extends State<SearchListPage>{
  int curPage = 0;
  Map<String, String> map = Map();
  List listData = List();
  int listTotalSize = 0;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener((){
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;

      if (pixels == maxScroll && listData.length < listTotalSize) {
        _articleQuery();
      }
    });
    _articleQuery();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(listData == null || listData.isEmpty){
      return Center(
        child: CircularProgressIndicator(),
      );
    }else{
      Widget listView  = ListView.builder(
        itemCount: listData.length,
        controller: _controller,
        itemBuilder: (context, i) => buildItem(i),
      );
      return RefreshIndicator(child: listView, onRefresh: pullToRefresh,);
    }
  }

  Future pullToRefresh() async {
    curPage = 0;
    _articleQuery();
    return null;
  }

  void _articleQuery() {
    String url = Api.ARTICLE_QUERY;
    url += "$curPage/json";
    map['k'] = widget.id;

    HttpUtil.post(url, (data){
      if (data != null) {
        Map<String, dynamic> map = data;
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
    },params: map);
  }

  Widget buildItem(int i) {
    var itemData = listData[i];
    if (i == listData.length - 1 && itemData.toString() == Constants.END_LINE_TAG) {
      return EndLine();
    }
    return ArticleItem.isFormSearch(itemData, widget.id);
  }

}