import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:personal_finance_management/widgets/notify_switch.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isHappy = false;

  void _toggleSwitch() {
    setState(() {
      isHappy = !isHappy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: SvgPicture.asset(
                'assets/svg/backButton.svg',
              ),
            )),
        title: const NotificationSwitch(),
      ),
      body: const Center(
        child: Text('Notification Page'),
      ),
    );
  }
}
