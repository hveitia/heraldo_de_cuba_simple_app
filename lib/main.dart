import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:heraldo_cuba_web/src/theme/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: myTheme,
      home: MyHomePage(title: 'Heraldo de Cuba'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WebViewController _controller;
  String url = '';
  final categories = [
    MyCategory(
        FontAwesomeIcons.newspaper, 'home', 'https://heraldodecuba.com/'),
    MyCategory(FontAwesomeIcons.heart, 'cuba',
        'https://heraldodecuba.com/category/cuba/'),
    MyCategory(FontAwesomeIcons.flagUsa, 'usa',
        'https://heraldodecuba.com/category/usa/'),
    MyCategory(FontAwesomeIcons.globe, 'internacionales',
        'https://heraldodecuba.com/category/internacionales/'),
    MyCategory(FontAwesomeIcons.globe, 'contáctenos',
        'https://heraldodecuba.com/contactenos/'),
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      this.url = categories[0].url;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _getContainerList(),
            Container(
                height: _screenSize.height * 0.78,
                child: WebView(
                  initialUrl: this.url,
                  javaScriptMode: JavaScriptMode.unrestricted,
                  onWebViewCreated: (WebViewController c) {
                    _controller = c;
                  },
                )),
          ],
        ),
      ),
    );
  }

  _getContainerList() {
    return Container(
      width: double.infinity,
      height: 80,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () async {
              this.url = categories[index].url;
              await _controller.loadUrl(this.url);
            },
            child: Padding(
              padding: EdgeInsets.all(8),
              child: _CategoyButton(categories[index]),
            ),
          );
        },
      ),
    );
  }
}

class MyCategory {
  final IconData icon;
  final String name;
  final String url;

  MyCategory(this.icon, this.name, this.url);
}

class _CategoyButton extends StatelessWidget {
  final MyCategory myCategory;

  const _CategoyButton(this.myCategory);

  @override
  Widget build(BuildContext context) {
    final button = Container(
      child: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: true ? myTheme.accentColor : Colors.white),
        child: Icon(
          myCategory.icon,
          color: true ? Colors.white : Colors.black54,
        ),
      ),
    );

    final text = Text(
      '${this.myCategory.name[0].toUpperCase()}${this.myCategory.name.substring(1)}',
      style: TextStyle(
          fontSize: 12, color: true ? myTheme.accentColor : Colors.white),
    );

    return Column(
      children: <Widget>[
        button,
        SizedBox(
          height: 5,
        ),
        text
      ],
    );
  }
}
