import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:personal_finance_management/pages/stepper.dart';
import 'package:personal_finance_management/service/firebase_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NamePageOnboard extends StatefulWidget {
  const NamePageOnboard({Key? key}) : super(key: key);

  @override
  _NamePageOnboardState createState() => _NamePageOnboardState();
}

Future _getUserName() async {
  SharedPreferences isOnBoarding = await SharedPreferences.getInstance();
  isOnBoarding.setBool('isOnBoarding', false);
  final uid = await AuthService().getCurrentUid();
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('UserData');
  final result = await userCollection.doc(uid).get();
  // print('Result:${result.data()}');
  return result;
}

class _NamePageOnboardState extends State<NamePageOnboard> {
  String visited = 'accountVisited';
  int activeIndex = 1;
  double containerPosition = 0.0;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: <Widget>[
                SizedBox(
                  height: height * 0.60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Flexible(
                      child: MyFutureBuilder(), // Separate FutureBuilder into its own widget
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: height * 0.65,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  containerPosition = width;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.only(left: containerPosition),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SvgPicture.asset('assets/svg/onboardArrow.svg'),
                  ),
                ),
                onEnd: () {
                  Get.to(() => StepperPage(visited, activeIndex));
                  setState(() {
                    containerPosition = 0.0;
                  });
                },
              ),
            )
          ],
        ),
      )),
    );
  }
}

class MyFutureBuilder extends StatefulWidget {
  const MyFutureBuilder({Key? key}) : super(key: key);

  @override
  _MyFutureBuilderState createState() => _MyFutureBuilderState();
}

class _MyFutureBuilderState extends State<MyFutureBuilder> {
  late Future<dynamic> _future;

  @override
  void initState() {
    super.initState();
    _future = _getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(
                  fontSize: 45,
                  fontFamily: 'Gilroy SemiBold',
                  color: Color(0xff1a1a1a),
                ),
              ),
            );
          } else {
            return IntrinsicHeight(
              child: Column(
                children: [
                  Expanded(
                    child: Text(
                      'Hi ${snapshot.data['name']} !',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 45,
                        fontFamily: 'Gilroy SemiBold',
                        color: Color(0xff1a1a1a),
                      ),
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/svg/dec_line.svg',
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                ],
              ),
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
