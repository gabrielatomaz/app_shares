import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'json_restful_api.dart';

class FancyFab extends StatefulWidget {
  final Function() onPressed;
  final String tooltip;
  final IconData icon;

  FancyFab({this.onPressed, this.tooltip, this.icon});

  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Color.fromRGBO(49, 107, 90, 1.0),
      end: Color.fromRGBO(91, 91, 91, 1.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget complaint() {
    return Container(
      child: FloatingActionButton(
        onPressed: null,
        tooltip: 'Image',
        heroTag: "img",
        child: Icon(Icons.remove_red_eye),
        backgroundColor: Color.fromRGBO(49, 107, 90, 1.0),
      ),
    );
  }

  Widget logOut() {
    return Container(
      child: FloatingActionButton(
        onPressed: () async {
          var prefs = await SharedPreferences.getInstance();
          prefs.remove('user');
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return LoginWithRestfulApi();
          }));
        },
        tooltip: 'Sair',
        heroTag: "logout",
        child: Icon(Icons.exit_to_app),
        backgroundColor: Color.fromRGBO(49, 107, 90, 1.0),
      ),
    );
  }

  Widget users() {
    return Container(
      child: FloatingActionButton(
        onPressed: null,
        heroTag: "inbox",
        tooltip: 'Inbox',
        child: Icon(Icons.people),
        backgroundColor: Color.fromRGBO(49, 107, 90, 1.0),
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        heroTag: "toggle",
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 3.0,
            0.0,
          ),
          child: logOut(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: users(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: complaint(),
        ),
        toggle(),
      ],
    );
  }
}
