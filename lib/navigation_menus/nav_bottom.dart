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
              title: const Text("G-Store ESPRIT"),
            ),
            ListTile(
              title: Row(
                children: const [
                  Icon(Icons.edit),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Modifier profil"),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(context, "/home/updateUser");
              },
            ),
            ListTile(
              title: Row(
                children: const [
                  Icon(Icons.tab),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Navigation par onglet"),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(context, "/home/navTab");
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
              onTap: () async{

              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("G-Store ESPRIT"),
      ),
      body: _interfaces[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: "Store",
            icon: Icon(Icons.home)
          ),
          BottomNavigationBarItem(
              label: "Bibliothèque",
              icon: Icon(Icons.article)
          ),
          BottomNavigationBarItem(
              label: "Panier",
              icon: Icon(Icons.shopping_basket_rounded)
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
