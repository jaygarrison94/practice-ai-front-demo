import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class PixelNavItem {
  final IconData icon;
  final String label;
  final String path;

  const PixelNavItem({
    required this.icon,
    required this.label,
    required this.path,
  });
}

const _navItems = [
  PixelNavItem(icon: Icons.home_outlined, label: 'HOME', path: '/home'),
  PixelNavItem(icon: Icons.calendar_today_outlined, label: 'CAL', path: '/schedule'),
  PixelNavItem(icon: Icons.receipt_long_outlined, label: 'BOOK', path: '/bookkeeping'),
  PixelNavItem(icon: Icons.person_outline, label: 'PROFILE', path: '/profile'),
];

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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border(
            top: BorderSide(color: AppColors.borderLight, width: AppDimensions.pixelBorder),
          ),
        ),
        child: Row(
          children: List.generate(_navItems.length, (index) {
            final item = _navItems[index];
            final isSelected = index == currentIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () => context.go(item.path),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.backgroundLight : AppColors.background,
                    border: isSelected
                        ? null
                        : Border(
                            right: BorderSide(color: AppColors.borderDark, width: 1),
                          ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item.icon,
                        size: 18,
                        color: isSelected ? AppColors.accent : AppColors.textSecondary,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: GoogleFonts.pressStart2p(
                          fontSize: 6,
                          color: isSelected ? AppColors.accent : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
