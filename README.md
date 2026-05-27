# Key Lime Pi
*An embedded Spotify controller that can be used to run on a Raspberry Pi.*

## Features
- Control Spotify playback
  - Play, pause, and skip songs
  - Seek playback
  - View queue
- Start playlists, albums, and liked songs
- View and search lyrics
  - Romanize lyrics

## Building for Raspberry Pi
To build for usage on a Raspberry Pi you'll need [flutterpi_tool](https://github.com/ardera/flutterpi_tool). You can install it by running:

```
flutter pub global activate flutterpi_tool
```
Once installed, make sure that it's in your $PATH. 

From this point on, there will be two methods of building depending on how you will run it.

### Method 1: Via ivi-homescreen (Recommended)
Compile [ivi-homescreen](https://github.com/toyota-connected/ivi-homescreen) with the Flutter Secure Storage plugin enabled and make sure the resulting binary is on the Pi's path. Make sure that you have a secret service provider like gnome-keyring installed on the Pi.

After that, run the build script from the project root on your main machine:
```
./raspberry-pi_build.sh
```
This will build *Key Lime Pi* using flutterpi_tool and make sure that it's in a structure that ivi-homescreen will understand.

Then copy the resulting $PROJECT_ROOT/build/flutter-pi/pi4-64 directory to the Pi and run. You can use this example script:

```
#!/bin/bash
rm -f /run/user/$(id -u)/keyring/*
export XDG_RUNTIME_DIR=/run/user/1000
export LIBINPUT_CALIBRATIOn_MATRIX="1 0 0 0 1 0"

eval $(echo "$USERPASSWORDHERE" | gnome-keyring-daemon --unlock --components=secrets)
export GNOME_KEYRING_CONTROL
export GNOME_KEYRING_PID

cage -d -- homescreen -c -b $PATH_TO_COPIED_BUILD -f -p 1.5
```
Assuming you have Cage installed, this will start the app in a Wayland compositor and unlock the GNOME Keyring at the same time.

### Method 2: Via flutter-pi
Run this build command:
```
flutterpi_tool build --cpu=pi4 --arch=arm64 --release
```
Then copy the resulting $PROJECT_ROOT/build/flutter-pi/pi4-64 directory to the Pi and run using [flutter-pi](https://github.com/ardera/flutter-pi).

> [!NOTE]
> This method is prone to some issues from my experience and using ivi-homescreen is less of a hassle. Use this only on your own discretion. I will not provide any support for this method.

## Gallery
<img width="539" height="355" alt="image" src="https://github.com/user-attachments/assets/38cfceb0-8f0d-4b4c-b152-52a2957a6c15" />
<img width="538" height="355" alt="image" src="https://github.com/user-attachments/assets/50266953-bf94-4064-92f9-69c16f3dfba5" />
<img width="538" height="355" alt="image" src="https://github.com/user-attachments/assets/1a7e2273-c25f-44cc-8375-2b7b63b3f052" />


## Special thanks
Thanks to all these projects that have made this project work the way it does:
- [LRCLIB](https://lrclib.net/)
- [Yomi](https://github.com/ookii-tsuki/yomi)
- [ivi-homescreen](https://github.com/toyota-connected/ivi-homescreen)
- [flutter-pi](https://github.com/ardera/flutter-pi)

And to any others that I may have forgotten, thanks!
