import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:personal_finance_management/pages/profile/profile_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final List _changeColor = [
    '0xFFFFE2AB',
    '0xffE8E8E8',
    '0xFF89DBED',
    '0xFFFBA2BF',
    '0xFF52FFCF',
    '0xFFC27AD3',
  ];
  List changeimg = [
    'assets/images/profilepage1.png',
    'assets/images/profilepage2.png',
    'assets/images/profilepage3.png',
  ];
  List changeimg1 = [
    'assets/images/profilepage4.png',
    'assets/images/profilepage5.png',
    'assets/images/profilepage6.png',
  ];
  List changeimg2 = [
    'assets/images/profilepage7.png',
    'assets/images/profilepage8.png',
    'assets/images/profilepage9.png',
  ];
  var selectedIndex;
  var bgColors;
  String? colorSelected;
  var selectIndex;
  var bgimgs;
  var bgimgs1;
  String? imgSelected;
  String selectedIcon = '';
  var data = Get.arguments;

  PageController? pageController;
  int pageNo = 0;
  TextEditingController profileNameController = TextEditingController();
  final FocusNode profileNameFocus = FocusNode();
  String? selectedImage;

  getUid() {
    User? user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    print('uid out: $uid');
    return uid;
  }

  @override
  void initState() {
    pageController = PageController(initialPage: 0, viewportFraction: 0.85);
    bgColors = data[1];
    selectedImage = data[2];
    bgimgs = changeimg[1];
    selectedIndex = 0;
    selectIndex = 1;
    showIcon();
    super.initState();

    profileNameController.text = data[0];
    print('data:${data[0]}');
    print('data:${profileNameController.text}');
  }

  void showIcon() {
    Icon(Icons.done_outlined);
  }

  @override
  void dispose() {
    pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            // List updateColors = [];
            // updateColors.add(bgColors);
            // updateColors.add(selectedImage);
            // print('updateColors:$updateColors');
            //Navigator.pop(context,MaterialPageRoute(builder: (context)=> ProfilePage()));
            //  Navigator.pop(context,updateColors);
            //   print('updateColors:$bgColors');
            //Get.to(() => ProfilePage(),arguments:data );

            FirebaseFirestore.instance.collection('UserData').doc(getUid()).update({
              'name': profileNameController.text,
              // 'profileColor': data[1],
              // 'profileImage': data[2],
              'profileColor': bgColors,
              'profileImage': selectedImage,
            });
            print('inkwell:${profileNameController.text}');
            Get.to(() => ProfilePage());
          },
          child: Icon(
            Icons.chevron_left,
            color: Colors.black,
            size: 30,
          ),
        ),
        title: Text(
          'Edit Profile Pic',
          style: TextStyle(color: Colors.black, fontFamily: 'Gilroy Medium', fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Color(int.parse(bgColors!)),
                            borderRadius: BorderRadius.circular(70),
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedImage;
                                  // print("selectedImage:$selectedImage");
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Image.asset(
                                  selectedImage!,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // //padding: EdgeInsets.fromLTRB(150, 145, 10, 10),
                            // Text(data ,
                            //   style: TextStyle(
                            //     color: Color(0xff000000),
                            //     fontFamily: "Gilroy-SemiBold",
                            //     fontSize: 22,
                            //   ),
                            //  ),
                            IntrinsicWidth(
                                child: TextField(
                              controller: profileNameController,
                              focusNode: profileNameFocus,
                              style: const TextStyle(color: Colors.black, fontSize: 22, fontFamily: 'Gilroy SemiBold'),
                              decoration: InputDecoration(
                                hintText: profileNameController.text,
                                border: InputBorder.none,
                              ),
                              maxLines: 1,
                            )
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: InkWell(
                                child: SvgPicture.asset('assets/svg/edit_button.svg'),
                                onTap: () {
                                  profileNameFocus.requestFocus();
                                },
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          height: 130,
                          transform: Matrix4.translationValues(-50, 0, 30),
                          child: PageView(
                            controller: pageController,
                            onPageChanged: (index) {
                              //pageNo = index;
                              setState(() {
                                pageNo = index;
                              });
                            },
                            children: [
                              Container(
                                width: 90,
                                height: 90,
                                padding: EdgeInsets.only(top: 30, left: 80),
                                child: GridView.count(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 20,
                                  children: List.generate(3, (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedImage = changeimg[index];
                                          print('image: $selectedImage');
                                        });
                                      },
                                      child: Image.asset(changeimg[index]),
                                    );
                                  }),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 30, left: 80),
                                child: Container(
                                  width: 90,
                                  height: 90,
                                  child: GridView.count(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 20,
                                    children: List.generate(3, (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedImage = changeimg1[index];
                                            print('image: $selectedImage');
                                          });
                                        },
                                        child: Image.asset(changeimg1[index]),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                              Container(
                                width: 90,
                                height: 90,
                                padding: EdgeInsets.only(top: 30, left: 80),
                                child: GridView.count(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 20,
                                  children: List.generate(3, (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedImage = changeimg2[index];
                                          print('image: $selectedImage');
                                        });
                                      },
                                      child: Image.asset(changeimg2[index]),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              3,
                              (index) => Container(
                                    margin: EdgeInsets.only(left: 10, bottom: 15, top: 0),
                                    child: SizedBox(
                                      child: Icon(
                                        Icons.circle,
                                        size: 7,
                                        color: pageNo == index ? Color(0xFFFFBE78) : Color(0xFFEEEEEE),
                                      ),
                                    ),
                                  )).toList(),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(220, 90, 00, 00),
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
                            // print('wrking');
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                Container(
                  //margin: EdgeInsets.only(top: 0, left: 0),
                  height: 40.0,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: _changeColor.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              bgColors = _changeColor[index];
                              selectedIndex = index;
                              colorSelected = bgColors;
                              print('bgColor: $colorSelected');
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.all(2),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(int.parse(_changeColor[index])), // inner circle color

                                // color: _changeColor[index],
                              ),
                              child: selectedIndex == index
                                  ? Center(
                                      child: Icon(
                                        Icons.done_outlined,
                                      ),
                                    )
                                  : null,
                              width: 45.0,
                            ),
                          ),
                        );
                      }),
                ),
                //         ElevatedButton(
                //         child: Text('save'),
                //         onPressed: () {
                //
                //           FirebaseFirestore.instance.collection('UserData')
                //               .doc(getUid())
                //               .update({
                //             // 'name':data[0],
                //             // 'profileColor': data[1],
                //             // 'profileImage': data[2],
                //             'profileColor': bgColors,
                //             'profileImage':selectedImage,
                //           });
                // },
                //         ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
