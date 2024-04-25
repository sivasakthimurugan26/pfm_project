import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:personal_finance_management/constants/color.dart';
import 'package:personal_finance_management/constants/my_utility.dart';
import 'package:personal_finance_management/pages/Login%20&%20SignUp/terms_privacy.dart';

class MobileNumberScreen extends StatefulWidget {
  const MobileNumberScreen({Key? key}) : super(key: key);

  @override
  State<MobileNumberScreen> createState() => _MobileNumberScreenState();
}

class _MobileNumberScreenState extends State<MobileNumberScreen> {
  FocusNode phoneNumberFocus = FocusNode();
  final TextEditingController numberController = TextEditingController();
  String? numberErrorMessage;
  bool numberErrorStatus = false;
  final String errorCross = 'assets/svg/errorCross.svg';
  final String errorTick = 'assets/svg/errorTick.svg';
  AutovalidateMode autoValidate = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    phoneNumberFocus.addListener(() => setState(() {}));
    numberController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    phoneNumberFocus.dispose();
    numberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: MyUtility(context).height,
            child: Column(
              children: [
                SizedBox(height: MyUtility(context).height * 0.16),
                const Text(
                  'Mobile Number Please',
                  style: TextStyle(fontFamily: 'Gilroy SemiBold', fontSize: 25),
                ),
                SvgPicture.asset('assets/svg/dec_line.svg', width: MyUtility(context).width * 0.4),
                SizedBox(height: MyUtility(context).height * 0.25),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80,
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          textAlignVertical: TextAlignVertical.center,
                          focusNode: phoneNumberFocus,
                          style: phoneNumberFocus.hasFocus
                              ? const TextStyle(fontFamily: 'Gilroy Medium', fontSize: 20)
                              : const TextStyle(fontFamily: 'Gilroy Light', fontSize: 20),
                          controller: numberController,
                          decoration: InputDecoration(
                            errorText: numberErrorMessage,
                            isDense: true,
                            errorStyle: const TextStyle(fontFamily: 'Gilroy Medium', fontSize: 16),
                            hintText: 'Mobile Number',
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: textBorderColor),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide:
                                  numberErrorStatus ? const BorderSide(color: textBorderColorError) : const BorderSide(color: textBorderColor),
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide:
                                  numberErrorStatus ? const BorderSide(color: textBorderColorError) : const BorderSide(color: textBorderColor),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: themeColor),
                            ),
                            fillColor: Colors.transparent,
                            filled: true,
                            suffixIcon: numberController.text.isEmpty
                                ? null
                                : RegExp(r'^[0-9]+$').hasMatch(numberController.text) && numberController.text.length > 9
                                    ? SvgPicture.asset(
                                        errorTick,
                                        fit: BoxFit.scaleDown,
                                      )
                                    : SvgPicture.asset(
                                        errorCross,
                                        fit: BoxFit.scaleDown,
                                      ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              numberErrorStatus = true;
                              return ("Please Enter Your Mobile Number");
                            }
                            // reg expression for name validation
                            else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              numberErrorStatus = true;
                              return ("Only Numbers are allowed");
                            } else if (value.length < 10) {
                              return ("Please update 10 digit Mobile Number");
                            } else {
                              numberErrorStatus = false;
                              return null;
                            }
                          },
                          onSaved: (value) {
                            // setState(() {
                            //   userName = value.toString();
                            // });
                          },
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              numberErrorStatus = false;
                            }
                            setState(() {
                              autoValidate = AutovalidateMode.onUserInteraction;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: MyUtility(context).height * 0.12),
                      SizedBox(
                        width: MyUtility(context).width,
                        height: 60,
                        child: ElevatedButton(
                            child: const Text("Send OTP", style: TextStyle(fontSize: 18, fontFamily: 'Gilroy Medium')),
                            style: ElevatedButton.styleFrom(shape: const StadiumBorder(), primary: Colors.black),
                            onPressed: () {
                              // signUp(_emailController.text, _passwordController.text);
                            }),
                      ),
                      SizedBox(height: MyUtility(context).height * 0.03),
                      InkWell(
                        onTap: ()=> Get.to(() => const TermsAndPrivacy()),
                          child: const Text('Skip >>', style: TextStyle(fontSize: 17, fontFamily: 'Gilroy Medium', color: skipColor),))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
