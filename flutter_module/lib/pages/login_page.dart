import 'package:flutter/material.dart';
import 'package:flutter_module/constant/constants.dart';
import 'package:flutter_module/event/login_event.dart';
import 'package:flutter_module/http/api.dart';
import 'package:flutter_module/http/http_util_with_cookie.dart';
import 'package:flutter_module/util/data_utils.dart';

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage>{

  TextEditingController _nameController = TextEditingController(text: 'canhuah');
  TextEditingController _passwordController = TextEditingController(text: 'a123456');
  GlobalKey<ScaffoldState> scaffoldKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scaffoldKey = GlobalKey<ScaffoldState>();
  }

  @override
  Widget build(BuildContext context) {

    Icon avatar = Icon(Icons.account_circle, color:Colors.blue,size: 80,);

    TextField name = TextField(
      autofocus: true,
      controller: _nameController,
      decoration: InputDecoration(
        labelText: "用户名"
      ),
    );

    TextField password = TextField(
      obscureText: true,
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: "密码"
      ),
    );

    Row loginAndRegister = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        RaisedButton(
          child: Text('登录', style: TextStyle(color: Colors.white),),
          color: Colors.blue,
          onPressed: (){
            _login();
          },
        ),
        RaisedButton(
          child: Text('注册', style: TextStyle(color: Colors.white),),
          color: Colors.blue,
          onPressed: (){
            _register();
          },
        )
      ],
    );

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('登录'),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(40, 10, 40, 0),
        child: ListView(
        children: <Widget>[
          avatar,
          name,
          password,
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: loginAndRegister,
          )
        ],
      ),
        )
    );
  }

  void _login(){
    String name  = _nameController.text;
    String password = _passwordController.text;

    if (name.length == 0) {
      _showMessage("请先输入姓名");
      return;
    }
     if (password.length == 0) {
      _showMessage('请先输入密码');
      return;
    }
    Map<String,String> map = Map();
    map['username'] = name;
    map['password'] = password;

    HttpUtil.post(Api.LOGIN, (data) async {
        DataUtils.saveLoginInfo(name).then((r){
          Constants.eventBus.fire(LoginEvent());
          Navigator.of(context).pop();
        });
      },
      params: map,
      errorCallback: (msg){
        _showMessage(msg);
      });
  }

  void _register(){
    String name  = _nameController.text;
    String password = _passwordController.text;

    if (name.length == 0) {
      _showMessage("请先输入姓名");
      return;
    }
     if (password.length == 0) {
      _showMessage('请先输入密码');
      return;
    }
    Map<String,String> map = Map();
    map['username'] = name;
    map['password'] = password;
    map['repassword'] = password;

    HttpUtil.post(Api.REGISTER, (data) async {
        DataUtils.saveLoginInfo(name).then((r){
          Constants.eventBus.fire(LoginEvent());
          Navigator.of(context).pop();
        });
      },
      params: map,
      errorCallback: (msg){
        _showMessage(msg);
      });
  }

  void _showMessage(String msg){
    var snackBar = SnackBar(content: Text(msg));
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

}