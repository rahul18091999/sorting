import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  List<int> _numbers = [];
  int sampleSize = 500;
  double value = 500.0;
  bool f = false, isSorting = false;
  String dropdownValue = 'Bubble Sort';
  int m = -1, n = -1;
  _randomize() {
    _numbers = [];
    for (int i = 0; i < sampleSize; i++) {
      _numbers.add(Random().nextInt(400));
    }
    setState(() {
      f = true;
      isSorting = false;
      m = -1;
      n = -1;
    });
  }

  _bubbleSort() async {
    setState(() {
      f = false;
    });
    if (isSorting == false) {
      setState(() {
        isSorting = true;
      });
      for (int i = 0; i < _numbers.length && f == false; i++) {
        for (int j = 0; j < _numbers.length - 1 - i && f == false; j++) {
          setState(() {
            m = j;
            n = j + 1;
          });
          if (_numbers[j] > _numbers[j + 1] && f == false) {
            int temp = _numbers[j];
            _numbers[j] = _numbers[j + 1];
            _numbers[j + 1] = temp;
          }
          await Future.delayed(Duration(microseconds: 20000));
          setState(() {});
        }
      }

      setState(() {
        isSorting = false;
        m = -1;
        n = -1;
      });
    }
  }

  _selectionSort() async {
    print("Hello");
    setState(() {
      f = false;
    });
    if (isSorting == false) {
      setState(() {
        isSorting = true;
      });

      int minIdx, j;

      for (int i = 0; i < _numbers.length - 1 && f == false; i++) {
        print(i);
        minIdx = i;
        for (j = i + 1; j < _numbers.length && f == false; j++) {
          if (_numbers[j] < _numbers[minIdx]) minIdx = j;
        }
        setState(() {
          m = i;
          n = minIdx;
        });
        await Future.delayed(Duration(microseconds: 800000));
        setState(() {});

        int temp = _numbers[minIdx];
        _numbers[minIdx] = _numbers[i];
        _numbers[i] = temp;
      }

      setState(() {
        isSorting = false;
        m = -1;
        n = -1;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _randomize();
  }

  @override
  Widget build(BuildContext context) {
    double counter = -0.5;
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(dropdownValue),
          isSorting == false
              ? DropdownButton<String>(
                  value: dropdownValue,
                  // icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: <String>[
                    'Bubble Sort',
                    'Selection Sort',
                    'Insertion sort'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
              : Container(width: 0),
        ],
      )),
      body: Container(
        padding: EdgeInsets.all(0.0),
        margin: EdgeInsets.all(0.0),
        child: Column(children: <Widget>[
          isSorting == false
              ? Slider(
                  value: value,
                  onChanged: ((newValue) {
                    setState(() {
                      value = newValue;
                      sampleSize = newValue.toInt();
                      _randomize();
                    });
                  }),
                  max: 500,
                  min: 10,
                  label: "$value",
                  divisions: 491,
                )
              : Container(),
          Container(
            padding: EdgeInsets.all(0.0),
            margin: EdgeInsets.all(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: _numbers.map((e) {
                counter++;
                return Row(children: <Widget>[
                  CustomPaint(
                    painter: BarPainter(
                        width: MediaQuery.of(context).size.width *
                            0.8 /
                            sampleSize,
                        value: e,
                        index: counter,
                        sampleSize: sampleSize,
                        m: m,
                        n: n),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2 / sampleSize,
                  )
                ]);
              }).toList(),
            ),
          ),
        ]),
      ),
      bottomNavigationBar: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              child: Text("Randomize"),
              onPressed: _randomize,
            ),
          ),
          Expanded(
            child: FlatButton(
              child: Text("Sort"),
              onPressed: () {
                switch (dropdownValue) {
                  case ('Bubble Sort'):
                    _bubbleSort();
                    break;
                  case 'Selection Sort':
                    _selectionSort();
                    break;
                  default:
                    print("Hello");
                    break;
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class BarPainter extends CustomPainter {
  final double width;
  final int value;
  final double index;
  final int sampleSize;
  final int m;
  final int n;
  BarPainter(
      {this.width, this.value, this.index, this.sampleSize, this.m, this.n});
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    Paint paint = Paint();
    if (index.toInt() == m)
      paint.color = Colors.yellow;
    else if (index.toInt() == n)
      paint.color = Colors.black;
    else
      paint.color = Colors.red;
    paint.strokeWidth = width;
    paint.strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(index * width, 0),
        Offset(index * width, value.ceilToDouble()), paint);
    // print("$width");
    if (sampleSize <= 20) {
      final textStyle = TextStyle(
        color: index.toInt() == n ? Colors.white : Colors.black,
        fontSize: 8,
      );
      final textSpan = TextSpan(
        text: "$value",
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: width,
      );
      final offset = Offset(index * width - width * 0.5, 0);
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
