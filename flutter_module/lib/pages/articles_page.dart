
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_module/pages/article_list_page.dart';

class ArticlesPage extends StatefulWidget{

  final data;

  ArticlesPage(this.data);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    print("data");
    return ArticlesPageState();
  }

}

class ArticlesPageState extends State<ArticlesPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  List<Tab> tabs = List();
  List<dynamic> list;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list = widget.data['children'];

    for (var value in list) {
      tabs.add(Tab(text: value['name']));
    }    

    _tabController = TabController(length: list.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    print("data");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data['name']),
      ),
      body: DefaultTabController(
        length: list.length,
        child: Scaffold(
          appBar: TabBar(
            isScrollable: true,
            controller: _tabController,
            labelColor: Theme.of(context).accentColor,
            unselectedLabelColor: Colors.black,
            indicatorColor: Theme.of(context).accentColor,
            tabs: tabs,
          ),
          body: TabBarView(
            controller: _tabController,
            children: list.map((dynamic itemData){
              return ArticleListPage(itemData['id'].toString());
            }).toList(),
          ),
        ),
      ),);
  }
}