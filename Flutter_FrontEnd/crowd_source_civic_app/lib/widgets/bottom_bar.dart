import 'package:crowd_source_civic_app/Data/value_notifier.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: bottomBarIndex,
      builder: (context, value, child) {
        return NavigationBar(
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.location_on), label: 'Map'),
            NavigationDestination(icon: Icon(Icons.add), label: 'Report'),
            NavigationDestination(icon: Icon(Icons.message), label: 'Message'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          ],
          onDestinationSelected: (value) {
            bottomBarIndex.value = value;
          },
          selectedIndex: value,
        );
      },
    );
  }
}
