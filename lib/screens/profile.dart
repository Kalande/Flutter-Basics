import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../services/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {

  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {

    var user = Provider.of<FirebaseUser>(context);//Get the user data from the widget tree

    return Scaffold(
        appBar: AppBar(
          title: Text(user.displayName != null? user.displayName: 'Profile'),
          backgroundColor: Colors.deepOrange,
        ),
        body: Center(
          child: TextButton(
              onPressed: () async {
                 await auth.signOut();
                 Navigator.popAndPushNamed(context, '/');
              },
              child: Text('logout', style: TextStyle(color: Colors.red),),),
        ),
        bottomNavigationBar: AppBottomNav());
  }
}
