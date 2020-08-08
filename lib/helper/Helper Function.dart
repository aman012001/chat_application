import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction{
    static String sharedPreferenceUserLoggedInkey ="ISLOGGEDIN";
    static String sharedPreferenceUsernamekey ="USERNAME";
    static String sharedPreferenceUserEmailkey = "USEREMAIL";
    static String sharedPreferenceUserOnlinekey = "ISONLINE";
    //saving data to SharedPreference

  static Future<void> saveUserLoggedInSharedPreference(bool isUserLoggedIn) async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceUserLoggedInkey, isUserLoggedIn);
  }

  static Future<void> saveUserNameSharedPreference(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUsernamekey, userName);
  }
  static Future<void> saveUserEmailSharedPreference(String userEmail) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setString(sharedPreferenceUserEmailkey, userEmail);
  }

// getting data from SharedPreferences

   static Future<bool> getUserLoggedInSharedPreference() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return await prefs.getBool(sharedPreferenceUserLoggedInkey);
   }
  static Future<String> getUserNameSharedPreference() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferenceUsernamekey);
  }

  static Future<String> getUserEmailSharedPreference() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferenceUserEmailkey);
  }



}
