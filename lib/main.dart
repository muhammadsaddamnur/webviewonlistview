import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WebViewController _webViewController;
  double _webViewHeight = 1;

  Future<void> _onPageFinished(BuildContext context, String url) async {
    double newHeight = double.parse(
      await _webViewController
          .evaluateJavascript("document.body.scrollHeight;"),
    );

    double newHeight2 = double.parse(
      await _webViewController
          .evaluateJavascript("document.body.offsetHeight;"),
    );
    double newHeight3 = double.parse(
      await _webViewController
          .evaluateJavascript("document.documentElement.clientHeight;"),
    );
    double newHeight4 = double.parse(
      await _webViewController
          .evaluateJavascript("document.documentElement.scrollHeight;"),
    );
    double newHeight5 = double.parse(
      await _webViewController
          .evaluateJavascript("document.documentElement.offsetHeight;"),
    );

    debugPrint('1' + newHeight.toString());
    debugPrint('2' + newHeight2.toString());
    debugPrint('3' + newHeight3.toString());
    debugPrint('4' + newHeight4.toString());
    debugPrint('5' + newHeight5.toString());

    List<double> newheightlist = [
      newHeight,
      newHeight2,
      newHeight3,
      newHeight4,
      newHeight5
    ];
    setState(() {
      _webViewHeight = newheightlist.reduce(max);
    });
  }

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(height: 100, color: Colors.green),
          Container(
            height: _webViewHeight,
            child: WebView(
              initialUrl: 'https://enterkomputer.com/',
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (String url) => _onPageFinished(context, url),
              onWebViewCreated: (controller) async {
                _webViewController = controller;
              },
            ),
          ),
          Container(height: 100, color: Colors.yellow),
        ],
      ),
    ));
  }
}

// class PlatformViewVerticalGestureRecognizer
//     extends VerticalDragGestureRecognizer {
//   PlatformViewVerticalGestureRecognizer({PointerDeviceKind kind})
//       : super(kind: kind);

//   Offset _dragDistance = Offset.zero;

//   @override
//   void addPointer(PointerEvent event) {
//     startTrackingPointer(event.pointer);
//   }

//   @override
//   void handleEvent(PointerEvent event) {
//     _dragDistance = _dragDistance + event.delta;
//     if (event is PointerMoveEvent) {
//       final double dy = _dragDistance.dy.abs();
//       final double dx = _dragDistance.dx.abs();

//       if (dy > dx && dy > kTouchSlop) {
//         // vertical drag - accept
//         resolve(GestureDisposition.accepted);
//         _dragDistance = Offset.zero;
//       } else if (dx > kTouchSlop && dx > dy) {
//         resolve(GestureDisposition.accepted);
//         // horizontal drag - stop tracking
//         stopTrackingPointer(event.pointer);
//         _dragDistance = Offset.zero;
//       }
//     }
//   }

//   @override
//   String get debugDescription => 'horizontal drag (platform view)';

//   @override
//   void didStopTrackingLastPointer(int pointer) {}
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final flutterWebViewPlugin = FlutterWebviewPlugin();
//   StreamSubscription<double> _onProgressChanged;
//   StreamSubscription<WebViewStateChanged> _onStateChanged;
//   StreamSubscription<double> _onScrollcontroller;
//   // StreamSubscription<String> _onUrlChanged;
//   double progress = 0.0;
//   String currenttitle = '';
//   String currentUrl = '';
//   String kAndroidUserAgent =
//       'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

//   double heightWebview = 10;

//   final Set<JavascriptChannel> jsChannels = [
//     JavascriptChannel(
//         name: 'Print',
//         onMessageReceived: (JavascriptMessage message) {
//           debugPrint(message.message);
//         }),
//   ].toSet();

//   @override
//   void initState() {
//     _onStateChanged = flutterWebViewPlugin.onStateChanged.listen((state) async {
//       if (state.type == WebViewState.finishLoad) {
//         String titleScript = 'window.document.title';
//         String titleUrl = 'window.document.URL';
//         var title = await flutterWebViewPlugin.evalJavascript(titleScript);
//         var curl = await flutterWebViewPlugin.evalJavascript(titleUrl);
//         var height = await flutterWebViewPlugin
//             .evalJavascript("window.document.body.scrollHeight");
//         setState(() {
//           currenttitle = title;
//           currentUrl = curl;
//           debugPrint('wkwkwkwk $height');
//           heightWebview = double.parse(height);
//           debugPrint('wwwwwwwwwwwwwwwwwwwwwwww $heightWebview');
//         });
//       }
//     });

//     _onScrollcontroller =
//         flutterWebViewPlugin.onScrollYChanged.listen((double offsetY) {
//       debugPrint(offsetY.toString());
//     });

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _onProgressChanged.cancel();
//     _onStateChanged.cancel();
//     _onScrollcontroller.cancel();
//     flutterWebViewPlugin.dispose();
//     flutterWebViewPlugin.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(currenttitle.toString()),
//         ),
//         body: ListView(
//           shrinkWrap: true,
//           children: [
//             SizedBox(
//               height: heightWebview,
//               child: WebviewScaffold(
//                   appBar: AppBar(
//                     title: Text(currenttitle.toString()),
//                   ),
//                   url: 'https://enterkomputer.com/',
//                   mediaPlaybackRequiresUserGesture: false,
//                   javascriptChannels: jsChannels,
//                   userAgent: kAndroidUserAgent,
//                   withZoom: true,
//                   withLocalStorage: true,
//                   scrollBar: true,
//                   hidden: true,
//                   ignoreSSLErrors: true,
//                   // appCacheEnabled: true,
//                   initialChild: Container(
//                     color: Colors.white,
//                     child: Center(child: CircularProgressIndicator()),
//                   )),
//             ),
//             Text('kkkkkkkkkkkkkkkkkkkkkkkk')
//           ],
//         ));
//   }
// }
