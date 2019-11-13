
import 'package:flutter/material.dart';
import 'package:flutter_module/http/api.dart';
import 'package:flutter_module/http/http_util.dart';
import 'package:flutter_module/pages/articles_page.dart';

class TreePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TreePageState();
  }
}

class TreePageState extends State<TreePage>{

  var listData;

  @override
  void initState() {
    super.initState();
    getTree();
  }

  @override
  Widget build(BuildContext context) {
    if (listData == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }else{
      Widget listView = ListView.builder(
        itemCount: listData.length,
        itemBuilder: (context,i) => buildItem(i),
      );
      return listView;
    }
  }

  void getTree() {
    HttpUtil.get(Api.TREE, (data){
      setState(() {
        listData = data;
      });
    });
  }

  Widget buildItem(int i) {
    var item = listData[i];

    Text name = Text(
      item['name'],
      softWrap: true,
      style: TextStyle(
        fontSize: 15,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.left,
    );

    List list = item["children"];
    String strContent = "";
    for (var i = 0; i < list.length; i++) {
      strContent += '${list[i]["name"]}    ';
    }

    Text content = Text(
        strContent,
        style: TextStyle(fontSize: 12),
    ) ;

    return Card(
      elevation: 4,
      child: InkWell(
        onTap: (){
          _handOnItemClick(item);
        },
        child: Container(
          padding: EdgeInsets.all(15),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 8),
                      child: name,
                    ),
                    content,
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handOnItemClick(item){
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return ArticlesPage(item);
    }));
  }

}