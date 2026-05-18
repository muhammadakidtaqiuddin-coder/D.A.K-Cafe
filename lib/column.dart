import 'package:flutter/material.dart';
import 'package:flutter_application_3/home.dart';
import 'package:flutter_application_3/media.dart';
import 'package:flutter_application_3/profile.dart';


class ColumnPage extends StatefulWidget {
  const ColumnPage({super.key});

  @override
  State<ColumnPage> createState() => _ColumnPageState();             //stateful 
}

class _ColumnPageState extends State<ColumnPage> {
  int currentIndex = 0;   //on which page are we

 final List<Widget> pages = [
     const HomePage(),
  const MediaPage(),
  const ProfilePage(),  //nak panggil daripada file lain
  ];

/*Container(
      color: Colors.cyanAccent,
      child: const Center(
        child: Text("Welcome"),
      ),
    ),
    Container(
      color: Colors.amberAccent,
      child: const Center(
        child: Text("Media Page"),
      ),
    ),
    Container(
      color: Colors.lightGreenAccent,
      child: const Center(
        child: Text("Profile Page"),
      ),
    ), */


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bottom Navigation'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.redAccent,
              ),
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.perm_media_outlined),
              title: const Text('media'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MediaPage(),
                  )
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

          ],
        ),
      ),
      body: pages[currentIndex],    //based on index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,     //which page
        onTap: (index) {      //return number
          setState(() {         //ui update when data change
            currentIndex = index;
          });
        },
        items: const [        //button
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Media',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}