import 'package:flutter/material.dart';
import 'package:flutter_module/constant/constants.dart';
import 'package:flutter_module/http/api.dart';
import 'package:flutter_module/http/http_util.dart';
import 'package:flutter_module/item/article_item.dart';
import 'package:flutter_module/widget/end_line.dart';

class ArticleListPage extends StatefulWidget{
  final String id;
  ArticleListPage(this.id);
  @override
  State<StatefulWidget> createState() {
    return ArticleListPageState();
  }
}

class ArticleListPageState extends State<ArticleListPage> with AutomaticKeepAliveClientMixin{
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  int curPage = 0;
  Map<String,String> map = Map();
  List listData = List();
  int listTotalSize  = 0;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getArticleList();

    _controller.addListener((){
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      if (maxScroll == pixels && listData.length < listTotalSize) {
        _getArticleList();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _getArticleList() {
    String url = Api.ARTICLE_LIST;
    url += "$curPage/json";
    map['cid'] = widget.id;
    HttpUtil.get(url, (data){
      if (data != null) {
        Map<String, dynamic> map = data;
        print(data);
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

  @override
  Widget build(BuildContext context) {
    if (listData == null || listData.isEmpty) {
      return Center(child: CircularProgressIndicator(),);
    }else{
      Widget listView = ListView.builder(
        key: PageStorageKey(widget.id),
        controller: _controller,
        itemCount: listData.length,
        itemBuilder: (context, i) => buildItem(i),
      );
      return RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
    }
  }

  buildItem(int i) {
    var item = listData[i];
    if (i == listData.length - 1 && item.toString() == Constants.END_LINE_TAG) {
      return EndLine();
    }
    return ArticleItem(item);
  }

  Future<Null> _pullToRefresh() async{
    curPage = 0;
    _getArticleList();
    return null;
  }

}