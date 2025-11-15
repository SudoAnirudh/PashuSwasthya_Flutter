# Running Flutter App on Android Device via USB

This guide will help you run your Flutter app directly on your Android device connected via USB cable.

## Prerequisites

1. **Flutter SDK** installed and configured
2. **Android Studio** or **Android SDK** installed
3. **USB cable** to connect your Android device to your computer
4. **Android device** with Android 4.1 (API level 16) or higher

## Step-by-Step Instructions

### Step 1: Enable Developer Options on Your Android Device

1. Open **Settings** on your Android device
2. Scroll down and tap **About phone** (or **About device**)
3. Find **Build number** and tap it **7 times** until you see "You are now a developer!"
4. Go back to the main Settings menu
5. You should now see **Developer options** (usually under System or Advanced)

### Step 2: Enable USB Debugging

1. Open **Settings** > **Developer options**
2. Toggle **Developer options** to **ON** (if not already on)
3. Enable **USB debugging**
4. (Optional but recommended) Enable **Stay awake** (keeps screen on while charging)
5. (Optional) Enable **Install via USB** (if available)

### Step 3: Connect Your Device via USB

1. Connect your Android device to your computer using a USB cable
2. On your Android device, you'll see a popup asking **"Allow USB debugging?"**
3. Check **"Always allow from this computer"** (optional but recommended)
4. Tap **OK** or **Allow**

### Step 4: Verify Device Connection

Open PowerShell or Command Prompt and run:

```bash
adb devices
```

You should see your device listed, for example:
```
List of devices attached
ABC123XYZ    device
```

**If your device shows as "unauthorized":**
- Unplug and replug the USB cable
- Check the popup on your device and tap "Allow"
- Run `adb devices` again

**If your device is not detected:**
- Try a different USB cable
- Try a different USB port
- Install/update USB drivers for your device
- On Windows, you may need to install device-specific drivers

### Step 5: Verify Flutter Can See Your Device

Run this command to see all connected devices:

```bash
flutter devices
```

You should see your Android device listed, for example:
```
2 connected devices:

sdk gphone64 arm64 (mobile) • emulator-5554 • android-arm64  • Android 13 (API 33)
SM-G991B (mobile)           • R58M123456    • android-arm64 • Android 13 (API 33)
```

### Step 6: Run the App on Your Device

Navigate to your project directory and run:

```bash
cd C:\Users\aniru\Documents\GitHub\PashuSwasthya_Flutter
flutter run
```

Flutter will automatically detect your connected Android device and install/run the app.

**To run on a specific device** (if multiple devices are connected):

```bash
flutter run -d <device-id>
```

Replace `<device-id>` with the device ID from `flutter devices` (e.g., `R58M123456`)

### Step 7: Hot Reload (While App is Running)

While the app is running, you can:
- Press **`r`** in the terminal to **hot reload** (quick changes)
- Press **`R`** to **hot restart** (full restart)
- Press **`q`** to **quit** the app

## Troubleshooting

### Device Not Detected

1. **Check USB connection:**
   ```bash
   adb devices
   ```

2. **Restart ADB server:**
   ```bash
   adb kill-server
   adb start-server
   adb devices
   ```

3. **Check USB drivers:**
   - Windows: Install device-specific USB drivers (Samsung, Google, etc.)
   - Make sure USB drivers are up to date

4. **Try different USB mode:**
   - On your device, when connected, change USB mode to **File Transfer (MTP)** or **PTP**

### "Unauthorized" Device

1. Unplug USB cable
2. Revoke USB debugging authorizations on your device:
   - Settings > Developer options > Revoke USB debugging authorizations
3. Reconnect USB cable
4. Allow USB debugging when prompted

### App Installation Fails

1. **Uninstall existing app:**
   ```bash
   adb uninstall com.pashu_swasthya
   ```

2. **Clear app data and try again:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

### Build Errors

1. **Clean and rebuild:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Check Flutter doctor:**
   ```bash
   flutter doctor
   ```
   Fix any issues shown (especially Android toolchain)

### USB Debugging Disconnects Frequently

1. **Disable battery optimization** for USB debugging
2. **Use a high-quality USB cable**
3. **Try USB 2.0 port** instead of USB 3.0 (sometimes more stable)
4. **Enable "Stay awake"** in Developer options

## Quick Reference Commands

```bash
# Check connected devices
adb devices
flutter devices

# Run app on connected device
flutter run

# Run on specific device
flutter run -d <device-id>

# Build and install APK
flutter build apk
adb install build\app\outputs\flutter-apk\app-debug.apk

# Uninstall app
adb uninstall com.pashu_swasthya

# Restart ADB
adb kill-server
adb start-server

# Check Flutter setup
flutter doctor
```

## Wireless Debugging (Alternative)

If you prefer wireless debugging (Android 11+):

1. Connect device via USB first
2. Pair device:
   ```bash
   adb pair <ip-address>:<port>
   ```
3. Connect wirelessly:
   ```bash
   adb connect <ip-address>:<port>
   ```
4. Disconnect USB and run `flutter run`

## Notes

- Keep your device unlocked while developing
- The first build may take several minutes
- Subsequent builds will be faster with hot reload
- Make sure your device has enough storage space
- Keep USB debugging enabled only when needed for security

