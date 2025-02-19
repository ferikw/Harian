import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harian/common/app_color.dart';
import 'package:harian/presentasion/pages/agenda/all_agenda_page.dart';
import 'package:harian/presentasion/pages/fragments/analytic_fragment.dart';
import 'package:harian/presentasion/pages/fragments/home_fragment.dart';
import 'package:harian/presentasion/pages/fragments/solution_fragment.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import '../pages/emegency_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  static const routeName = '/dashboard';

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final navIndex = 0.obs;

  final List<Map<String, dynamic>> menu = [
    {
      'icon': Icons.home_outlined,
      'view': const HomeFragment(),
    },
    {
      'icon': Icons.bar_chart_outlined,
      'view': const AnalyticFragment(),
    },
    {
      'icon': Icons.date_range_outlined,
      'view': const AllAgendaPage(),
    },
    {
      'icon': Icons.book_outlined,
      'view': const SolutionFragment(),
    },
    {
      'icon': Icons.star_border_outlined,
      'view': const EmergencyPage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Obx(() {
        return menu[navIndex.value]['view'] as Widget;
      }),
      bottomNavigationBar: buildCircleNavBar(),
    );
  }

  Widget buildCircleNavBar() {
    return Obx(() {
      return CircleNavBar(
        activeIndex: navIndex.value,
        onTap: (int newIndex) {
          navIndex.value = newIndex;
        },
        activeIcons: [
          Icon(Icons.home, color: const Color.fromARGB(255, 255, 255, 255)),
          Icon(Icons.bar_chart,
              color: const Color.fromARGB(255, 255, 255, 255)),
          Icon(Icons.date_range_outlined,
              color: const Color.fromARGB(255, 255, 255, 255)),
          Icon(Icons.book_outlined,
              color: const Color.fromARGB(255, 255, 255, 255)),
          Icon(Icons.star_border_outlined,
              color: const Color.fromARGB(255, 255, 255, 255)),
        ],
        inactiveIcons: [
          Icon(Icons.home_outlined, color: Colors.grey),
          Icon(Icons.bar_chart_outlined, color: Colors.grey),
          Icon(Icons.date_range_outlined, color: Colors.grey),
          Icon(Icons.book_outlined, color: Colors.grey),
          Icon(Icons.star_border_outlined, color: Colors.grey),
        ],
        height: 60,
        circleWidth: 60,
        color: Colors.white,
        circleColor: Colors.purple,
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
        shadowColor: AppColor.primary.withOpacity(0.5),
        circleShadowColor: AppColor.primary.withOpacity(0.8),
        elevation: 10,
      );
    });
  }
}
