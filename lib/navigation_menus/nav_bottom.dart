import 'package:flutter/material.dart';


class NavigationBottom extends StatefulWidget {
  const NavigationBottom({Key? key}) : super(key: key);

  @override
  State<NavigationBottom> createState() => _NavigationBottomState();
}

class _NavigationBottomState extends State<NavigationBottom> {
  int _currentIndex = 0;
  final List<Widget> _interfaces = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              title: const Text(""),
            ),
            ListTile(
              title: Row(
                children: const [
                  Icon(Icons.message),
                  SizedBox(
                    width: 10,
                  ),
                  Text(""),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(context, "/");
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text(""),
      ),
      body: _interfaces[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: "",
            icon: Icon(Icons.message)
          ),
          BottomNavigationBarItem(
              label: "",
              icon: Icon(Icons.wysiwyg)
          )
        ],
        currentIndex: _currentIndex,
        onTap: (int value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
    );
  }
}
