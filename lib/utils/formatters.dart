import 'package:flutter/services.dart';

/// This is a PhoneNumberFormatter used in /auth/phone.
/// It ensures that the user's number input will be displayed in the format "(123)-456-7890"
class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // No need to use oldValue here
    final text = newValue.text;
    if (text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final formattedText = _formatPhoneNumber(text);
    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _formatPhoneNumber(String phoneNumber) {
    phoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');
    if (phoneNumber.length <= 3) {
      return '(${phoneNumber.substring(0, phoneNumber.length)}';
    } else if (phoneNumber.length <= 6) {
      return '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, phoneNumber.length)}';
    } else if (phoneNumber.length <= 10){
      return '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)}-${phoneNumber.substring(6, phoneNumber.length)}';
    } else {
      return '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)}-${phoneNumber.substring(6, 10)}';
    }
  }
}