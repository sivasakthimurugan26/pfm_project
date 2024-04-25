import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:personal_finance_management/constants/color.dart';
import 'package:personal_finance_management/constants/my_utility.dart';
import 'package:personal_finance_management/models/user_model.dart';
import 'package:personal_finance_management/pages/Login%20&%20SignUp/terms_privacy.dart';
import 'package:personal_finance_management/pages/Login%20&%20SignUp/login.dart';
import 'package:personal_finance_management/widgets/custom_progress_indicator.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String userName = "", userEmail = "", userMobile = "";
  final _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final String decLine = 'assets/svg/dec_line.svg';
  final String errorCross = 'assets/svg/errorCross.svg';
  final String errorTick = 'assets/svg/errorTick.svg';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  FocusNode passwordFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();
  FocusNode phoneNumberFocus = FocusNode();
  bool _showPassword = true;
  bool _showConfirmPassword = true;
  bool errorStatus = false;
  bool nameErrorStatus = false;
  bool emailErrorStatus = false;
  bool passwordErrorStatus = false;
  bool confirmPasswordErrorStatus = false;
  bool mobileErrorStatus = false;
  String? errorMessage;
  String? nameErrorMessage;
  String? emailErrorMessage;
  String? passwordErrorMessage;
  String? confirmpasswordErrorMessage;
  bool isLoading = true;
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

  SvgPicture confirmPasswordErrorSuffix() {
    return _passwordController.text == _confirmPasswordController.text
        ? SvgPicture.asset(
            errorTick,
            fit: BoxFit.scaleDown,
          )
        : SvgPicture.asset(
            errorCross,
            fit: BoxFit.scaleDown,
          );
  }

  Padding confirmPasswordSuffix() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
      child: GestureDetector(
        onTap: _toggleConfirmPassword,
        child: Icon(
          _showConfirmPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
          size: 24,
          color: const Color(0xffb2b2b2),
        ),
      ),
    );
  }

  Padding passwordSuffix() {
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

  void _toggleConfirmPassword() {
    setState(() {
      _showConfirmPassword = !_showConfirmPassword;
      if (confirmPasswordFocus.hasPrimaryFocus) return;
      confirmPasswordFocus.canRequestFocus = false;
    });
  }

  @override
  void initState() {
    super.initState();
    passwordFocus.addListener(() => setState(() {}));
    confirmPasswordFocus.addListener(() => setState(() {}));
    nameFocus.addListener(() => setState(() {}));
    emailFocus.addListener(() => setState(() {}));
    phoneNumberFocus.addListener(() => setState(() {}));
    _nameController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
    _phoneController.addListener(() => setState(() {}));
    _confirmPasswordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    phoneNumberFocus.dispose();
    nameFocus.dispose();
    confirmPasswordFocus.dispose();
    passwordFocus.dispose();
    emailFocus.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
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
            // FocusScope.of(context).unfocus();
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
                  // height: MediaQuery.of(context).size.height / 1.3,
                  width: MyUtility(context).width,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    child: Form(
                      autovalidateMode: _autoValidate,
                      key: _formkey,
                      child: SingleChildScrollView(
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
//SignUp Text
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: MyUtility(context).width / 2.7),
                                  child: const Text(
                                    "Sign Up",
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
                              // padding: const EdgeInsets.fromLTRB(0, 2, 0, 30),
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 30),
                              child: SvgPicture.asset(decLine, width: MyUtility(context).width * 0.22),
                            ),
//Name
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: 80,
                                    child: TextFormField(
                                      textInputAction: TextInputAction.next,
                                      textAlignVertical: TextAlignVertical.center,
                                      focusNode: nameFocus,
                                      style: nameFocus.hasFocus
                                          ? const TextStyle(fontFamily: 'Gilroy Medium', fontSize: 16)
                                          : const TextStyle(fontFamily: 'Gilroy Light', fontSize: 16),
                                      controller: _nameController,
                                      decoration: InputDecoration(
                                        errorText: nameErrorMessage,
                                        isDense: true,
                                        errorStyle: const TextStyle(fontFamily: 'Gilroy Medium', fontSize: 16),
                                        hintText: 'Name',
                                        enabledBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(color: textBorderColor),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: nameErrorStatus
                                              ? const BorderSide(color: textBorderColorError)
                                              : const BorderSide(color: textBorderColor),
                                        ),
                                        focusedErrorBorder: UnderlineInputBorder(
                                          borderSide: nameErrorStatus
                                              ? const BorderSide(color: textBorderColorError)
                                              : const BorderSide(color: textBorderColor),
                                        ),
                                        focusedBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(color: themeColor),
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                        suffixIcon: _nameController.text.isEmpty
                                            ? null
                                            : RegExp(r'^[a-z A-Z]+$').hasMatch(_nameController.text)
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
                                          nameErrorStatus = true;
                                          return ("Please Enter Your Name");
                                        }
                                        else if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                                          nameErrorStatus = true;
                                          return ("Only Alphabets are allowed");
                                        } else {
                                          nameErrorStatus = false;
                                          return null;
                                        }
                                      },
                                      onSaved: (value) {
                                        setState(() {
                                          userName = value.toString();
                                        });
                                      },
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {
                                          nameErrorStatus = false;
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
//Email
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: 80,
                                    child: TextFormField(
                                      textInputAction: TextInputAction.next,
                                      textAlignVertical: TextAlignVertical.center,
                                      focusNode: emailFocus,
                                      style: emailFocus.hasFocus
                                          ? const TextStyle(fontFamily: 'Gilroy Medium', fontSize: 16)
                                          : const TextStyle(fontFamily: 'Gilroy Light', fontSize: 16),
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                        errorText: emailErrorMessage,
                                        isDense: true,
                                        errorStyle: const TextStyle(fontFamily: 'Gilroy Medium', fontSize: 16),
                                        // contentPadding: EdgeInsets.only(left: 25),
                                        hintText: 'Email Id',
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
                                        suffixIcon: _emailController.text.isEmpty
                                            ? null
                                            : RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                                    .hasMatch(_emailController.text)
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
                                          emailErrorStatus = true;
                                          return ("Please Enter Your Email");
                                        }
                                        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                                          emailErrorStatus = true;
                                          return ("Please Enter a valid email");
                                        }
                                        errorStatus = false;
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
//Mobile Number
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: 80,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      textAlignVertical: TextAlignVertical.center,
                                      focusNode: phoneNumberFocus,
                                      style: phoneNumberFocus.hasFocus
                                          ? const TextStyle(fontFamily: 'Gilroy Medium', fontSize: 16)
                                          : const TextStyle(fontFamily: 'Gilroy Light', fontSize: 16),
                                      controller: _phoneController,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        errorStyle: const TextStyle(fontFamily: 'Gilroy Medium', fontSize: 15),
                                        // contentPadding: EdgeInsets.only(left: 25),
                                        hintText: 'Mobile Number',
                                        enabledBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(color: textBorderColor),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: mobileErrorStatus
                                              ? const BorderSide(color: textBorderColorError)
                                              : const BorderSide(color: textBorderColor),
                                        ),
                                        focusedErrorBorder: UnderlineInputBorder(
                                          borderSide: mobileErrorStatus
                                              ? const BorderSide(color: textBorderColorError)
                                              : const BorderSide(color: textBorderColor),
                                        ),
                                        focusedBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(color: themeColor),
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                        suffixIcon: _phoneController.text.isEmpty
                                            ? null
                                            : RegExp(r'^[0-9]+$').hasMatch(_phoneController.text)
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
                                        if(value!.isEmpty){
                                          return ('Please Enter Mobile number');
                                        }else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                          mobileErrorStatus = true;
                                          return ("Only Numbers are allowed");
                                        }
                                        if (value.length < 10 || value.length > 10 ){
                                          return ("Please update 10 digit Mobile number");
                                        }
                                        else {
                                          errorStatus = false;
                                          return null;
                                        }
                                      },
                                      onSaved: (value) {
                                        setState(() {
                                          userMobile = value.toString();
                                        });
                                      },
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {
                                          mobileErrorStatus = false;
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
//Password
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
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
                                          ? const TextStyle(fontFamily: 'Gilroy Medium', fontSize: 16)
                                          : const TextStyle(fontFamily: 'Gilroy Light', fontSize: 16),
                                      controller: _passwordController,
                                      decoration: InputDecoration(
                                        errorText: passwordErrorMessage,
                                        isDense: true,
                                        errorStyle: const TextStyle(fontFamily: 'Gilroy Medium', fontSize: 15),
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
                                      onSaved: (value) {
                                        _passwordController.text = value!;
                                      },
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {
                                          passwordErrorStatus = false;
                                        }
                                        // setState(() {
                                        //   _autoValidate = AutovalidateMode.onUserInteraction;
                                        // });
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
//Confirm password
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: 80,
                                    child: TextFormField(
                                      textInputAction: TextInputAction.next,
                                      obscureText: _showConfirmPassword,
                                      textAlignVertical: TextAlignVertical.center,
                                      focusNode: confirmPasswordFocus,
                                      style: confirmPasswordFocus.hasFocus
                                          ? const TextStyle(fontFamily: 'Gilroy Medium', fontSize: 16)
                                          : const TextStyle(fontFamily: 'Gilroy Light', fontSize: 16),
                                      controller: _confirmPasswordController,
                                      decoration: InputDecoration(
                                        errorText: confirmpasswordErrorMessage,
                                        isDense: true,
                                        errorStyle: const TextStyle(fontFamily: 'Gilroy Medium', fontSize: 16),
                                        hintText: 'Confirm Password',
                                        enabledBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(color: textBorderColor),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: confirmPasswordErrorStatus
                                              ? const BorderSide(color: textBorderColorError)
                                              : const BorderSide(color: textBorderColor),
                                        ),
                                        focusedErrorBorder: UnderlineInputBorder(
                                          borderSide: confirmPasswordErrorStatus
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
                                            confirmPasswordSuffix(),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            if (_confirmPasswordController.text.isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(right: 15),
                                                child: confirmPasswordErrorSuffix(),
                                              )
                                          ],
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          confirmPasswordErrorStatus = true;
                                          return ("Please re-enter password");
                                        }
                                        if (_passwordController.text != _confirmPasswordController.text) {
                                          confirmPasswordErrorStatus = true;
                                          return "Password does not match";
                                        }
                                        confirmPasswordErrorStatus = false;
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _confirmPasswordController.text = value!;
                                      },
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {
                                          confirmPasswordErrorStatus = false;
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            errorMessage != null
                                ? Text(
                                    errorMessage.toString(),
                                    style: const TextStyle(fontFamily: 'Gilroy Medium', fontSize: 20, color: Color(0xffFF7B65)),
                                  )
                                : const Text(''),

//Signup Button
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                              child: SizedBox(
                                width: MyUtility(context).width,
                                height: 50,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(shape: const StadiumBorder(), backgroundColor: Colors.black),
                                    onPressed: () {
                                      signUp(_emailController.text, _passwordController.text);
                                    },
                                    child: const Text("Sign Up", style: TextStyle(fontSize: 18, fontFamily: 'Gilroy Medium'))),
                              ),
                            ),
//Sign in Button
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 40, 20, 30),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: <TextSpan>[
                                  const TextSpan(
                                      text: "Already have an account ?",
                                      style: TextStyle(fontFamily: 'Gilroy Light', fontSize: 16, color: Colors.black87)),
                                  TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.to(() => const LoginPage());
                                        },
                                      text: " Sign In",
                                      style: TextStyle(
                                        fontFamily: 'Gilroy SemiBold',
                                        fontSize: 16,
                                        color: Theme.of(context).colorScheme.primary,
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

  Future signUp(String email, String password) async {
    // print(email + "" + password + "");
    if (_formkey.currentState!.validate()) {
      try {
        await _auth.createUserWithEmailAndPassword(email: email, password: password).then((value) => addUser());
      } on FirebaseAuthException catch (error) {
        print('Error:$error');
        switch (error.code) {
          case "invalid-email":
            emailErrorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            passwordErrorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            emailErrorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            emailErrorMessage = "User with this email has been disabled.";
            break;
          case "email-already-in-use":
            errorMessage = "Email already in use.";
            emailErrorMessage = "Email already in use.";
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
        setState(() {
          _autoValidate = AutovalidateMode.always;
        });
        if (kDebugMode) {
          print("Registration Error${error.code}");
        }
      }
    }
  }

  addUser() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();

    userModel.email = user?.email;
    userModel.uid = user?.uid;
    userModel.name = _nameController.text;
    userModel.mobile = _phoneController.text;
    userModel.profileImage = 'assets/images/profileImage.png';
    userModel.profileColor = '0xffFFE2AB';

    myProgressIndicator(context);
    await firebaseFirestore.collection("UserData").doc(user?.uid).set(userModel.toMap());
    Get.to(() => const TermsAndPrivacy());
  }
}
