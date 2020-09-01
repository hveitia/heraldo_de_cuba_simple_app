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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {}
    if (state == AppLifecycleState.resumed) {
      RestartWidget.restartApp(context);
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

class RestartWidget extends StatefulWidget {
  RestartWidget({this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>().restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
