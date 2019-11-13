import 'package:flutter/material.dart';
import 'package:flutter_module/constant/constants.dart';
import 'package:flutter_module/event/login_event.dart';
import 'package:flutter_module/pages/about_us_page.dart';
import 'package:flutter_module/pages/collect_list_page.dart';
import 'package:flutter_module/pages/login_page.dart';
import 'package:flutter_module/util/data_utils.dart';

class MyInfoPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MyInfoPageState();
  }
}

class MyInfoPageState extends State<MyInfoPage> with WidgetsBindingObserver{
  String userName;

  @override
  void initState() {
    super.initState();
    _getName();
    Constants.eventBus.on<LoginEvent>().listen((event){
      _getName();
    });
  }

  void _getName() async{
    DataUtils.getUserName().then((username){
      setState(() {
        userName = username;
      });
    });
  }


  @override
  Widget build(BuildContext context) {

    Widget image = Image.asset(
      'images/ic_launcher_round.png',
      width: 100.0,
      height: 100.0,
    );

    Widget raisedButton = RaisedButton(
      child: Text(
        userName == null ? "请登录" : userName,
        style:TextStyle(color: Colors.white),
      ),
      color: Theme.of(context).accentColor,
      onPressed: ()async{
        await DataUtils.isLogin().then((isLogin){
          if (!isLogin) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return LoginPage();
            }));
          } else {

          }
        });
      },
    );

    Widget listLike = ListTile(
      leading: Icon(Icons.favorite),
      title: Text("喜欢的文章"),
      trailing: Icon(Icons.chevron_right,color: Colors.blue,),
      onTap: () async {
        await DataUtils.isLogin().then((isLogin){
          if (!isLogin) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return LoginPage();
            }));
          } else {
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return CollectPage();
            }));
          }
        });
      });

      Widget listAbout = ListTile(
      leading: Icon(Icons.info),
      title: Text("关于我们"),
      trailing: Icon(Icons.chevron_right,color: Colors.blue,),
      onTap: () async {
         Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return AboutUsPage();
            }));
      });

      Widget listLogout = ListTile(
      leading: Icon(Icons.info),
      title: Text("推出登录"),
      trailing: Icon(Icons.chevron_right,color: Colors.blue,),
      onTap: () async {
        DataUtils.clearLoginInfo();
        setState(() {
          userName = null;
        });
      });

    return ListView(
      padding: const EdgeInsets.all(0),
      children: <Widget>[
        image,
        raisedButton,
        listLike,
        listAbout,
        listLogout,
      ],
    );
  }


}