# m3u-playlist
A web server that generates a m3u playlist with main channels from France and Türkiye.

# 1. Setup instructions

## 1.1 Extract Content Decryption Module (CDM)
In order to watch DRM-protected content, you will need a Content Decryption Module (CDM).
The channels below are DRM-protected:
- M6

The steps to extract the CDM are detailed below. You can ignore this part if you do not intend on watching DRM-protected content.

Source: https://forum.videohelp.com/threads/408031-Dumping-Your-own-L3-CDM-with-Android-Studio/page28#post2779324

- Install [Android Studio](https://developer.android.com/studio)
- Install the Android Studio SDK for API34
- In Android Studio go to File > Settings > Language & Frameworks > Android SDK
- Select Android 14 API Level 34
- This should install to your %localappdata%\Android\Sdk\ folder

![Step 1](https://github.com/compte-bidon/m3u-playlist/blob/main/doc_assets/cdm_extract/Step1.png?raw=true)

- Create a new Pixel 4 XL device

![Step 2](https://github.com/compte-bidon/m3u-playlist/blob/main/doc_assets/cdm_extract/Step2.png?raw=true)

- Use API 34 and select Google APIs Intel x86_64 Atom System Image
- Create the device

![Step 3](https://github.com/compte-bidon/m3u-playlist/blob/main/doc_assets/cdm_extract/Step3.png?raw=true)

- On your system install Python3
    - Example: [Python 3.14](https://www.python.org/downloads/release/python-3147/)
- Open CMD Prompt and Install frida-tools and keydive:

`pip install frida frida-tools keydive`

- When frida & frida-tools installs, check what version it is, and [download](https://github.com/frida/frida/releases) the corresponding server version
    - Exemple: If it shows 17.2.4, download frida-server-17.2.4-android-x86_64.xz
- Extract the archive so you have the binary

Setup ADB so it is an Environmental Path:
- Open System > Advanced system settings > Environmental variables...
- In User or System variables; select Path and Edit..
- Enter the path to your Android SDK's "platform-tools" folder

![Step 4](https://github.com/compte-bidon/m3u-playlist/blob/main/doc_assets/cdm_extract/Step4.png?raw=true)

- Open a new CMD and test its working by typing 'adb --version'

![Step 5](https://github.com/compte-bidon/m3u-playlist/blob/main/doc_assets/cdm_extract/Step5.png?raw=true)

Next we follow the same rooting and frida-server steps:
- Make sure the device is powered on in Android Studio
- Check adb can see the emulated device

`adb devices`

- Then root it; push frida-server and run it

```sh
adb root
adb push frida-server-17.2.4-android-x86_64 /sdcard

adb shell
mv /sdcard/frida-server_yourversion /data/local/tmp/frida-server
chmod 755 /data/local/tmp/frida-server
/data/local/tmp/frida-server &
```

- Open another CMD prompt window in the folder you want to save the files
- Run keydive with this command

`keydive -kw -a player`

- Look at your device and you will see the app open on the phone and a pink icon in the bottom corner
- Click the icon then "Provision Widevine"

![Step 6](https://github.com/compte-bidon/m3u-playlist/blob/main/doc_assets/cdm_extract/Step6.png?raw=true)

- You should see it successfully connect

```
2025-07-26 08:24:58 [I] keydive: Version: 3.0.5
2025-07-26 08:24:58 [I] Remote: Connected to device: Android Emulator 5556 (emulator-5556)
2025-07-26 08:24:58 [I] Remote: SDK API: 34
2025-07-26 08:24:58 [I] Remote: ABI CPU: x86_64
2025-07-26 08:24:58 [I] Core: Preparing DRM player: Kaltura Device Info (com.kaltura.kalturadeviceinfo)
2025-07-26 08:25:00 [I] Core: Starting application: Kaltura Device Info (com.kaltura.kalturadeviceinfo)
2025-07-26 08:25:01 [I] Core: Watcher delay: 1.0s
2025-07-26 08:25:01 [I] Core: Detected process: 420 (android.hardware.drm-service.widevine)
2025-07-26 08:25:02 [I] Core: Library found: android.hardware.drm-service.widevine (/apex/com.google.android.widevine/bin/hw/android.hardware.drm-service.widevine)
2025-07-26 08:25:02 [I] Core: Successfully attached hook to process: 420
2025-07-26 08:25:07 [I] Cdm: Received encrypted keybox:
```

- It should display your output keys

![Step 7](https://github.com/compte-bidon/m3u-playlist/blob/main/doc_assets/cdm_extract/Step7.png?raw=true)

- The keys output path is relative to your current working directory..so whichever folder you were in when you ran keydive.

## 1.2 Setup credentials

- Copy the CDM keys you previously extracted (client_id.bin, keybox.enc, privte_key.pem and the .wvd files) somewhere on the device running the m3u playlist web server and note the path to the .wvd file.

```sh
sudo tee /etc/m3u-tv.env > /dev/null <<EOF
WIDEVINE_DEVICE_FILE_PATH=path/to/widewine/wdv/device/file
TF1EMAIL=my_tf1_email_address
TF1PASSWORD=my_tf1_password
M6EMAIL=my_m6_email_address
M6PASSWORD=my_m6_email_password
EOF
```

## 1.3 Install the web server

`curl -fsSL https://raw.githubusercontent.com/compte-bidon/m3u-playlist/main/install.sh | bash`

- If you are prompted to choose whether to continue because of the authenticity of github.com could not be established, enter yes to continue.

- When prompted, register the SSH public key in deploy keys: https://github.com/compte-bidon/m3u-tv/settings/keys

## 1.4 Uninstall the web server

`curl -fsSL https://raw.githubusercontent.com/compte-bidon/m3u-playlist/main/uninstall.sh | bash`

- When prompted, remove the SSH public key in deploy keys: https://github.com/compte-bidon/m3u-tv/settings/keys

# 2. Cheatsheet

List services: `sudo systemctl list-units --type=service`

## 2.1 Setup script

Status:            `sudo systemctl status web_m3u_setup`

Logs (live):       `sudo journalctl -u web_m3u_setup -f`

Logs (history):    `sudo journalctl -u web_m3u_setup`

Disable autostart: `sudo systemctl disable web_m3u_setup`

## 2.2 Web server

Start service:     `sudo systemctl start m3u_tv`

Stop service:      `sudo systemctl stop m3u_tv`

Restart service:   `sudo systemctl restart m3u_tv`

Status:            `sudo systemctl status m3u_tv`

Logs (live):       `sudo journalctl -u m3u_tv -f`

Logs (history):    `sudo journalctl -u m3u_tv`

Disable autostart: `sudo systemctl disable m3u_tv`

## 2.3 MediaFlow Proxy Light

Start service:     `sudo systemctl start mediaflow_light`

Stop service:      `sudo systemctl stop mediaflow_light`

Restart service:   `sudo systemctl restart mediaflow_light`

Status:            `sudo systemctl status mediaflow_light`

Logs (live):       `sudo journalctl -u mediaflow_light -f`

Logs (history):    `sudo journalctl -u mediaflow_light`

Disable autostart: `sudo systemctl disable mediaflow_light`