import 'package:cardgameapp/views/actualite_view.dart';
import 'package:cardgameapp/views/publications_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/authentication_service.dart';
import '../session.dart';

class NavigationTab extends StatelessWidget {
  static const String Appname ="WildDraw";
  const NavigationTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                title: const Text("WildDraw",style: TextStyle(fontFamily: 'Windy-Wood-Demo',fontSize: 30),),
              ),
              ListTile(
                title: Row(
                  children: const [
                    Icon(Icons.assignment_ind),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Profile",style: TextStyle(fontFamily: 'Windy-Wood-Demo',fontSize: 20,fontWeight: FontWeight.w600),),
                  ],
                ),
                onTap: () {
                    Navigator.pushNamed(context, "/profile");
                },
              ),
              ListTile(
                title: Row(
                  children: const [
                    Icon(Icons.supervisor_account_sharp),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Friends List",style: TextStyle(fontFamily: 'Windy-Wood-Demo',fontSize: 20,fontWeight: FontWeight.w600),),
                  ],
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/friends");
                },
              ),
              ListTile(
                title: Row(
                  children: const [
                    Icon(Icons.warning_amber_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Daily quests",style: TextStyle(fontFamily: 'Windy-Wood-Demo',fontSize: 20,fontWeight: FontWeight.w600),),
                  ],
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/DailyQuests");
                },
              ),
              ListTile(
                title: Row(
                  children: const [
                    Icon(Icons.crop_portrait),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Rules and Cards",style: TextStyle(fontFamily: 'Windy-Wood-Demo',fontSize: 20,fontWeight: FontWeight.w600),),
                  ],
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/collection");
                },
              ),
              ListTile(
                title: Row(
                  children: const [
                    Icon(Icons.poll),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Polls",style: TextStyle(fontFamily: 'Windy-Wood-Demo',fontSize: 20,fontWeight: FontWeight.w600),),
                  ],
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/poll");
                },
              ),
              ListTile(
                title: Row(
                  children: const [
                    Icon(Icons.bug_report),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Report Bugs",style: TextStyle(fontFamily: 'Windy-Wood-Demo',fontSize: 20,fontWeight: FontWeight.w600),),
                  ],
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/bugReport");
                },
              ),
              ListTile(
                title: Row(
                  children: const [
                    Icon(Icons.power_settings_new),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Log out",style: TextStyle(fontFamily: 'Windy-Wood-Demo',fontSize: 20,fontWeight: FontWeight.w600),),
                  ],
                ),
                onTap: () {
                  context.read<AuthenticationService>().signOut();
                  Session.clearSession();
                  Navigator.pushReplacementNamed(context, "/singin");
                },
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text(Appname),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.assignment_sharp),
                text: "News",
              ),
              Tab(
                icon: Icon(Icons.wysiwyg),
                text: "Posts",
              ),
              Tab(
                icon: Icon(Icons.assignment_late_outlined),
                text: "More info",
              )
            ],
          ),
        ),
        body: const TabBarView(
          children: [
          actualiteView(),PublicationView(),MoreInfo()
        ],)
      ),
    );
  }
}
