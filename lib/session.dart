import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'entities/user.dart';

class Session{

  static late final String id;
  static late final String username;
  static late final bool isAdmin;
  static late UserE CurrentUser;

 static Future<UserE> setUser(UserE user) async
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
    return user;
  }

  static Future<void> SetCurrentUser()
  async {
    var prefs = await SharedPreferences.getInstance().then((value){return value;});
    CurrentUser.id = prefs.getString("id")!;
    CurrentUser.username = prefs.getString("username")!;
    CurrentUser.Rank = prefs.getString("rank")!;
    CurrentUser.isAdmin = prefs.getBool("isAdmin")!;
    CurrentUser.address = prefs.getString("address")!;
    CurrentUser.email = prefs.getString("email")!;
    CurrentUser.birth = prefs.getString("birth")!;
    CurrentUser.level = prefs.getString("level")!;
    CurrentUser.image = prefs.getString("image")!;
    CurrentUser.password = prefs.getString("password")!;
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
  static Future checkFirstSeen(BuildContext context,UserE user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      print("Seen Before");
    } else {
      await prefs.setBool('seen', true);
      await Session.setUser(user);
      print("Never Seen Before");
    }
  }
}