import 'registration_screen.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/compo/button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    // animation =
    // CurvedAnimation(parent: controller, curve: Curves.easeInOutSine);

//    animation.addStatusListener((status) {
//      if (status == AnimationStatus.completed)
//        controller.reverse(from: 1.0);
//      else if (status == AnimationStatus.dismissed) controller.forward();
//    });
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
      // print(animation.value);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      // backgroundColor: Colors.red.withOpacity(controller.value),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 100.0,
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TypewriterAnimatedTextKit(
                  text: ['Tesla Chat'],
                  //'${controller.value.toInt()}%',
                  textStyle: TextStyle(
                    fontSize: 33.0,
                    fontFamily: "TESLA",
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            MaterialButton(
//              style:textStyle: TextStyle(
////              fontSize: 33.0,
////              fontFamily: "custom",
////              fontWeight: FontWeight.w900,
////            ),
              child: Text(
                'Log In',
                style: TextStyle(
                  fontFamily: "Titilium",
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              color: Colors.lightBlueAccent,
              shape: StadiumBorder(),

              height: 45,
              elevation: 3,

              highlightElevation: 5,

              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            button(
              title: 'Register ',
              color: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
