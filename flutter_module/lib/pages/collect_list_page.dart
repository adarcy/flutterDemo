import 'package:flutter/material.dart';
import 'package:flutter_module/constant/constants.dart';
import 'package:flutter_module/http/api.dart';
import 'package:flutter_module/http/http_util.dart';
import 'package:flutter_module/item/article_item.dart';
import 'package:flutter_module/widget/end_line.dart';

//收藏文章界面
class CollectPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("喜欢的文章"),
      ),
      body: CollectListPage(),
    );
  }
}
class CollectListPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return CollectListPageState();
  }
}

class CollectListPageState extends State<CollectListPage>{
  int curPage = 0;
  Map<String, String> map = Map();
  List listData = List();
  int listTotalSize = 0;
  ScrollController _contraller = ScrollController();

  CollectListPageState();
@override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _contraller.dispose();
    super.dispose();
  }

@override
  Widget build(BuildContext context) {
    if (listData == null || listData.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      Widget listView = ListView.builder(
        //
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: listData.length,
        itemBuilder: (context, i) => buildItem(i),
        controller: _contraller,
      );

      return RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
    }
  }

  Future _pullToRefresh() async {
    curPage = 0;
    _getCollectList();
    return null;
  }

  void _getCollectList() {
    String url = Api.COLLECT_LIST;
    url += "$curPage/json";

    HttpUtil.get(url, (data) {
      if (data != null) {
        Map<String, dynamic> map = data;

        var _listData = map['datas'];

        listTotalSize = map["total"];

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
    }, params: map);
  }

  Widget buildItem(int i){
    var itemData = listData[i];
    if (listData.length - 1 == i && itemData.toString() == Constants.END_LINE_TAG)  {
      return EndLine();
    }
    return ArticleItem(itemData);
  }
}