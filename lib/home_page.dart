import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:meet_dashes/connections_page.dart';
import 'package:meet_dashes/profile_page.dart';
import 'package:meet_dashes/qr_code_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: const [
          ConnectionsPage(),
          ProfilePage(),
        ],
      ),
      floatingActionButton: OpenContainer(
        transitionType: ContainerTransitionType.fade,
        openBuilder: (context, action) {
          return const QrCodePage();
        },
        closedElevation: 6.0,
        closedShape: const CircleBorder(),
        closedBuilder: (context, action) {
          return Container(
            height: 56,
            width: 56,
            color: const Color(0xffBD111A),
            child: const Center(
              child: Icon(
                Icons.qr_code,
                color: Colors.white,
              ),
            ),
          );
        },
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: const [
          Icons.people,
          Icons.person,
        ],
        activeIndex: index,
        activeColor: const Color(0xff04162E),
        inactiveColor: Colors.grey,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) {
          setState(() {
            this.index = index;
          });
        },
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: index,
      //   onTap: (value) {
      //     setState(() {
      //       index = value;
      //     });
      //   },
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.people),
      //       label: 'Conexiones',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Perfil',
      //     ),
      //   ],
      // ),
    );
  }
}
