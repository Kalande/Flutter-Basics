import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('About'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Text('About my quiz app...'),
        ),
        bottomNavigationBar: AppBottomNav(),
      );
  }
}