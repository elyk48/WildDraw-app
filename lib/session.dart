 import 'package:shared_preferences/shared_preferences.dart';

import 'entities/user.dart';

class Session{

  static late final String id;
  static late final String username;
  static late final bool isAdmin;

 static Future<void> setUser(UserE user) async
  {
    var prefs = await SharedPreferences.getInstance().then((value){return value;});
    user.id = prefs.getString("id")!;
    user.username = prefs.getString("username")!;
    user.Rank = prefs.getString("rank")!;
    user.isAdmin = prefs.getBool("isAdmin")!;
    user.address = prefs.getString("address")!;
    user.email = prefs.getString("email")!;
    user.birth = prefs.getString("birth")!;
    user.level = prefs.getString("level")!;
    user.image = prefs.getString("image")!;
    user.password = prefs.getString("password")!;
    print("From Session class Username is : "+user.username+" isAdmin: "+user.isAdmin.toString()+" Rank: "+user.Rank+" image: "+user.image);
  }
  static Future<void> clearSession() async
  {
    var prefs = await SharedPreferences.getInstance().then((value){return value;});
    prefs.setString("id", "");
    prefs.setString("email", "");
    prefs.setString("rank", "");
    prefs.setString("address", "");
    prefs.setString("birth", "");
    prefs.setBool("isAdmin", false);
    prefs.setString("username", "");
    prefs.setString("rerolledDate", "");
    prefs.setString("password", "");
    prefs.setBool("rerolled", false);
  }

}