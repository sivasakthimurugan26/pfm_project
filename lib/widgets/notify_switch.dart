import 'package:flutter/material.dart';

class NotificationSwitch extends StatefulWidget {
  const NotificationSwitch({super.key});

  @override
  State<NotificationSwitch> createState() => _NotificationSwitchState();
}

class _NotificationSwitchState extends State<NotificationSwitch> with SingleTickerProviderStateMixin {
  bool _isHappy = true;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(1.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleSwitch() {
    setState(() {
      _isHappy = !_isHappy;
    });

    if (_isHappy) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Read',
            style: TextStyle(fontFamily: 'Gilroy Medium', fontSize: 20, color: _isHappy ? Colors.black : const Color(0xff7f7f7f)),
          ),
          GestureDetector(
            onTap: _toggleSwitch,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.14,
              height: MediaQuery.of(context).size.height * 0.035,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: const Color(0xffFFF5E3),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SlideTransition(
                      position: _offsetAnimation,
                      child: Image.asset(
                        _isHappy ? 'assets/images/happy.png' : 'assets/images/sad.png',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Text(
            'Unread',
            style: TextStyle(fontFamily: 'Gilroy Medium', fontSize: 20, color: _isHappy ? const Color(0xff7f7f7f) : Colors.black),
          ),
        ],
      ),
    );
  }
}
