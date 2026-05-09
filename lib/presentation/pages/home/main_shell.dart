import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    int currentIndex = 0;
    if (location.startsWith('/schedule')) currentIndex = 1;
    if (location.startsWith('/bookkeeping')) currentIndex = 2;
    if (location.startsWith('/profile')) currentIndex = 3;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            switch (index) {
              case 0:
                context.go('/home');
              case 1:
                context.go('/schedule');
              case 2:
                context.go('/bookkeeping');
              case 3:
                context.go('/profile');
            }
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '首页'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined), label: '日程'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined), label: '记账'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: '我的'),
        ],
      ),
    );
  }
}