import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_skin.dart';
import '../../../core/theme/skin_controller.dart';
import '../../../core/widgets/app_button.dart';

class SkinSettingsPage extends StatefulWidget {
  const SkinSettingsPage({super.key});

  @override
  State<SkinSettingsPage> createState() => _SkinSettingsPageState();
}

class _SkinSettingsPageState extends State<SkinSettingsPage> {
  late AppSkin _selectedSkin;

  @override
  void initState() {
    super.initState();
    _selectedSkin = SkinController.instance.skin;
  }

  Future<void> _transform() async {
    await SkinController.instance.setSkin(_selectedSkin);
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final controller = SkinController.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('主题皮肤')),
      body: Column(
        children: [
          Expanded(
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                return ListView.separated(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  itemCount: AppSkins.all.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppDimensions.md),
                  itemBuilder: (context, index) {
                    final skin = AppSkins.all[index];
                    final selected = skin.id == _selectedSkin.id;
                    return _SkinCard(
                      skin: skin,
                      selected: selected,
                      onTap: () => setState(() => _selectedSkin = skin),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: AppButton(
              text: '变身',
              onPressed: _transform,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkinCard extends StatelessWidget {
  final AppSkin skin;
  final bool selected;
  final VoidCallback onTap;

  const _SkinCard({
    required this.skin,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: skin.backgroundLight,
          border: Border(
            top: BorderSide(color: skin.borderLight, width: AppDimensions.pixelBorder),
            left: BorderSide(color: skin.borderLight, width: AppDimensions.pixelBorder),
            right: BorderSide(color: skin.borderDark, width: AppDimensions.pixelBorder),
            bottom: BorderSide(color: skin.borderDark, width: AppDimensions.pixelBorder),
          ),
        ),
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Row(
          children: [
            _PalettePreview(skin: skin),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    skin.name,
                    style: TextStyle(
                      fontSize: 16,
                      color: skin.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  Text(
                    skin.description,
                    style: TextStyle(fontSize: 12, color: skin.textSecondary),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? skin.accent : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _PalettePreview extends StatelessWidget {
  final AppSkin skin;

  const _PalettePreview({required this.skin});

  @override
  Widget build(BuildContext context) {
    final colors = [skin.primary, skin.accent, skin.income, skin.expense];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: colors
          .map(
            (color) => Container(
              width: 18,
              height: 42,
              color: color,
            ),
          )
          .toList(),
    );
  }
}
