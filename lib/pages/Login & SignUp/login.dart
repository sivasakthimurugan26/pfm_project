import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:personal_finance_management/constants/color.dart';
import 'package:personal_finance_management/constants/my_utility.dart';
import 'package:personal_finance_management/pages/Login%20&%20SignUp/forgot_password.dart';
import 'package:personal_finance_management/pages/homePage.dart';
import 'package:personal_finance_management/pages/Login%20&%20SignUp/signup.dart';
import 'package:personal_finance_management/service/AppChecker.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final String decLine = 'assets/svg/dec_line.svg';
  final String google = 'assets/svg/google.svg';
  final String apple = 'assets/svg/apple.svg';
  final String facebook = 'assets/svg/facebook.svg';
  final String errorCross = 'assets/svg/errorCross.svg';
  final String errorTick = 'assets/svg/errorTick.svg';
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
  bool suffixWrong = false;
  FocusNode passwordFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> formFieldKey = GlobalKey();
  final _auth = FirebaseAuth.instance;
  bool _showPassword = true;
  bool emailErrorStatus = false;
  bool passwordErrorStatus = false;
  late String errorMessage;
  String? emailErrorMessage;
  String? passwordErrorMessage;
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  void _toggleObscured() {
    setState(() {
      _showPassword = !_showPassword;
      if (passwordFocus.hasPrimaryFocus) return; // If focus is on text field, dont unfocus
      passwordFocus.canRequestFocus = false; // Prevents focus if tap on eye
    });
  }

  SvgPicture passwordErrorSuffix() {
    return RegExp(r'^.{7,}$').hasMatch(_passwordController.text)
        ? SvgPicture.asset(
            errorTick,
            fit: BoxFit.scaleDown,
          )
        : SvgPicture.asset(
            errorCross,
            fit: BoxFit.scaleDown,
          );
  }

  SvgPicture emailErrorSuffix() {
    return RegExp(
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
            .hasMatch(_emailController.text)
        ? SvgPicture.asset(
            errorTick,
            fit: BoxFit.scaleDown,
          )
        : SvgPicture.asset(
            errorCross,
            fit: BoxFit.scaleDown,
          );
  }

  passwordSuffix() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
      child: GestureDetector(
        onTap: _toggleObscured,
        child: Icon(
          _showPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
          size: 24,
          color: const Color(0xffb2b2b2),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    passwordFocus.addListener(() => setState(() {}));
    emailFocus.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    passwordFocus.dispose();
    emailFocus.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [introScreenGradient1, introScreenGradient2], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Scaffold(
        backgroundColor: scaffoldTransparent,
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Center(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(40), topLeft: Radius.circular(40)),
                  ),
                  width: MyUtility(context).width,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    child: Form(
                      autovalidateMode: _autoValidate,
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
//Sign In Text
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: MyUtility(context).width / 2.60),
                                  child: const Text(
                                    "Sign In",
                                    style: TextStyle(fontFamily: 'Gilroy Medium', fontSize: 26),
                                  ),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: InkWell(
                                    onTap: () => Get.back(),
                                    child: Container(
                                      decoration: const BoxDecoration(color: closeIconBg, shape: BoxShape.circle),
                                      child: const Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Icon(
                                          Icons.clear,
                                          size: 23,
                                          color: themeColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
//Line Design
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 2, 0, 30),
                              child: SvgPicture.asset(decLine, width: MyUtility(context).width * 0.22),
                            ),
//TextForm
// Email
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: 80,
                                    child: TextFormField(
                                      textInputAction: TextInputAction.next,
                                      textAlignVertical: TextAlignVertical.center,
                                      focusNode: emailFocus,
                                      style: emailFocus.hasFocus
                                          ? const TextStyle(fontFamily: 'Gilroy Medium', fontSize: 18)
                                          : const TextStyle(fontFamily: 'Gilroy Light', fontSize: 16),
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                          errorText: emailErrorMessage,
                                          isDense: true,
                                          errorStyle: const TextStyle(fontFamily: 'Gilroy Medium', fontSize: 16),
                                          hintText: 'Email',
                                          enabledBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(color: textBorderColor),
                                          ),
                                          errorBorder: UnderlineInputBorder(
                                            borderSide: emailErrorStatus
                                                ? const BorderSide(color: textBorderColorError)
                                                : const BorderSide(color: textBorderColor),
                                          ),
                                          focusedErrorBorder: UnderlineInputBorder(
                                            borderSide: emailErrorStatus
                                                ? const BorderSide(color: textBorderColorError)
                                                : const BorderSide(color: textBorderColor),
                                          ),
                                          focusedBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(color: themeColor),
                                          ),
                                          fillColor: Colors.white,
                                          filled: true,
                                          suffixIcon: _emailController.text.isEmpty ? null : emailErrorSuffix()),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          emailErrorStatus = true;
                                          return ("Please Enter Your Email");
                                        }
                                        if (!RegExp(
                                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                            .hasMatch(value)) {
                                          emailErrorStatus = true;
                                          return ("Please Enter a valid email");
                                        }
                                        emailErrorStatus = false;
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _emailController.text = value!;
                                      },
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {
                                          emailErrorStatus = false;
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
//Password
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: 80,
                                    child: TextFormField(
                                      textInputAction: TextInputAction.next,
                                      obscureText: _showPassword,
                                      textAlignVertical: TextAlignVertical.center,
                                      focusNode: passwordFocus,
                                      style: passwordFocus.hasFocus
                                          ? const TextStyle(fontFamily: 'Gilroy Medium', fontSize: 18)
                                          : const TextStyle(fontFamily: 'Gilroy Light', fontSize: 16),
                                      controller: _passwordController,
                                      decoration: InputDecoration(
                                        errorText: passwordErrorMessage,
                                        isDense: true,
                                        errorStyle: const TextStyle(fontFamily: 'Gilroy Medium', fontSize: 16),
                                        hintText: 'Password',
                                        enabledBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(color: textBorderColor),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: passwordErrorStatus
                                              ? const BorderSide(color: textBorderColorError)
                                              : const BorderSide(color: textBorderColor),
                                        ),
                                        focusedErrorBorder: UnderlineInputBorder(
                                          borderSide: passwordErrorStatus
                                              ? const BorderSide(color: textBorderColorError)
                                              : const BorderSide(color: textBorderColor),
                                        ),
                                        focusedBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(color: themeColor),
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                        suffixIcon: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                                          mainAxisSize: MainAxisSize.min, // added line
                                          children: <Widget>[
                                            passwordSuffix(),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            if (_passwordController.text.isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(right: 15),
                                                child: passwordErrorSuffix(),
                                              )
                                          ],
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          passwordErrorStatus = true;
                                          return ("Please Enter Your Password");
                                        }
                                        if (!RegExp(r'^.{7,}$').hasMatch(value)) {
                                          passwordErrorStatus = true;
                                          return ("Password must be at least 7 character");
                                        }
                                        passwordErrorStatus = false;
                                        return null;
                                      },
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {
                                          passwordErrorStatus = false;
                                        }
                                      },
                                      onSaved: (value) {
                                        _passwordController.text = value!;
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
//Forgot Pwd
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: RichText(
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Get.to(() => const ForgotPassword());
                                          },
                                        text: " Forgot Password ?",
                                        style: TextStyle(
                                          fontFamily: 'Gilroy SemiBold',
                                          fontSize: 16,
                                          color: Theme.of(context).colorScheme.primary,
                                        )),
                                  ]),
                                ),
                              ),
                            ),

//Login Button
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                              child: SizedBox(
                                width: MyUtility(context).width,
                                height: 50,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(shape: const StadiumBorder(), backgroundColor: Colors.black),
                                    onPressed: () => signIn(_emailController.text, _passwordController.text),
                                    child: const Text("Log In", style: TextStyle(fontSize: 18, fontFamily: 'Gilroy Medium'))
                                    // onPressed: () => Get.to(() => const MobileNumberScreen()),
                                    ),
                              ),
                            ),
//Sign Up Button
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 40, 20, 40),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: <TextSpan>[
                                  const TextSpan(
                                      text: "Don't have an account ?",
                                      style: TextStyle(fontFamily: 'Gilroy Light', fontSize: 16, color: Colors.black87)),
                                  TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.to(() => const SignUpPage());
                                        },
                                      text: " Sign Up",
                                      style: const TextStyle(
                                        fontFamily: 'Gilroy SemiBold',
                                        fontSize: 16,
                                        color: themeColor,
                                      )),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }

  Future signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.signInWithEmailAndPassword(email: email, password: password).then((value) {
          MySharedPreferences.instance.setBooleanValue("loggedin", true);
          Get.to(() => HomePage());
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            setState(() {
              emailErrorMessage = "Your email appears to be malformed.";
            });
            break;
          case "wrong-password--":
            setState(() {
              passwordErrorMessage = "Your password is wrong.";
            });
            break;
          case "user-not-found":
            setState(() {
              emailErrorMessage = "User with this email doesn't exist.";
            });
            break;
          case "user-disabled":
            setState(() {
              emailErrorMessage = "User with this email has been disabled.";
            });
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened. Please try after sometime";
        }
      }
      setState(() {
        _autoValidate = AutovalidateMode.always;
      });
    }
  }
}
