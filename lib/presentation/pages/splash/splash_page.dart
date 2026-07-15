import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          context.go('/home');
        } else if (state.status == AuthStatus.unauthenticated) {
          context.go('/login');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.lg),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  border: Border(
                    top: BorderSide(color: AppColors.borderLight, width: AppDimensions.pixelBorder),
                    left: BorderSide(color: AppColors.borderLight, width: AppDimensions.pixelBorder),
                    right: BorderSide(color: AppColors.borderDark, width: AppDimensions.pixelBorder),
                    bottom: BorderSide(color: AppColors.borderDark, width: AppDimensions.pixelBorder),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 48,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: AppDimensions.md),
                    Text(
                      'PRIVATE',
                      style: GoogleFonts.pressStart2p(
                        fontSize: 18,
                        color: AppColors.primary,
                        height: 1.5,
                      ),
                    ),
                    Text(
                      'BUTLER',
                      style: GoogleFonts.pressStart2p(
                        fontSize: 18,
                        color: AppColors.accent,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.xl),
              Text(
                'NOW LOADING...',
                style: GoogleFonts.pressStart2p(
                  fontSize: 8,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimensions.md),
              SizedBox(
                width: 32,
                height: 32,
                child: CustomPaint(
                  painter: _PixelSpinnerPainter(),
                  size: const Size(32, 32),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PixelSpinnerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.accent;
    const blockSize = 8.0;

    const positions = [
      Offset(0, 0), Offset(8, 0), Offset(16, 0), Offset(24, 0),
      Offset(24, 8), Offset(24, 16), Offset(24, 24),
      Offset(16, 24), Offset(8, 24), Offset(0, 24),
      Offset(0, 16), Offset(0, 8),
    ];

    final now = DateTime.now().millisecondsSinceEpoch;
    final visibleCount = ((now ~/ 100) % 12) + 1;

    for (int i = 0; i < visibleCount && i < positions.length; i++) {
      final pos = positions[i];
      canvas.drawRect(
        Rect.fromLTWH(pos.dx, pos.dy, blockSize, blockSize),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
