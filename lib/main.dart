import 'package:cardgameapp/controllers/authentication_service.dart';
import 'package:cardgameapp/theme/theme.dart';
import 'package:cardgameapp/views/bug_report_view.dart';
import 'package:cardgameapp/views/collection_view.dart';
import 'package:cardgameapp/views/edit_profile.dart';
import 'package:cardgameapp/views/friendsList.dart';
import 'package:cardgameapp/home.dart';
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
  static const String Appname ="Card Card App";
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
      theme: example(),
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


/*
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( const MyApp());
}

class MyApp extends StatefulWidget {
   const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();

}


class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Game',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
       future: _fbApp,
        builder: (context, snapshot){
         if(snapshot.hasError){
           print("Error! ${snapshot.error.toString()}");
           return const Text("Error");
         }
         else if(snapshot.hasData)
           {
             return const MyHomePage(title: 'Test');
           }
         else {
           return const Center(
             child: CircularProgressIndicator(),
           );
         }
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return users
        .add({
      'full_name': "Elyes", // John Doe
      'company': "Gamix", // Stokes and Sons
      'age': 69 // 42
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
  void _incrementCounter() {
    setState(() {

      addUser();

    });
  }

  @override
  Widget build(BuildContext context) {
    return /*FutureBuilder<DocumentSnapshot>(
      future: users.doc("SbpSsLkvygcax8dz5CbV").get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Text("User: $data");
        }

        return Text("loading");
      },
    );
      */Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
*/




/*DatabaseReference _testRef = FirebaseDatabase.instance.reference().child("Numbers");
      int random = Random().nextInt(100);
      _testRef.child("Anas' Number").set(random);
      _testRef.child("Elyas' Number").set(random+1);
      _counter = random;*/