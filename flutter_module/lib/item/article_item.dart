
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_module/http/api.dart';
import 'package:flutter_module/http/http_util.dart';
import 'package:flutter_module/pages/article_detail_page.dart';
import 'package:flutter_module/pages/login_page.dart';
import 'package:flutter_module/util/data_utils.dart';
import 'package:flutter_module/util/string_utils.dart';

class ArticleItem extends StatefulWidget{
  var itemData;
  bool isSearch;
  String id;

  ArticleItem(var itemData){
    this.itemData = itemData;
    this.isSearch = false;
  }

  ArticleItem.isFormSearch(var itemData, String id){
    this.itemData = itemData;
    this.isSearch = true;
    this.id = id;
  }

  @override
  State<StatefulWidget> createState() {
    return ArticleItemState();
  }
}

class ArticleItemState extends State<ArticleItem>{

  void _handleOnItemCollect(itemData){
    DataUtils.isLogin().then((isLogin){
      if (!isLogin) {
        _login();
      }else{
        _itemCollect(itemData);
      }
    });
  }

  _login(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return LoginPage();
    }));
  }

  void _itemClick(itemData) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context){
        return ArticleDetailPage(
          title: itemData['title'],
          url: itemData['link'],
        );
    }));
  }

  @override
  Widget build(BuildContext context) {
    bool isCollect = widget.itemData['collect'];

    Row author = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Text('作者:'),
                Text(
                  widget.itemData['author'],
                  style:TextStyle(color: Theme.of(context).accentColor),
                ),
              ],
            ),),
          Text(widget.itemData['niceDate'], 
                  style: TextStyle(color: Colors.blue),) 
        ],
    );

    Row title = Row(
        children: <Widget>[
          Expanded(
            child: Text.rich(
              widget.isSearch? StringUtils.getTextSpan(widget.itemData['title'], widget.id) :TextSpan(text: widget.itemData['title']),
              softWrap: true,
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.left,
            ),
           ),
        ],
    );

    Row chapterName = Row(
      children: <Widget>[
        Expanded(
          child: Text(
            widget.isSearch? "" : widget.itemData['chapterName'],
            softWrap: true,
            style: TextStyle(color: Colors.blue),
            textAlign: TextAlign.left,
          ),
        ),
        IconButton(
          icon: Icon(
            isCollect ? Icons.favorite : Icons.favorite_border,
            color: isCollect ? Colors.red : null,
          ),
          onPressed: (){
            _handleOnItemCollect(widget.itemData);
          },
        )
      ],
    );

    Column column = Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(10,5,10,5),
          child: author,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10,5,10,5),
          child: title,
        ),
          Padding(
          padding: EdgeInsets.fromLTRB(10,5,10,5),
          child: chapterName,
        ),
      ],
    );

    return Card(
      elevation: 10,
      child: InkWell(
        child: column,
        onTap: (){
          _itemClick(widget.itemData);
        },
      ),
    );
  }

  void _itemCollect(itemData) {
    String url;
    if (itemData['collect']) {
      url = Api.UNCOLLECT_ORIGINID;
    } else {
      url = Api.COLLECT;
    }
    url += '${itemData["id"]}/json';
    HttpUtil.post(url, (data){
      setState(() {
        itemData['collect'] = !itemData['collect'];
      });
    });
  }
}