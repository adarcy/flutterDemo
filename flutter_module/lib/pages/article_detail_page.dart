import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class ArticleDetailPage extends StatefulWidget{
  final String title;
  String url;

  ArticleDetailPage({
    Key key,
    @required this.title,
    @required this.url,
  }): super(key:key);

  @override
  State<StatefulWidget> createState() {
    return ArticleDetailPageState();
  }
}

class ArticleDetailPageState extends State<ArticleDetailPage>{

  final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.onDestroy.listen((_){
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.url.startsWith("http:")) {
      widget.url = widget.url.replaceFirst("http:", "https:");
    }
    return WebviewScaffold(
      url: widget.url,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      withZoom: false,
      withLocalStorage: true,
      withJavascript: true,
    );
  }
}