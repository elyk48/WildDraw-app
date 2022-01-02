import 'package:cardgameapp/controllers/authentication_service.dart';
import 'package:cardgameapp/theme.dart';
import 'package:cardgameapp/views/bug_report_view.dart';
import 'package:cardgameapp/views/collection_view.dart';
import 'package:cardgameapp/views/edit_profile.dart';
import 'package:cardgameapp/views/friendsList.dart';
import 'package:cardgameapp/views/poll_view.dart';
import 'package:cardgameapp/views/profile.dart';
import 'package:cardgameapp/views/searchfriend.dart';
import 'package:cardgameapp/signin.dart';
import 'package:cardgameapp/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'views/create_a_poll.dart';
import 'views/create_quest.dart';
import 'views/daily_quests_view.dart';
import 'navigation_menus/nav_tab.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);
  static const String Appname ="WildDraw";
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Make multiple Widgets with Providers
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_)=>AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        )
      ],
      child:MaterialApp(
        title: Appname,
        debugShowCheckedModeBanner: false,
        routes: // <- Routes
        {

          "/singin":(BuildContext context){
            return SignInPage();
          },
          "/signup":(BuildContext context){
            return Signup();
          },
          "/profile":(BuildContext context){
            return Profile();
          },
          "/home":(BuildContext context){
            return NavigationTab();
          },
          "/editProfile":(BuildContext context){
            return EditProfile();
          },
          "/friends":(BuildContext context){
            return FriendsList();
          },
          "/searchfriends":(BuildContext context){
            return SearchFriend();
          },
          "/poll":(BuildContext context){
            return MyPollDisplay();
          },
          "/createpoll":(BuildContext context){
            return MyPollCreate2();
          },
          "/createQuest":(BuildContext context){
            return CreateQuest();
          },

          "/DailyQuests":(BuildContext context){
            return DailyQuests();
          },
          "/bugReport":(BuildContext context){
            return BugReportView();
          },
          "/navTab":(BuildContext context){
            return NavigationTab();
          },
          "/collection":(BuildContext context){
            return CollectionView();
          },


        },
        theme: CustomDataTheme(),
        home: const AuthenticationWrapper(key: null),
      ),);
  }
}
class AuthenticationWrapper extends StatelessWidget{
  const AuthenticationWrapper({
    Key? key,
  }): super(key:key);

  @override
  Widget build(BuildContext context){
    final firebaseUser = context.watch<User?>();
    if(firebaseUser!= null){
      return const NavigationTab();
    }
    return SignInPage();
  }
}