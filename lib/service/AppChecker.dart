import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  MySharedPreferences._privateConstructor();

  static firstRunCheck() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    const String hasRunBeforePrefKey = 'localStorage.hasRunBefore';
    final bool hasRunBefore = sharedPreferences.getBool(hasRunBeforePrefKey) ?? false;

    if(hasRunBefore){
      return;
    }
    await sharedPreferences.setBool(hasRunBeforePrefKey, true);

    User? currentUser = FirebaseAuth.instance.currentUser;
    if(currentUser !=null){
      await FirebaseAuth.instance.signOut();
    }
  }

  static final MySharedPreferences instance =
  MySharedPreferences._privateConstructor();
  setBooleanValue(String key, bool value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setBool(key, value);
  }

  Future<bool> getBooleanValue(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getBool(key) ?? false;
  }
}