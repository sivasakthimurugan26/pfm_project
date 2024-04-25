import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:personal_finance_management/constants/color.dart';
import 'package:personal_finance_management/constants/my_utility.dart';
import 'package:personal_finance_management/constants/svg_constant.dart';
import 'package:personal_finance_management/pages/onBoarding/name_page.dart';
import 'package:personal_finance_management/widgets/edit_popup/Teams_popup.dart';
import 'package:personal_finance_management/widgets/edit_popup/popup_box.dart';

class TermsAndPrivacy extends StatefulWidget {
  const TermsAndPrivacy({Key? key}) : super(key: key);

  @override
  State<TermsAndPrivacy> createState() => _TermsAndPrivacyState();
}

class _TermsAndPrivacyState extends State<TermsAndPrivacy> {
  bool status = true;
  bool editButtonVisible = false;
  bool privacy = true;
  bool termsConditions = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                margin:const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          // width: MyUtility(context).width,
                          decoration: const BoxDecoration(color: termsBG, borderRadius: BorderRadius.all(Radius.circular(40))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                status
                                    ? Text('Terms & Conditions',
                                    style: TextStyle(fontFamily: "Gilroy Medium", fontSize: 16, color: Colors.black.withOpacity(0.5)))
                                    : const Text('Terms & Conditions', style: TextStyle(fontFamily: "Gilroy Medium", fontSize: 16)),
                                const SizedBox(
                                  width: 10,
                                ),
                                FlutterSwitch(
                                  width: 55.0,
                                  height: 28.0,
                                  activeIcon: SvgPicture.asset('assets/svg/switchOnIcon_yellow.svg'),
                                  inactiveIcon: SvgPicture.asset('assets/svg/switchOffIcon_yellow.svg'),
                                  activeColor: const Color(0xffffffff),
                                  inactiveColor: const Color(0xffffffff),
                                  activeToggleColor: themeColor,
                                  inactiveToggleColor: themeColor,
                                  toggleSize: 30.0,
                                  value: status,
                                  borderRadius: 30.0,
                                  padding: 2.0,
                                  onToggle: (val) {
                                    setState(() {
                                      status = val;
                                      // print('status: $status');
                                      if (status == true) {
                                        termsConditions = false;
                                        privacy = true;
                                        editButtonVisible = false;
                                      } else {
                                        termsConditions = true;
                                        privacy = false;
                                        editButtonVisible = true;
                                      }
                                    });
                                  },
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                status
                                    ? const Text('Privacy Policy',
                                    style: TextStyle(
                                      fontFamily: "Gilroy Medium",
                                      fontSize: 16,
                                    ))
                                    : Text('Privacy Policy',
                                    style: TextStyle(fontFamily: "Gilroy Medium", fontSize: 16, color: Colors.black.withOpacity(0.5)))
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Visibility(
                            visible: termsConditions,
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Terms & Conditions',
                                    style: TextStyle(fontFamily: 'Gilroy Medium', fontSize: 20),
                                  ),
                                ),
                                SvgPicture.asset('assets/svg/dec_line.svg', width: MyUtility(context).width * 0.35),
                                const SizedBox(
                                  height: 30,
                                ),
                                const Text(
                                  'Lorem Ipsum is simply dummy text of the printing typesetting industry. Lorem  Ipsum  has  been the standard dummy text ever since the 1500s, when unknown printer took a galley of type and scram to make atype specimen book.It has survived not five centuries, but also   the   leap into electronic typesetting, remaining essentially unchanged. It popularised in the 1960s with the release of sheets recently with desktop publishing software likePageMaker including versions of Lorem Ipsum.',
                                  style: TextStyle(fontFamily: 'Gilroy Medium', fontSize: 16, color: termsFont, height: 1.5),
                                  textAlign: TextAlign.justify,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                    'Lorem Ipsum is simply dummy text of the printing typesetting industry. Lorem  Ipsum  has  been the standard dummy text ever since the 1500s, when unknown printer took a galley of type and scram to make atype specimen book.',
                                    style: TextStyle(fontFamily: 'Gilroy Medium', fontSize: 16, color: termsFont, height: 1.5),
                                    textAlign: TextAlign.justify),
                              ],
                            )),
                        Visibility(
                            visible: privacy,
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Privacy Policy',
                                    style: TextStyle(fontFamily: 'Gilroy Medium', fontSize: 20),
                                  ),
                                ),
                                SvgPicture.asset('assets/svg/dec_line.svg', width: MyUtility(context).width * 0.30),
                                const SizedBox(
                                  height: 30,
                                ),
                                const Text(
                                  'Lorem Ipsum is simply dummy text of the printing typesetting industry. Lorem  Ipsum  has  been the standard dummy text ever since the 1500s, when unknown printer took a galley of type and scram to make atype specimen book.',
                                  style: TextStyle(fontFamily: 'Gilroy Medium', fontSize: 16, color: termsFont, height: 1.5),
                                  textAlign: TextAlign.justify,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'It has survived not five centuries, but also   the   leap into electronic typesetting, remaining essentially unchanged. It popularised in the 1960s with the release of sheets recently with desktop publishing software likePageMaker including versions of Lorem Ipsum.',
                                  style: TextStyle(fontFamily: 'Gilroy Medium', fontSize: 16, color: termsFont, height: 1.5),
                                  textAlign: TextAlign.justify,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                    'Lorem Ipsum is simply dummy text of the printing typesetting industry. Lorem  Ipsum  has  been the standard dummy text ever since the 1500s, when unknown printer took a galley of type and scram to make atype specimen book.',
                                    style: TextStyle(fontFamily: 'Gilroy Medium', fontSize: 16, color: termsFont, height: 1.5),
                                    textAlign: TextAlign.justify),
                              ],
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      showGeneralDialog(
                        barrierDismissible: true,
                        barrierLabel: '',
                        barrierColor: Colors.black38,
                        transitionDuration: const Duration(milliseconds: 500),
                        pageBuilder: (ctx, anim1, anim2) => const TeamsPopUp(),
                        transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
                          child: FadeTransition(
                            opacity: anim1,
                            child: child,
                          ),
                        ),
                        context: context,
                      );

                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child:
                      Container(
                        width: MyUtility(context).width * 0.40,
                        decoration: const BoxDecoration(
                          color: Color(0xffF6F6F6),
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(fontSize: 18, fontFamily: 'Gilroy Medium'),
                              )),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        Get.to(() => const NamePageOnboard());
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Container(
                          width: MyUtility(context).width * 0.40,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Center(
                                child: Text(
                                  'Accept',
                                  style: TextStyle(fontSize: 18, fontFamily: 'Gilroy Medium', color: Colors.white),
                                )),
                          ),
                        ),
                      )),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
