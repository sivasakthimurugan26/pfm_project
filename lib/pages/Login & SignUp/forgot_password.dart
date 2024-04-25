import 'dart:async';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:personal_finance_management/constants/my_utility.dart';
import 'package:personal_finance_management/pages/Login%20&%20SignUp/login.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController=TextEditingController();
  @override
  void dispose(){
    _emailController.dispose();
    super.dispose();
  }
  Future passwordReset() async{
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              // width: 100,
              // color: Colors.transparent,
              child: AlertDialog(
                // actionsPadding: EdgeInsets.only(left: 10,right: 10),
                content: Text('password reset link send ! check your email'),
                actions: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                    child: SizedBox(
                      // width: 100,
                      width: MyUtility(context).width * 20,
                      height: 50,
                      child: ElevatedButton(
                        child: const Text("Log In",
                            style: TextStyle(
                                fontSize: 18, fontFamily: 'Gilroy Medium')),
                        style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            primary: Colors.black),
                        // onPressed: () => LoginPage(_emailController.text, _passwordController.text)
                        onPressed: () => Get.to(() => const LoginPage()),
                      ),
                    ),
                  )
                ],
              ),
            );
          });
    }
    on FirebaseAuthException catch(e){
      print(e);
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text(e.message.toString()),
        );
      });
    }
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
                  SizedBox(height: MyUtility(context).height * 0.16,),
                  const Text(
                    'Email id Please',
                    style: TextStyle(fontFamily: 'Gilroy Medium', fontSize: 25),
                  ),
                  SvgPicture.asset('assets/svg/dec_line.svg',
                      width: MyUtility(context).width * 0.4),
                  SizedBox(height: MyUtility(context).height * 0.25),
                  Padding(padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 80,
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              isDense: true,
                              errorStyle: const TextStyle(
                                  fontFamily: 'Gilroy SemiBold', fontSize: 16,color: Color(0xffB3B3B3)),
                              hintText: 'Email id',
                              enabledBorder: const UnderlineInputBorder(

                                // borderSide: BorderSide(color: textBorderColor),
                                  borderSide: BorderSide(color: Color(0xffFFB62D,),width: 1)
                              ),

                            ),
                            controller: _emailController,
                          ),
                        ),
                        SizedBox(
                          width: MyUtility(context).width,
                          height: 60,
                          child: ElevatedButton(
                            child: const Text("Send",
                              style: TextStyle(
                                  fontSize: 18,fontFamily: 'Gilroy Medium'

                              ),),
                            style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                primary: Colors.black),
                            // onPressed: (){
                            //   Get.to(()=>OtpNumberScreen());
                            // },
                            onPressed: passwordReset,
                          ),
                        ),
                      ],
                    ),)
                ],
              ),
            ),
          ),
        )
    );
  }
}


