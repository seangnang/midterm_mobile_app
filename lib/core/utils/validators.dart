class Validators {
  static String? validateRequired(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email or username is required';
    }
    final trimmed = value.trim();
    // Allow username or email for flexibility
    if (trimmed.contains('@')) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(trimmed)) {
        return 'Please enter a valid email address';
      }
    } else {
      if (trimmed.length < 3) {
        return 'Username must be at least 3 characters';
      }
    }
    return null;
  }

  static String? validateStrictEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    final trimmed = value.trim();
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(trimmed)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final trimmed = value.trim();
    final phoneRegex = RegExp(r'^\+?[0-9\s\-\(\)]{7,20}$');
    if (!phoneRegex.hasMatch(trimmed)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? validateNumber(String? value, [String fieldName = 'Value']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    final parsed = num.tryParse(value.trim());
    if (parsed == null || parsed < 0) {
      return '$fieldName must be a valid positive number';
    }
    return null;
  }
}

