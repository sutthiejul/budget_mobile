import 'package:flutter/material.dart';
import 'theme_provider.dart';

class SetTheme extends StatelessWidget {
  static String routeName = "/settheme";

  const SetTheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set Theme')),
      body: ListenableBuilder(
        listenable: ThemeProvider.instance,
        builder: (context, child) {
          final currentTheme = ThemeProvider.currentTheme;

          // 1. นำ RadioGroup มาครอบและย้าย groupValue กับ onChanged มาไว้ที่นี่
          return RadioGroup<AppThemeType>(
            groupValue: currentTheme,
            onChanged: (AppThemeType? value) {
              if (value != null) {
                ThemeProvider.instance.setTheme(value);
              }
            },
            child: ListView.builder(
              itemCount: AppThemeType.values.length,
              itemBuilder: (context, index) {
                final themeType = AppThemeType.values[index];
                final isSelected = themeType == currentTheme;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: _getThemePreviewColor(themeType),
                    child:
                        isSelected
                            ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            )
                            : null,
                  ),
                  title: Text(
                    themeType.name.toUpperCase(),
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  // 2. ลบ groupValue และ onChanged ออกจาก Radio
                  trailing: Radio<AppThemeType>(
                    value: themeType,
                    activeColor: _getThemePreviewColor(themeType),
                  ),
                  onTap: () {
                    ThemeProvider.instance.setTheme(themeType);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Color _getThemePreviewColor(AppThemeType type) {
    switch (type) {
      case AppThemeType.purple:
        return Colors.purple;
      case AppThemeType.blue:
        return Colors.blue.shade800;
      case AppThemeType.green:
        return Colors.green.shade800;
      case AppThemeType.orange:
        return Colors.orange.shade800;
      case AppThemeType.dark:
        return const Color(0xFF121212);
    }
  }
}
