import 'package:crowd_source_civic_app/Data/value_notifier.dart';
import 'package:crowd_source_civic_app/pages/home_page.dart';
import 'package:crowd_source_civic_app/pages/map_page.dart';
import 'package:crowd_source_civic_app/pages/message_page.dart';
import 'package:crowd_source_civic_app/pages/profile_page.dart';
import 'package:crowd_source_civic_app/pages/report_page.dart';
import 'package:crowd_source_civic_app/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  List<Widget> pages = [
    const HomePage(),
    const MapPage(),
    const ReportPage(),
    const MessagePage(),
    const ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: bottomBarIndex,
        builder: (context, value, child) {
          return pages.elementAt(value);
        },
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
