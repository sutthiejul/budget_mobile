@echo off
chcp 65001 >nul
cls

echo ======================================================
echo           Flutter Project Migration Helper
echo ======================================================
echo 1. ลบแคชและไฟล์ชั่วคราว (รันก่อนก๊อปปี้ไปเครื่องอื่น)
echo 2. คืนค่า dependencies ด้วย flutter pub get (รันที่เครื่องปลายทาง)
echo 3. ออกจากโปรแกรม
echo ======================================================
set /p choice="กรุณาเลือกเมนู (1, 2 หรือ 3): "

if "%choice%"=="1" goto CLEAN
if "%choice%"=="2" goto RESTORE
if "%choice%"=="3" goto EXIT

:CLEAN
echo.
echo กำลังลบโฟลเดอร์แคชและไฟล์ชั่วคราว...

:: 1. ลบโฟลเดอร์ Build และ Cache ของ Dart / Flutter
if exist ".dart_tool" (
    echo - กำลังลบ .dart_tool
    rmdir /s /q ".dart_tool"
)
if exist "build" (
    echo - กำลังลบ build
    rmdir /s /q "build"
)

:: 2. ลบโฟลเดอร์ Cache ของ Android / Gradle
if exist ".gradle" (
    echo - กำลังลบ .gradle
    rmdir /s /q ".gradle"
)
if exist "android\.gradle" (
    echo - กำลังลบ android\.gradle
    rmdir /s /q "android\.gradle"
)
if exist "android\app\build" (
    echo - กำลังลบ android\app\build
    rmdir /s /q "android\app\build"
)

:: 3. ลบโฟลเดอร์ Pods และ Symlinks ของ iOS (ถ้ามี)
if exist "ios\Pods" (
    echo - กำลังลบ ios\Pods
    rmdir /s /q "ios\Pods"
)
if exist "ios\.symlinks" (
    echo - กำลังลบ ios\.symlinks
    rmdir /s /q "ios\.symlinks"
)

:: 4. ลบไฟล์ Mapping และ Dependency ชั่วคราว
if exist ".flutter-plugins" del /f /q ".flutter-plugins"
if exist ".flutter-plugins-dependencies" del /f /q ".flutter-plugins-dependencies"
if exist ".packages" del /f /q ".packages"

:: 5. (ทางเลือก) ลบโฟลเดอร์ Desktop และ Test ถ้าไม่ได้ใช้งาน
:: หากต้องการลบ ให้เอาเครื่องหมาย "::" หน้า 4 บรรทัดด้านล่างออก
:: if exist "windows" rmdir /s /q "windows"
:: if exist "macos" rmdir /s /q "macos"
:: if exist "linux" rmdir /s /q "linux"
:: if exist "test" rmdir /s /q "test"

echo.
echo [สำเร็จ] ล้างไฟล์แคชเรียบร้อยแล้ว ขนาดโปรเจกต์จะเล็กลงและพร้อมก๊อปปี้ไปเครื่องใหม่ทันที
echo.
pause
goto EXIT

:RESTORE
echo.
echo กำลังดึง Dependencies และตั้งค่าระบบใหม่...
call flutter pub get
echo.
echo [สำเร็จ] โปรเจกต์พร้อมรันบนเครื่องนี้แล้ว
echo.
pause
goto EXIT

:EXIT
exit