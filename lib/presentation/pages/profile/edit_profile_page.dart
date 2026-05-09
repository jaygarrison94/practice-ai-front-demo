import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/message_bloc_listener.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  String _gender = '未设置';
  DateTime? _birthday;
  String? _avatarPath;

  final _genders = ['未设置', '男', '女'];

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('选择头像'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, ImageSource.camera),
            child: const Text('拍照'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, ImageSource.gallery),
            child: const Text('从相册选择'),
          ),
        ],
      ),
    );
    if (source != null) {
      final picked = await picker.pickImage(source: source, maxWidth: 500);
      if (picked != null) {
        setState(() => _avatarPath = picked.path);
      }
    }
  }

  void _onSave() {
    if (_formKey.currentState?.validate() != true) return;

    context.read<AuthBloc>().add(UpdateProfile(
          nickname: _nicknameController.text,
          avatar: _avatarPath,
          gender: _gender,
          birthday: _birthday?.toIso8601String(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MessageBlocListener<AuthBloc, AuthState>(
      popOnSuccess: true,
      child: Scaffold(
        appBar: AppBar(title: const Text(AppStrings.editProfile)),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: AppDimensions.lg),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: AppColors.primaryLight,
                    backgroundImage: _avatarPath != null
                        ? FileImage(File(_avatarPath!))
                        : null,
                    child: _avatarPath == null
                        ? const Icon(Icons.camera_alt, size: 32, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: _pickImage,
                  child: const Text('点击更换头像'),
                ),
                const SizedBox(height: AppDimensions.lg),
                AppTextField(
                  controller: _nicknameController,
                  labelText: AppStrings.nickname,
                  hintText: '请输入昵称',
                  maxLength: 10,
                  validator: Validators.validateNickname,
                ),
                const SizedBox(height: AppDimensions.md),
                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: const InputDecoration(labelText: AppStrings.gender),
                  items: _genders
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (v) => setState(() => _gender = v ?? '未设置'),
                ),
                const SizedBox(height: AppDimensions.md),
                ListTile(
                  leading: const Icon(Icons.cake),
                  title: const Text(AppStrings.birthday),
                  trailing: Text(
                    _birthday != null
                        ? '${_birthday!.year}-${_birthday!.month}-${_birthday!.day}'
                        : '未设置',
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _birthday ?? DateTime(2000),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) setState(() => _birthday = date);
                  },
                ),
                const SizedBox(height: AppDimensions.xl),
                AppButton(text: AppStrings.save, onPressed: _onSave),
              ],
            ),
          ),
        ),
      ),
    );
  }
}