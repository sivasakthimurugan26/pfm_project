// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// class CustomDialogBox extends StatefulWidget {
//   @override
//   State<CustomDialogBox> createState() => _CustomDialogBoxState();
// }
//
// class _CustomDialogBoxState extends State<CustomDialogBox> {
//   List<Color> _changeColor = [
//     Color(0xFFFFE2AB),
//     Color(0xFF89DBED),
//     Color(0xFFFBA2BF),
//     Color(0xFFFFDFCD),
//     Color(0xFF52FFCF),
//     Color(0xFFC27AD3),
//   ];
//
//   var selectedIndex;
//   var bgColors;
//   var colorSelected;
//   bool isSelected = false;
//   final animationDuration = Duration(milliseconds: 500);
//   TextEditingController _controller = TextEditingController(text: 'Reminder Name');
//   bool _isEnable = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(30),
//       ),
//       elevation: 16,
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height * 0.58,
//         padding: EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(25),
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             stops: [0.0, 0.25],
//             colors: [
//               Color(0xffFFE4C8),
//               Color(0xffffffff),
//             ],
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(left: 250, top: 00, bottom: 20),
//                 // padding: EdgeInsets.only(left: 1.60),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(30),
//                     color: Colors.white,
//                   ),
//                   width: 30,
//                   height: 30,
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Image.asset(
//                       'assets/images/Vector.png',
//                     ),
//                   ),
//                 ),
//               ),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Auto',
//                     style: TextStyle(
//                       fontSize: 17,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         isSelected = !isSelected;
//                       });
//                     },
//                     child: AnimatedContainer(
//                       height: 30,
//                       width: 55,
//                       duration: animationDuration,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(30),
//                         color: Color(0xFFFEF8F1),
//                         border: Border.all(color: Colors.white, width: 2),
//                       ),
//                       child: AnimatedAlign(
//                         duration: animationDuration,
//                         alignment: isSelected
//                             ? Alignment.centerRight
//                             : Alignment.centerLeft,
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 2),
//                           child: Container(
//                               height: 25,
//                               width: 25,
//                               decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Color(0xFFFFBE78)),
//                               child: Icon(
//                                 isSelected
//                                     ? Icons.chevron_right
//                                     : Icons.chevron_left,
//                                 color: Colors.white,
//                               )),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Text(
//                     'Manual',
//                     style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 35),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     width: 160,
//                     child: TextField(
//                       style: TextStyle(
//                         fontFamily: "Gilroy Medium",
//                         fontSize: 22,
//                         fontWeight: FontWeight.w600,
//                       ),
//                       decoration: InputDecoration(
//                         border: InputBorder.none,
//                       ),
//                       controller: _controller,
//                       enabled: _isEnable,
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: (){
//                       setState(() {
//                         _isEnable = true;
//                         _controller.clear();
//                       });
//                     },
//                     icon: SvgPicture.asset('assets/svg/edit_button.svg'),
//                   )
//                 ],
//               ),
//
//               Padding(
//                 padding: EdgeInsets.only(top: 20, left: 15, right: 15),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     contentPadding: EdgeInsets.only(left: 20),
//                     labelText: 'Description',
//                     fillColor: Color(0xff979797),
//                     enabledBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0xffFFBE78),
//                           width: 2,
//                         )),
//                   ),
//                 ),
//               ),
//
//
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     margin: EdgeInsets.only(top: 80),
//                     height: 35,
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       scrollDirection: Axis.horizontal,
//                       itemCount: _changeColor.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         return GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               bgColors = _changeColor[index];
//                               selectedIndex = index;
//                               colorSelected = bgColors;
//                             });
//                           },
//                           child: Container(
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: _changeColor[index],
//                             ),
//                             child: selectedIndex == index
//                                 ? Icon(Icons.done_outlined)
//                                 : Container(),
//                             width: 45.0,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               Container(
//                 margin: EdgeInsets.only(top: 60),
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: Colors.black,
//                     style: BorderStyle.solid,
//                     width: 12.5,
//                   ),
//                   color: Colors.black,
//                   borderRadius: BorderRadius.circular(30.0),
//                 ),
//                 child: Center(
//                   child: Text(
//                     "Save",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontFamily: 'Gilroy-Medium',
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                       letterSpacing: 1,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class CustomDialogBox extends StatefulWidget {
  @override
  State<CustomDialogBox> createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  final List<int> _changeColor = [
    0xFFFFE2AB,
    0xFF89DBED,
    0xFFFBA2BF,
    0xFFFFDFCD,
    0xFF52FFCF,
    0xFFC27AD3,
  ];

  var selectedIndex;
  var bgColors;
  var colorSelected;
  bool isSelected = false;
  final animationDuration = Duration(milliseconds: 500);
  TextEditingController _controller = TextEditingController();
  TextEditingController _descController = TextEditingController();
  bool _isEnable = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 16,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.55,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.25],
            colors: [
              Color(0xffFFE4C8),
              Color(0xffffffff),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 250, top: 00, bottom: 20),
                // padding: EdgeInsets.only(left: 1.60),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  width: 30,
                  height: 30,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Image.asset(
                      'assets/images/Vector.png',
                    ),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Auto',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelected = !isSelected;
                        print('isSelected: $isSelected');
                      });
                    },
                    child: AnimatedContainer(
                      height: 30,
                      width: 55,
                      duration: animationDuration,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color(0xFFFEF8F1),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: AnimatedAlign(
                        duration: animationDuration,
                        alignment: isSelected
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Container(
                              height: 25,
                              width: 25,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFFFBE78)),
                              child: Icon(
                                isSelected
                                    ? Icons.chevron_right
                                    : Icons.chevron_left,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Manual',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              const SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 180,
                    child: TextField(
                      style: const TextStyle(
                        fontFamily: "Gilroy Medium",
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Remainder Name',
                        border: InputBorder.none,
                      ),
                      controller: _controller,
                      // enabled: _isEnable,
                      onTap: (){
                        setState(() {
                          _isEnable = true;
                          print(_controller.text);
                        });
                      }, onChanged: (_){
                      // print(_controller.text);
                    },
                    ),
                  ),
                  IconButton(
                    onPressed: (){
                      setState(() {
                        _isEnable = true;
                        _controller.clear();
                      });
                    },
                    icon: SvgPicture.asset('assets/svg/edit_button.svg'),
                  )
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                child: TextField(
                  controller: _descController,
                  minLines: 3,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 20),
                    labelText: 'Description',
                    fillColor: Color(0xff979797),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffFFBE78),
                          width: 2,
                        )),
                  ),
                  onChanged: (_){
                    print(_descController.text);
                  },
                ),
              ),


              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 80),
                    height: 35,
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
                              print(bgColors);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(_changeColor[index]),
                            ),
                            child: selectedIndex == index
                                ? Icon(Icons.done_outlined)
                                : Container(),
                            width: 45.0,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  print('auto/manual: $isSelected');
                  print('RemainderName: ${_controller.text}');
                  print('RemainderDesc: ${_descController.text}');
                  print('Color: $bgColors');
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 60),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 12.5,
                    ),
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: const Center(
                    child: Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Gilroy-Medium',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}