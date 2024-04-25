import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:personal_finance_management/constants/color.dart';
import 'package:personal_finance_management/models/user_model.dart';
import 'package:personal_finance_management/pages/Login%20&%20SignUp/login.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../onBoarding/name_page.dart';

class SocialLoginPage extends StatefulWidget {
  const SocialLoginPage({Key? key}) : super(key: key);

  @override
  State<SocialLoginPage> createState() => _SocialLoginPageState();
}

class _SocialLoginPageState extends State<SocialLoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var userInfo;
  String userEMail = '';

  Future<UserCredential> googleSignIn() async {
    GoogleSignIn googleSignIn = GoogleSignIn();

    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final UserCredential user = await _auth.signInWithCredential(credential);
      String profileImage = 'assets/images/profileImage.png';
      User? currentUser = _auth.currentUser;
      String userEmail = googleUser.email;
      userInfo = user.additionalUserInfo?.username;
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      UserModel userModel = UserModel();
      userModel.uid = currentUser?.uid;
      userModel.email = userEmail;
      userModel.name = user.user?.displayName;
      userModel.profileImage = profileImage;
      userModel.profileColor = '0xffFFE2AB';
      await firebaseFirestore.collection("UserData").doc(currentUser?.uid).set(userModel.toMap());
      Get.to(() => const NamePageOnboard());

      return user;
    } else {
      throw StateError('Sign in Aborted');
    }
  }
  Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login(
      permissions: ['email'],
    );

    final AccessToken? accessToken = await FacebookAuth.instance.accessToken;
    if (accessToken != null) {
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
      final userData = await FacebookAuth.instance.getUserData();
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      UserModel userModel = UserModel();
      final UserCredential user = await _auth.signInWithCredential(facebookAuthCredential);
      userInfo = user.additionalUserInfo?.username;
      userModel.uid = _auth.currentUser?.uid;
      userModel.email = user.user?.email;
      userModel.name = user.user?.displayName;
      try {
        await firebaseFirestore.collection("UserData").doc(_auth.currentUser?.uid).get();
        Get.to(() => const NamePageOnboard());
      } catch (e) {
        await firebaseFirestore.collection("UserData").doc(_auth.currentUser?.uid).set(userModel.toMap());
        Get.to(() => const NamePageOnboard());
      }
      await firebaseFirestore.collection("UserData").doc(_auth.currentUser?.uid).set(userModel.toMap());
      Get.to(() => const NamePageOnboard());
      userEMail = userData['email'];
      return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } else {
      throw StateError('Missing Google Auth Token');
    }
  }

  void appleSignIn() async {
    AuthorizationResult authorizationResult = await TheAppleSignIn.performRequests([
      const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (authorizationResult.status) {
      case AuthorizationStatus.authorized:
        AppleIdCredential? appleCredentials = authorizationResult.credential;
        OAuthProvider oAuthProvider = OAuthProvider('apple.com');
        OAuthCredential oAuthCredential = oAuthProvider.credential(idToken: String.fromCharCodes(appleCredentials!.identityToken!),
        accessToken: String.fromCharCodes(appleCredentials.authorizationCode!));
        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(oAuthCredential);

        String profileImage = 'assets/images/profileImage.png';
        User? currentUser = _auth.currentUser;
        String userEmail = appleCredentials.email!;
        userInfo = userCredential.additionalUserInfo?.username;
        FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
        UserModel userModel = UserModel();
        userModel.uid = currentUser?.uid;
        userModel.email = userEmail;
        userModel.name = userCredential.user?.displayName;
        userModel.profileImage = profileImage;
        userModel.profileColor = '0xffFFE2AB';
        await firebaseFirestore.collection("UserData").doc(currentUser?.uid).set(userModel.toMap());

        print('userEmail: $userEmail');
        // Get.to(() => const NamePageOnboard());

        break;
      case AuthorizationStatus.cancelled:
        break;
      case AuthorizationStatus.error:
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [introScreenGradient1, introScreenGradient2], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
//Title
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Hello,',
                          style: TextStyle(fontSize: 36, fontFamily: 'Gilroy Medium'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Text(
                            'We are XX',
                            style: TextStyle(fontSize: 36, fontFamily: 'Gilroy Medium'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Text(
                            'Create an Sign in or Sign Up to begin',
                            style: TextStyle(fontSize: 16, fontFamily: 'Gilroy Light'),
                          ),
                        ),
                      ],
                    ),
                  ),
//Social Logins
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 75),
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: const BoxDecoration(
                            color: introScreenGradient2,
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: GestureDetector(
                                onTap: () async {
                                  await googleSignIn();
                                  if (mounted) {
                                    Get.to(() => const LoginPage());
                                  }
                                },
                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(
                                      width: 60,
                                    ),
                                    SvgPicture.asset('assets/svg/google.svg'),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text(
                                      'Continue with Google',
                                      style: TextStyle(fontSize: 16, fontFamily: 'Gilroy Light'),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (defaultTargetPlatform == TargetPlatform.iOS)
                          Container(
                            decoration: const BoxDecoration(
                              color: introScreenGradient2,
                              borderRadius: BorderRadius.all(Radius.circular(40)),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                child: GestureDetector(
                                  onTap: () async {
                                    // appleSignIn();
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      const SizedBox(
                                        width: 60,
                                      ),
                                      SvgPicture.asset('assets/svg/apple.svg'),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
                                        'Continue with Apple',
                                        style: TextStyle(fontSize: 16, fontFamily: 'Gilroy Light'),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: introScreenGradient2,
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: GestureDetector(
                                onTap: () {
                                  signInWithFacebook();
                                  if (mounted) {
                                    Get.to(() => const LoginPage());
                                  }
                                },
                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(
                                      width: 60,
                                    ),
                                    SvgPicture.asset('assets/svg/facebook.svg'),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text(
                                      'Continue with Facebook',
                                      style: TextStyle(fontSize: 16, fontFamily: 'Gilroy Light'),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
//Other Sign In options
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(children: <TextSpan>[
                          const TextSpan(
                              text: "More sign in options", style: TextStyle(fontFamily: 'Gilroy Light', fontSize: 16, color: Colors.black87)),
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(() => const LoginPage());
                                },
                              text: " Click here",
                              style: TextStyle(
                                fontFamily: 'Gilroy SemiBold',
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.primary,
                              )),
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
