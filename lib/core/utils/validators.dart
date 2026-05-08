class Validators {
  Validators._();

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入手机号';
    }
    final regex = RegExp(r'^1[3-9]\d{9}$');
    if (!regex.hasMatch(value)) {
      return '请输入正确的手机号';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入密码';
    }
    if (value.length < 6) {
      return '密码长度不能少于6位';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return '请确认密码';
    }
    if (value != password) {
      return '两次密码不一致，请重新输入';
    }
    return null;
  }

  static String? validateSmsCode(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入验证码';
    }
    if (value.length != 6) {
      return '请输入6位验证码';
    }
    return null;
  }

  static String? validateNickname(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入昵称';
    }
    if (value.length > 10) {
      return '昵称长度需1-10个字符';
    }
    return null;
  }

  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入金额';
    }
    final amount = double.tryParse(value);
    if (amount == null) {
      return '请输入正确的金额';
    }
    if (amount <= 0) {
      return '金额需大于0';
    }
    if (amount > 999999.99) {
      return '金额不能超过999999.99';
    }
    return null;
  }

  static String? validateScheduleTitle(String? value) {
    if (value == null || value.isEmpty) {
      return '请填写日程标题';
    }
    return null;
  }

  static PasswordStrength checkPasswordStrength(String password) {
    if (password.length < 6) return PasswordStrength.weak;

    bool hasLetter = password.contains(RegExp(r'[a-zA-Z]'));
    bool hasDigit = password.contains(RegExp(r'\d'));
    bool hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (hasLetter && hasDigit && hasSpecial && password.length >= 8) {
      return PasswordStrength.strong;
    }
    if ((hasLetter || hasDigit) && password.length >= 6) {
      return PasswordStrength.medium;
    }
    return PasswordStrength.weak;
  }
}

enum PasswordStrength { weak, medium, strong }
