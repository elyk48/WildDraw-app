import 'package:cardgameapp/views/actualite_view.dart';
import 'package:cardgameapp/views/publications_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../authentication_service.dart';

class NavigationTab extends StatelessWidget {
  static const String Appname ="Card Card App";
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
                title: const Text(Appname),
              ),
              ListTile(
                title: Row(
                  children: const [
                    Icon(Icons.assignment_ind),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Profile"),
                  ],
                ),
                onTap: () {

                },
              ),
              ListTile(
                title: Row(
                  children: const [
                    Icon(Icons.supervisor_account_sharp),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Friends List"),
                  ],
                ),
                onTap: () {

                },
              ),
              ListTile(
                title: Row(
                  children: const [
                    Icon(Icons.warning_amber_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Daily quests"),
                  ],
                ),
                onTap: () {

                },
              ),
              ListTile(
                title: Row(
                  children: const [
                    Icon(Icons.crop_portrait),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Card Collection"),
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
                    Text("Polls"),
                  ],
                ),
                onTap: () {

                },
              ),
              ListTile(
                title: Row(
                  children: const [
                    Icon(Icons.bug_report),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Report Bugs"),
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
                    Text("Se déconnecter"),
                  ],
                ),
                onTap: () {
                  context.read<AuthenticationService>().signOut();
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
                text: "Actualités",
              ),
              Tab(
                icon: Icon(Icons.wysiwyg),
                text: "Publication",

              ),
              Tab(
                icon: Icon(Icons.attach_money),
                text: "Market Place",
              )
            ],
          ),
        ),
        body: const TabBarView(
        children: [
          actualiteView(),PublicationView(),Center(child: Text("On Going...", textScaleFactor: 2))
        ],
      ),
      ),
    );
  }
}
