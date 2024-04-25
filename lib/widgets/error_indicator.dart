import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../pages/Login & SignUp/login.dart';

void errorIndicator(BuildContext context, String errorText){
  // AlertDialog alert = AlertDialog(
  //   actions: <Widget>[
  //     Positioned(
  //       right: 0.0,
  //       child: GestureDetector(
  //         onTap: (){
  //           Get.to(LoginPage());
  //         },
  //         child: Align(
  //           alignment: Alignment.topRight,
  //           child: CircleAvatar(
  //             radius: 14.0,
  //             backgroundColor: Colors.white,
  //             child: Icon(Icons.close, color: Colors.red),
  //           ),
  //         ),
  //       ),
  //     ),
  //     // ElevatedButton(
  //     //   onPressed: () {
  //     //     Get.to(LoginPage());
  //     //   },
  //     //   child: Text("okay"),
  //     // ),
  //   ],
  //   shape:const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.all(Radius.circular(32.0))),
  //   contentPadding:const EdgeInsets.only(top: 10.0),
  //   content: SizedBox(
  //     height: MediaQuery.of(context).size.height/5,
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Container(margin:const EdgeInsets.only(left: 5), child: Text(errorText)),
  //       ],
  //     ),
  //   ),
  // );
  // showDialog(
  //   barrierDismissible: false,
  //   context: context,
  //   builder: (BuildContext context) {
  //     return alert;
  //   },
  // );


  final String errorCross = 'assets/svg/errorCross.svg';

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext cxt) {
      return Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Material(

            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              side: const BorderSide(color: Color(0xffFF7B65), width: 1),),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          errorText,
                          style:const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                          child: SvgPicture.asset(
                            errorCross,
                            fit: BoxFit.scaleDown,
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );


}



//
// import 'package:flutter/material.dart';
//
// class CustomDialog extends StatelessWidget {
//   final String? errorMessage;
//
//   const CustomDialog({Key? key,required this.errorMessage}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
//       elevation: 0.0,
//       backgroundColor: Colors.transparent,
//       child: dialogContent(context),
//     );
//   }
//
//   Widget dialogContent(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(left: 0.0,right: 0.0),
//       child: Stack(
//         children: <Widget>[
//           Container(
//             padding: EdgeInsets.only(
//               top: 18.0,
//             ),
//             margin: EdgeInsets.only(top: 13.0,right: 8.0),
//             decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.primary,
//                 shape: BoxShape.rectangle,
//                 borderRadius: BorderRadius.circular(16.0),
//                 boxShadow: <BoxShadow>[
//                   BoxShadow(
//                     color: Color(0xffFF7B65),
//                     blurRadius: 0.0,
//                     offset: Offset(0.0, 0.0),
//                   ),
//                 ]),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: <Widget>[
//                 SizedBox(
//                   height: 20.0,
//                 ),
//                 Center(
//                     child: Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: new Text(errorMessage!, style:TextStyle(fontSize: 30.0,color: Colors.white)),
//                     )//
//                 ),
//                 SizedBox(height: 24.0),
//                 InkWell(
//                   child: Container(
//                     padding: EdgeInsets.only(top: 15.0,bottom:15.0),
//                     decoration: BoxDecoration(
//                       color:Colors.white,
//                       borderRadius: BorderRadius.only(
//                           bottomLeft: Radius.circular(16.0),
//                           bottomRight: Radius.circular(16.0)),
//                     ),
//                     child:  Text(
//                       "OK",
//                       style: TextStyle(color: Colors.blue,fontSize: 25.0),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   onTap:(){
//                     Navigator.of(context).pop();
//                   },
//                 )
//               ],
//             ),
//           ),
//           Positioned(
//             right: 0.0,
//             child: GestureDetector(
//               onTap: (){
//                 Navigator.of(context).pop();
//               },
//               child: Align(
//                 alignment: Alignment.topRight,
//                 child: CircleAvatar(
//                   radius: 14.0,
//                   backgroundColor: Colors.white,
//                   child: Icon(Icons.close, color: Colors.red),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }