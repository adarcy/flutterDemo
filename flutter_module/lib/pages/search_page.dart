import 'package:flutter/material.dart';
import 'package:flutter_module/pages/search_list_page.dart';

import 'hot_page.dart';

class SearchPage extends StatefulWidget{
  String searchStr;

  SearchPage(this.searchStr);

  @override
  State<StatefulWidget> createState() {

    return SearchPageState(searchStr);
  }
}

class SearchPageState extends State<SearchPage>{
  TextEditingController _searchController = TextEditingController();
  SearchListPage _searchListPage;
  String searchStr;

  SearchPageState(this.searchStr);

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: searchStr);
    changeContent();
  }

  void changeContent(){
    setState(() {
      _searchListPage = SearchListPage(ValueKey(_searchController.text));
    });
  }


  @override
  Widget build(BuildContext context) {
    TextField searchFied  = TextField(
      autofocus: true,
      textInputAction: TextInputAction.search,
      onSubmitted: (string){

      },
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: "搜索关键词",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white),
      ),
      controller: _searchController,
    );
    return Scaffold(
      appBar: AppBar(
        title: searchFied,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              changeContent();
            },
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: (){
              _searchController.clear();
            },
          )
        ],
      ),
      body: (_searchController.text == null || _searchController.text.isEmpty)? 
        Center(
          child: HotPage(),
        )
        : _searchListPage,
    );
  }
}