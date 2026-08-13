import 'package:flutter/material.dart';

class General {
  // Define FocusNode
  fieldFocusChange(
    BuildContext context,
    FocusNode currentFocus,
    FocusNode nextFocus,
  ) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  //=======check Format Id_exp_spen , code_bud_rtarf============
  bool validateIdExpSpen(String input) {
    // Define the regular expression for the format "xx-x-xxx-xx-xx-xx"
    final pattern = RegExp(r'^\d{2}-\d-\d{3}-\d{2}-\d{2}-\d{2}$');

    // Check if the input matches the pattern
    return pattern.hasMatch(input);
  }

  bool validateCodeBudRTARF(String input) {
    // Check if string is empty or null
    if (input.isEmpty) {
      return false;
    }

    // Split the string by hyphens
    final parts = input.split('-');

    // Check if we have correct number of parts
    if (parts.length != 9) {
      return false;
    }

    // Define expected lengths and patterns for each part
    final validations = [
      {'length': 2, 'isNumeric': true, 'allowXX': false}, // 68
      {'length': 2, 'isNumeric': true, 'allowXX': false}, // 01
      {'length': 2, 'isNumeric': true, 'allowXX': false}, // 02
      {'length': 2, 'isNumeric': true, 'allowXX': false}, // 02
      {'length': 2, 'isNumeric': true, 'allowXX': false}, // 01
      {
        'length': 2,
        'isNumeric': false,
        'allowXX': true,
      }, // xx (can be any two characters)
      {'length': 4, 'isNumeric': true, 'allowXX': false}, // 2000
      {'length': 5, 'isNumeric': true, 'allowXX': false}, // 10078
      {'length': 2, 'isNumeric': true, 'allowXX': false}, // 12
    ];

    // Validate each part
    for (int i = 0; i < parts.length; i++) {
      final part = parts[i];
      final validation = validations[i];

      // Check length
      if (part.length != validation['length']) {
        return false;
      }

      // Check if part should be numeric
      if (validation['isNumeric'] as bool && !_isNumeric(part)) {
        return false;
      }

      // Special check for "xx" part - already handled by length check
      if (validation['allowXX'] as bool && part.length != 2) {
        return false;
      }
    }

    return true;
  }

  // Helper function to check if a string is numeric
  bool _isNumeric(String str) {
    return double.tryParse(str) != null;
  }

  bool checkCharAtPosition(String input, String charToCheck, String position) {
    // Check if the string is not empty
    if (input.isEmpty) {
      return false;
    }

    // Check if charToCheck is exactly one character
    if (charToCheck.length != 1) {
      return false;
    }

    // Check if the specified position is 'left' (first character) or 'right' (last character)
    if (position.toLowerCase() == "left") {
      // Check if the character is at the left (first) position
      return input[0] == charToCheck;
    } else if (position.toLowerCase() == "right") {
      // Check if the character is at the right (last) position
      return input[input.length - 1] == charToCheck;
    } else {
      // Invalid position input, return false
      return false;
    }
  }

  bool checkStringAtPosition(
    String input,
    String substringToCheck,
    String position,
  ) {
    // Check if the string is not empty
    if (input.isEmpty || substringToCheck.isEmpty) {
      return false;
    }

    // Check if the specified position is 'left' (first position) or 'right' (last position)
    if (position.toLowerCase() == "left") {
      // Check if the substring exists at the left (beginning) of the string
      return input.startsWith(substringToCheck);
    } else if (position.toLowerCase() == "right") {
      // Check if the substring exists at the right (end) of the string
      return input.endsWith(substringToCheck);
    } else {
      // Invalid position input, return false
      return false;
    }
  }

  String removeCharFromString(String input, String charToRemove) {
    // Check if the string is not empty
    if (input.isEmpty) {
      return input;
    }

    // Use the String.replaceAll method to remove all occurrences of the specified character
    return input.replaceAll(charToRemove, '');
  }

  String addCommas(String input) {
    // Check if the string is empty or null
    if (input.isEmpty) {
      return input;
    }

    // Remove any existing commas first
    String cleanInput = input.replaceAll(',', '');

    // Check if it's a valid number
    if (double.tryParse(cleanInput) == null) {
      return input; // Return original if not a valid number
    }

    // Handle decimal numbers
    List<String> parts = cleanInput.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

    // Add commas to integer part
    String result = '';
    int count = 0;

    // Process from right to left
    for (int i = integerPart.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) {
        result = ',$result';
      }
      result = integerPart[i] + result;
      count++;
    }

    return result + decimalPart;
  }

  // Alternative method using NumberFormat (requires intl package)
  String addCommasWithFormat(String input) {
    // Check if the string is empty
    if (input.isEmpty) {
      return input;
    }

    // Remove any existing commas
    String cleanInput = input.replaceAll(',', '');

    // Try to parse as number
    double? number = double.tryParse(cleanInput);
    if (number == null) {
      return input; // Return original if not a valid number
    }

    // Format with commas (you'll need to add 'intl: ^0.18.0' to pubspec.yaml)
    // import 'package:intl/intl.dart';
    // final formatter = NumberFormat('#,###.##');
    // return formatter.format(number);

    // For now, use the manual method above
    return addCommas(cleanInput);
  }

  String removeCommas(String input) {
    return input.replaceAll(',', '');
  }

  String removeBlank(String input) {
    return input.replaceAll(' ', '');
  }

  //================================================
  void delay(int sec, Function() function1) {
    Future.delayed(Duration(seconds: sec), () {
      function1(); // Call the provided function after the delay
    });
  }

  //================================================
  String formatPhoneNumber(dynamic phoneNumber) {
    // Check if phoneNumber is null
    if (phoneNumber == null) {
      return '';
    }

    // Convert to string and extract only digits
    String phoneStr = phoneNumber.toString();
    String cleaned = phoneStr.replaceAll(RegExp(r'[^0-9]'), '');

    // Format based on length
    if (cleaned.length == 10) {
      // Format as xxx-xxx-xxxx
      return '${cleaned.substring(0, 3)}-${cleaned.substring(3, 6)}-${cleaned.substring(6)}';
    } else if (cleaned.length == 9) {
      // Format as xx-xxx-xxxx
      return '${cleaned.substring(0, 2)}-${cleaned.substring(2, 5)}-${cleaned.substring(5)}';
    } else {
      // Return original string if length doesn't match expected formats
      return phoneNumber.toString();
    }
  }

  //======format currency string====================

  String formatCurrency(String amount) {
    // Check if the string is empty or null
    if (amount.isEmpty) {
      return amount;
    }

    // Remove any existing commas first
    String cleanAmount = amount.replaceAll(',', '');

    // Try to parse as number
    double? number = double.tryParse(cleanAmount);
    if (number == null) {
      return amount; // Return original if not a valid number
    }

    // Format using internal formatter as a fallback (avoids calling undefined 'format' on CurrencyFormat)
    return addCommas(cleanAmount);
  }

  //================================================
  String leftString(String str, int cnt) {
    // Check if string is null or empty
    if (str.isEmpty) {
      return '';
    }

    // Check if count is valid
    if (cnt <= 0) {
      return '';
    }

    // Check if count is greater than string length
    if (cnt >= str.length) {
      return str;
    }

    return str.substring(0, cnt);
  }

  String rightString(String str, int cnt) {
    // Check if string is null or empty
    if (str.isEmpty) {
      return '';
    }

    // Check if count is valid
    if (cnt <= 0) {
      return '';
    }

    // Check if count is greater than string length
    if (cnt >= str.length) {
      return str;
    }

    int strLength = str.length;
    int startStr = strLength - cnt;
    return str.substring(startStr, strLength);
  }

  //================================================
  // Function to check if TextEditingControllers are not empty
  bool checkControllersNotEmpty(List<TextEditingController> controllers) {
    bool isValid = true;

    for (TextEditingController controller in controllers) {
      if (controller.text.trim().isEmpty) {
        isValid = false;
        // Note: Visual feedback would be handled differently in Flutter
        // You would typically use a state management solution or callbacks
      }
    }

    return isValid;
  }

  /*
 // Create some test controllers
  List<TextEditingController> testControllers = [
    TextEditingController(text: "Valid text"),
    TextEditingController(text: ""), // Empty
    TextEditingController(text: "   "), // Only whitespace
    TextEditingController(text: "Another valid"),
  ];
// Test basic validation
  bool allValid = checkControllersNotEmpty(testControllers);
  print("All controllers valid: $allValid");
 */

  // Alternative approach using a callback for visual feedback
  bool checkControllersWithCallback(
    List<TextEditingController> controllers,
    Function(int index, bool isValid) onValidationChanged,
  ) {
    bool isValid = true;

    for (int i = 0; i < controllers.length; i++) {
      TextEditingController controller = controllers[i];
      bool fieldValid = controller.text.trim().isNotEmpty;

      if (!fieldValid) {
        isValid = false;
      }

      // Call the callback to handle visual feedback
      onValidationChanged(i, fieldValid);
    }

    return isValid;
  }
  /*
 // Test with callback for visual feedback
  print("\nValidation with feedback:");
  bool validWithCallback = checkControllersWithCallback(
    testControllers,
    (index, isValid) {
      print("Controller $index is ${isValid ? 'valid' : 'invalid'}");
    },
  );
  print("Overall valid: $validWithCallback");
  
  // Clean up controllers
  for (var controller in testControllers) {
    controller.dispose();
  }
  
*/

  //================================================

  // Function to check TextFormField validation with visual feedback
  bool checkTextFormFieldsNotEmpty(
    List<TextEditingController> controllers,
    List<GlobalKey<FormFieldState>> formKeys,
  ) {
    bool isValid = true;

    for (int i = 0; i < controllers.length; i++) {
      TextEditingController controller = controllers[i];

      if (controller.text.trim().isEmpty) {
        isValid = false;

        // Trigger validation on the FormField to show error
        if (i < formKeys.length) {
          formKeys[i].currentState?.validate();
        }
      }
    }

    return isValid;
  }

  //================================================
}

/*
// Usage examples:
void main() {
  // Test validateIdExpSpen
  String testId = "12-3-456-78-90-12";
  bool isValidId = validateIdExpSpen(testId);
  print("ID format valid: $isValidId");
  
  // Test validateCodeBudRTARF
  String testCode = "68-01-02-02-01-xx-2000-10078-12";
  bool isValidCode = validateCodeBudRTARF(testCode);
  print("Code format valid: $isValidCode");
  
  // Test character position checking
  bool hasAAtStart = checkCharAtPosition("Apple", "A", "left");
  print("'Apple' starts with 'A': $hasAAtStart");
  
  // Test string position checking
  bool startsWithHello = checkStringAtPosition("Hello World", "Hello", "left");
  print("'Hello World' starts with 'Hello': $startsWithHello");
  
   // Test comma addition
  String withCommas = addCommas("1000000");
  print("Added commas to '1000000': $withCommas");
  
  String withCommasDecimal = addCommas("1000000.50");
  print("Added commas to '1000000.50': $withCommasDecimal");
  // Test character removal
  String noCommas = removeCommas("1,000,000");
  print("Removed commas: $noCommas");
  
  String noSpaces = removeBlank("Hello World");
  print("Removed spaces: $noSpaces");

   // Test phone number formatting
  String formatted1 = formatPhoneNumber("1234567890");
  print("Formatted 10-digit phone: $formatted1");
  
  String formatted2 = formatPhoneNumber("123456789");
  print("Formatted 9-digit phone: $formatted2");
  
  String formatted3 = formatPhoneNumber("(123) 456-7890");
  print("Formatted phone with symbols: $formatted3");
  
  String formatted4 = formatPhoneNumber(1234567890);
  print("Formatted numeric phone: $formatted4");

  // Test left and right string functions
  String testStr = "Hello World";
  String leftResult = leftString(testStr, 5);
  print("Left 5 characters of '$testStr': '$leftResult'");
  
  String rightResult = rightString(testStr, 5);
  print("Right 5 characters of '$testStr': '$rightResult'");
  
  // Test edge cases
  String leftTooMany = leftString("Hi", 10);
  print("Left 10 characters of 'Hi': '$leftTooMany'");
  
  String rightTooMany = rightString("Hi", 10);
  print("Right 10 characters of 'Hi': '$rightTooMany'");

}
 */
