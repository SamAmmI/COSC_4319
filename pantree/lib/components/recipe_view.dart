import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RecipeView extends StatefulWidget {

  final String? postUrl;
  RecipeView({this.postUrl});

  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {

  String? finalUrl;
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  void initState() {
    
    if(widget.postUrl!.contains("http://")){
      finalUrl = widget.postUrl!.replaceAll("http://", "https://");
    }else{
      finalUrl = widget.postUrl!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 30, right: 24, left: 24, bottom: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 33, 80, 45),
                  Color.fromARGB(255, 18, 63, 42),
                ]
              )
            ),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: kIsWeb ? MainAxisAlignment.start : MainAxisAlignment.center,
                children: <Widget>[
                  Text("Pantree ", style: TextStyle(
                   fontSize: 18,
                   fontWeight: FontWeight.w500,
                   color: Colors.white
                  )),
                  Text("Recipes Search",
                    style: TextStyle(
                      color: Color.fromARGB(255, 20, 155, 15),
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                      ),)
                    ],
                  ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 100,
            width: MediaQuery.of(context).size.width,
            child: WebView(
              initialUrl: finalUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController){
                setState(() {
                  _controller.complete(webViewController);
                });
              }
            ),
          )
        ],
      ),
    ));
  }
}