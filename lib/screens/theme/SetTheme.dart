import 'package:flutter/material.dart';
// อย่าลืม import ไฟล์ ThemeProvider ของคุณเข้ามาด้วยนะครับ
import 'theme_provider.dart';

class SetTheme extends StatelessWidget {
  static String routeName = "/settheme";

  const SetTheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set Theme')),
      // ใช้ ListenableBuilder เพื่อรอรับการแจ้งเตือนเมื่อมีการเปลี่ยนธีม
      body: ListenableBuilder(
        listenable: ThemeProvider.instance,
        builder: (context, child) {
          final currentTheme = ThemeProvider.currentTheme;

          return ListView.builder(
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
                trailing: Radio<AppThemeType>(
                  value: themeType,
                  groupValue: currentTheme,
                  activeColor: _getThemePreviewColor(themeType),
                  onChanged: (AppThemeType? value) {
                    if (value != null) {
                      ThemeProvider.instance.setTheme(value);
                    }
                  },
                ),
                onTap: () {
                  // ให้ User กดที่ Card ทั้งแถวเพื่อเปลี่ยนธีมได้เลย
                  ThemeProvider.instance.setTheme(themeType);
                },
              );
            },
          );
        },
      ),
    );
  }

  // Helper ฟังก์ชันสำหรับคืนค่าสีพรีวิวให้ตรงกับ AppThemeType แต่ละตัว
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
