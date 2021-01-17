import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sport_equipment/login.dart';
import 'package:sport_equipment/loaders/color_loader_4.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      theme: ThemeData(primaryColor: Colors.white),
      home: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.lightBlue[50]),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 50.0,
                          child: Image.asset('assets/images/logo.png')),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        "MyLendSport",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  )),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ColorLoader4(),
                      Padding(padding: EdgeInsets.only(top: 20.0)),
                      Text(
                        "Online Lending Service",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

// class ProgressIndicator extends StatefulWidget {
//   @override
//   _ProgressIndicatorState createState() => new _ProgressIndicatorState();
// }

// class _ProgressIndicatorState extends State<ProgressIndicator>
//     with SingleTickerProviderStateMixin {
//   AnimationController controller;
//   Animation<double> animation;

//   @override
//   void initState() {
//     super.initState();

//     controller = AnimationController(
//         duration: const Duration(milliseconds: 2000), vsync: this);
//     animation = Tween(begin: 0.0, end: 1.0).animate(controller)
//       ..addListener(() {
//         setState(() {
//           //updating states
//           if (animation.value > 0.99) {
//             controller.stop();
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (BuildContext context) => LoginScreen()));

//             // Navigator.push(
//             //     context,
//             //     MaterialPageRoute(
//             //         builder: (BuildContext context) => LoginScreen()));
//           }
//         });
//       });
//     controller.repeat();
//   }

//   @override
//   void dispose() {
//     controller.stop();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Center(
//         child: new Container(
//       //width: 300,
//       child: CircularProgressIndicator(
//         value: animation.value,
//         //backgroundColor: Colors.brown,
//         valueColor: new AlwaysStoppedAnimation<Color>(Colors.red[200]),
//       ),
//     ));
//   }
// }
