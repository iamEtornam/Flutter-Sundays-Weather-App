import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(
          Icons.menu,
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Center(
                  child: Text(
                    'Cold',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  'Accra, Ghana',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey),
                ),
              ],
            ),
            Column(
              children: [
                Image(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
                  image: Svg('assets/cloud.svg'),
                ),
                Text('19°',
                    style: TextStyle(color: Colors.black, fontSize: 21)),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Next day',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.black),
                ),
                SizedBox(
                  width: 30,
                ),
                Image(
                  image: Svg('assets/sun.svg'),
                  width: 25,
                  height: 25,
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  '22°',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
