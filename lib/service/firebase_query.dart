import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:personal_finance_management/constants/svg_constant.dart';

import '../pages/Login & SignUp/login.dart';

class AuthService{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //Get Uid
  Future<String> getCurrentUid() async {
    final User user = _firebaseAuth.currentUser!;
    final String uid = user.uid.toString();
    storageContainer.write('uid', uid);
    return uid;
  }

  //Get Username
   getCurrentName() async {
    final User user = _firebaseAuth.currentUser!;
    final String uName = user.displayName.toString();
    return uName;
  }

  //Logout
  logOut() async {
    await FirebaseAuth.instance.signOut().then((_) {
      Get.to(() => const LoginPage());
    });
  }

  //Get Currency
  // getCurrency() async {
  //   final CollectionReference _currencyCollection = FirebaseFirestore.instance.collection('currency');
  //   final snapshot = await _currencyCollection.doc('INR').get();
  //   final data = snapshot.data() as Map<String, dynamic>;
  //   // print(data['code']);
  //   return data['code'];
  // }


  // // GET UID
  // Future<String> getCurrentUID() async {
  //   return (_firebaseAuth.currentUser).uid;
  // }
}



