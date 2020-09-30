import 'package:flutter/material.dart';
import 'package:heraldo_cuba_web/globals.dart';
import 'package:heraldo_cuba_web/src/theme/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import './main.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  WebViewController _controller;
  String url = '';
  String activeCategory = '';
  final categories = [
    MyCategory(
        FontAwesomeIcons.newspaper, 'inicio', 'https://heraldodecuba.com/'),
    MyCategory(FontAwesomeIcons.heart, 'cuba',
        'https://heraldodecuba.com/category/cuba/'),
    MyCategory(FontAwesomeIcons.flagUsa, 'usa',
        'https://heraldodecuba.com/category/usa/'),
    MyCategory(FontAwesomeIcons.globe, 'internacionales',
        'https://heraldodecuba.com/category/internacionales/'),
    MyCategory(FontAwesomeIcons.envelope, 'contáctenos',
        'https://heraldodecuba.com/contactenos/'),
    MyCategory(FontAwesomeIcons.moneyCheck, 'donaciones',
        'https://heraldodecuba.com/contribucion-con-el-heraldo-de-cuba/'),
  ];
  num position = 1;

  @override
  void initState() {
    super.initState();
    setState(() {
      this.activeCategory = categories[0].name;
      this.url = categories[0].url;
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {}
    if (state == AppLifecycleState.resumed) {
      RestartWidget.restartApp(myGlobals.scaffoldKey.currentContext);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _getContainerList(),
              Container(
                  height: _screenSize.height * 0.85,
                  child: IndexedStack(
                    index: position,
                    children: <Widget>[
                      WebView(
                        userAgent: new DateTime.now()
                            .microsecondsSinceEpoch
                            .toString(),
                        initialUrl: this.url,
                        javascriptMode: JavascriptMode.unrestricted,
                        onPageFinished: doneLoading,
                        onPageStarted: startLoading,
                        onWebViewCreated: (WebViewController c) {
                          _controller = c;
                        },
                      ),
                      Container(
                        color: Colors.white,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  doneLoading(String A) {
    setState(() {
      position = 0;
    });
  }

  startLoading(String A) {
    setState(() {
      position = 1;
    });
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
              this.activeCategory = categories[index].name;
              setState(() {});
            },
            child: Padding(
              padding: EdgeInsets.all(8),
              child: _getCategoryButton(categories[index]),
            ),
          );
        },
      ),
    );
  }

  _getCategoryButton(MyCategory myCategory) {
    final button = Container(
      child: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: this.activeCategory == myCategory.name
                ? myTheme.accentColor
                : Colors.white),
        child: Icon(
          myCategory.icon,
          color: this.activeCategory == myCategory.name
              ? Colors.white
              : Colors.black54,
        ),
      ),
    );

    final text = Text(
      '${myCategory.name[0].toUpperCase()}${myCategory.name.substring(1)}',
      style: TextStyle(
          fontSize: 12,
          color: this.activeCategory == myCategory.name
              ? myTheme.accentColor
              : Colors.white),
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

class MyCategory {
  final IconData icon;
  final String name;
  final String url;

  MyCategory(this.icon, this.name, this.url);
}
