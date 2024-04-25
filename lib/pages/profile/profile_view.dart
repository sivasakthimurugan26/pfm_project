import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:personal_finance_management/pages/Login%20&%20SignUp/login.dart';
import 'package:personal_finance_management/pages/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var data = Get.arguments;

  TextEditingController profileNameController = TextEditingController();
  TextEditingController profileemailController = TextEditingController();
  final FocusNode profileNameFocus = FocusNode();
  final FocusNode profileIdFocus = FocusNode();
  int profileBG = 0xffFFE2AB;
  bool switchValue = false;
  bool switchValue1 = false;
  String? selectedImage;
  String? email='';

  //
  String profilecolor = '0xffFFE2AB';
  String profileimg = 'assets/images/profileImage.png';
  var bgColors;

  getUid() {
    User? user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    return uid;
  }

  @override
  void initState() {
    super.initState();
    profileimg = 'assets/images/profileImage.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'My Profile',
                      style: TextStyle(fontFamily: 'Gilroy SemiBold', fontSize: 25),
                    ),
                    GestureDetector(
                        onTap: () {
                          FirebaseFirestore.instance.collection('UserData').doc(getUid()).update({
                            'name': profileNameController.text,'email':profileemailController.text
                          });
                          Get.to(() => HomePage(), duration: const Duration(milliseconds: 500), transition: Transition.fadeIn);
                        },
                        child: SvgPicture.asset('assets/svg/activeHomeMenu.svg')),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                //Circle Avatar
                StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('UserData').doc(getUid()).snapshots(),
                    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasData) {
                        final profileData = snapshot.data!;
                        profileNameController.text = profileData['name'];
                        email=profileData['email'];
                        // profileemailController.text=profileData['email'];
                        profileemailController.text=email!;
                        profilecolor = profileData['profileColor'] ?? "0xffFFE2AB";
                        profileimg = profileData['profileImage'] ?? 'assets/images/profileImage.png';
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return Row(
                        children: [
                          Stack(
                            children: [
                              GestureDetector(
                                onTap: () async {},
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Color(int.parse(profilecolor)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: CircleAvatar(
                                      backgroundColor: Color(
                                        int.parse(profilecolor),
                                      ),
                                      radius: 50,
                                      child: Image.asset(
                                        profileimg,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: -5,
                                bottom: -5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    backgroundColor: const Color(0xff4DC88F),
                                    radius: 15,
                                    child: GestureDetector(
                                      child: SvgPicture.asset(
                                        'assets/svg/edit_button.svg',
                                        color: Colors.white,
                                        width: 14,
                                      ),
                                      onTap: () {
                                        Get.to(() => const EditProfilePage(), arguments: [profileNameController.text, profilecolor, profileimg]);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  IntrinsicWidth(
                                      child: TextFormField(
                                    controller: profileNameController,
                                    focusNode: profileNameFocus,
                                    style: const TextStyle(color: Colors.black, fontSize: 22, fontFamily: 'Gilroy SemiBold'),
                                    decoration: InputDecoration(
                                      hintText: profileNameController.text,
                                      border: InputBorder.none,
                                    ),
                                    maxLines: 1,
                                  )),
                                  const SizedBox(width: 10,),
                                  GestureDetector(
                                    child: SvgPicture.asset('assets/svg/edit_button.svg'),
                                    onTap: () {
                                      profileNameFocus.requestFocus();
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('$email',
                                    style: const TextStyle(fontFamily: "Gilroy Medium", fontSize: 15),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    }),

                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Theme',
                  style: TextStyle(fontFamily: "Gilroy SemiBold", fontSize: 15, color: Color(0xffB1B5BF)),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/darkMode.png',
                          height: 20,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Text(
                          'Dark Mode',
                          style: TextStyle(fontSize: 18, fontFamily: "Gilroy SemiBold", color: Color(0xff525252)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                      child: Transform.scale(
                        transformHitTests: false,
                        scale: .8,
                        child: CupertinoSwitch(
                          value: switchValue1,
                          activeColor: CupertinoColors.activeBlue,
                          onChanged: null,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'Settings',
                  style: TextStyle(fontFamily: "Gilroy SemiBold", fontSize: 15, color: Color(0xffB1B5BF)),
                ),
                const SizedBox(
                  height: 30,
                ),
//Mute notification
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/muteNotification.png',
                          height: 25,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Text(
                          'Mute Notification',
                          style: TextStyle(fontSize: 18, fontFamily: "Gilroy SemiBold", color: Color(0xff525252)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                      child: Transform.scale(
                        transformHitTests: false,
                        scale: .8,
                        child: CupertinoSwitch(
                          value: switchValue1,
                          activeColor: CupertinoColors.activeBlue,
                          onChanged: null,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
//Terms & conditions
                Row(
                  children: [
                    Image.asset(
                      'assets/images/t&c.png',
                      height: 25,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      'Terms & Conditions',
                      style: TextStyle(fontSize: 18, fontFamily: "Gilroy SemiBold", color: Color(0xff525252)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
//About Application
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/about.png',
                          height: 25,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Text(
                          'About Application',
                          style: TextStyle(fontSize: 18, fontFamily: "Gilroy SemiBold", color: Color(0xff525252)),
                        ),
                      ],
                    ),
                    TextButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(150),
                        ),
                        backgroundColor: const Color(0xffFFBE78),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'New !',
                        style: TextStyle(fontSize: 18, fontFamily: "Gilroy Medium", color: Color(0xff000000)),
                      ),
                    )
                  ],
                ),

                const SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () {
                    logOut();
                    Get.to(() => const LoginPage());
                  },
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/logout.png',
                        height: 28,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        'Log Out',
                        style: TextStyle(fontSize: 20, fontFamily: "Gilroy SemiBold", color: Color(0xffFFBE78)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  logOut() async {
    SharedPreferences isOnboarding = await SharedPreferences.getInstance();

    isOnboarding.clear();
  }
}
