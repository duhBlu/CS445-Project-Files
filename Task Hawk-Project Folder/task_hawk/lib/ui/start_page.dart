import 'package:flutter/material.dart';

import 'complex_example.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Hawk'),
      ),
      body: Center(
        /*
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("hawk head.png"),
              fit: BoxFit.cover,
            ),
          ),*/
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            const SizedBox(height: 12.0),
            ElevatedButton(
              child: Text('Sign Up'),
              onPressed: null,
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              child: Text('Sign In'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TableComplexExample()),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
