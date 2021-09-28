import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/bottom_nav.dart';
import '../services/services.dart';
// import 'package:apple_sign_in/apple_sign_in.dart'; //Apple sign in 

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthService auth = AuthService();

  @override
  void initState() {
    super.initState();
    auth.getUser.then(
      (user) => {
        // ignore: unnecessary_null_comparison
        if(user != null) {
          Navigator.pushReplacementNamed(context, '/topics')
        }
      }
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FlutterLogo(
              size: 150,
            ),
            Text(
              'Login to start',
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
              ),
            Text('Welcome to my quiz app'),
            LoginButton(
              text: 'LOGIN WITH GOOGLE',
              icon: FontAwesomeIcons.google,
              color: Colors.black45,
              loginMethod: auth.googleSignIn,
            ),
            // // Apple-Sign in
            // FutureBuilder<Object>(
            //   future: auth.appleSignInAvailable,//Check if apple sign in is available on device
            //   builder: (context, snapshot) {
            //      if(snapshot.data == true){
            //        return AppleSignInButton(
            //          onPressed: () async {
            //            FirebaseUser user = await auth.appleSignIn();
            //            if(user != null){
            //              Navigator.pushReplacementNamed(context, '/topics');
            //            }
            //          },
            //        );
            //      } else {
            //        return Container();
            //      }
            //    }
            //   ),
            LoginButton(
              text: 'Continue as Guest', 
              loginMethod: auth.anonLogin,
              color: Colors.transparent,
              icon: FontAwesomeIcons.arrowRight
            )
          ],
        ),
      ),
    );
  }
}

/// A resuable login button for multiple auth methods
class LoginButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function loginMethod;

  LoginButton(
      {Key? key,required this.text, required this.icon, required this.color, required this.loginMethod})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: TextButton.icon(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(30)),
          backgroundColor: MaterialStateProperty.all<Color>(color)
          ),
        icon: Icon(icon, color: Colors.white),
        onPressed: () async {
          var user = await loginMethod();
          if (user != null) {
            Navigator.pushReplacementNamed(context, '/topics');
          }
        },
        label: Expanded(
          child: Text('$text', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}