import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(MyApp());
}

bool isAllMentsu(List<int> hai) {
  for (int i = 0; i < hai.length; i++) {
    if (hai[i] >= 3) {  // コーツ
      hai[i] -= 3;
      return isAllMentsu(hai);
    } else if (hai[i] > 0 && i < hai.length - 2) {  // シュンツ
      if (hai[i + 1] == 0 || hai[i + 2] == 0) {
        return false;
      }
      hai[i] -= 1;
      hai[i + 1] -= 1;
      hai[i + 2] -= 1;
      return isAllMentsu(hai);
    }
  }
  return hai.every((c) => c == 0);
}

bool isAgari(List<int> hai) {
  if (hai.every((c) => c == 0 || c == 2)) {  // チートイツ
    return true;
  }
  for (int i = 0; i < hai.length; i++) {
    if (hai[i] >= 2) {
      List<int> haiCopy = [...hai];
      haiCopy[i] -= 2;
      if (isAllMentsu(haiCopy)) {
        return true;
      }
    }
  }
  return false;
}

List<int> calcMachi(List<int> hai) {
  List<int> haiCount = List<int>.generate(9, (i) => 0);
  hai.forEach((e) { haiCount[e - 1] += 1; });

  List<int> machi = [];
  for (int i = 0; i < haiCount.length; i++) {
    if (haiCount[i] < 4) {
      List<int> haiCopy = [...haiCount];
      haiCopy[i] += 1;
      if (isAgari(haiCopy)) {
        machi.add(i + 1);
      }
    }
  }
  return machi;
}

List<int> generateTehai() {
  bool hasAgari = false;
  List<int> tehai = [];
  while (!hasAgari) {
    var candidates = [1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8, 8, 9, 9, 9, 9];
    candidates.shuffle();
    tehai = candidates.sublist(0, 13);
    tehai.sort();
    hasAgari = calcMachi(tehai).isNotEmpty;
  }
  return tehai;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: '清一色多面待ち'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> _tehai = generateTehai();
  List<bool> _buttonPressed = List<bool>.generate(9, (i) => false);

  void _changeTehai() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _tehai = generateTehai();
      _buttonPressed = List<bool>.generate(9, (i) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text('何待ちでしょう？'),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _tehai.map((e) => Image(image: AssetImage("images/p_ms${e}_1.gif"))).toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<int>.generate(9, (i) => i + 1).map((e) =>
                  GestureDetector(
                    onTap: () {
                      setState((){_buttonPressed[e - 1] = !_buttonPressed[e - 1];});
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(_buttonPressed[e - 1] ? 1 : 0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image(image: AssetImage("images/p_ms${e}_1.gif")),
                    ),
                  ),
              ).toList(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: ElevatedButton(
                child: const Text('解答する'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  List<int> machi = calcMachi(_tehai);
                  bool isCorrect = List<int>.generate(9, (i) => i).every((e) => _buttonPressed[e] == machi.contains(e + 1));
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Center(child: Text(
                            isCorrect ? "正解" : "不正解",
                            style: TextStyle(
                              color: isCorrect ? Colors.green : Colors.red,
                            ),
                        )),
                        content: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _tehai.map((e) => Image(image: AssetImage("images/p_ms${e}_1.gif"))).toList(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("正解は"),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: machi.map((e) => Image(image: AssetImage("images/p_ms${e}_1.gif"))).toList(),
                                  )
                                ),
                                Text("待ち"),
                              ],
                            ),
                            ElevatedButton(
                              child: const Text('次の問題へ'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                _changeTehai();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
