# TrayNotifier

Native Windows Toast Notifications for Haxe/C++ using WinToastLib.

## Features
- Support for Windows 8, 8.1, 10, and 11
- Easy to use API
- Based on the robust WinToastLib
- OpenFL integration

## Installation

```bash
haxelib git traynotifier https://github.com/HyperCodeCrew/TrayNotifier.git
```

## Usage

### Basic Haxe/C++ Usage

```haxe
import traynotifier.Notifier;

class Main {
    static function main() {
        // Initialize the notification system
        Notifier.initialize("YourAppName", "YourAppID");
        
        // Show a toast notification
        Notifier.show("YourAppID", "Hello", "World");
    }
}
```

### OpenFL Usage

```haxe
import traynotifier.openfl.ToastNotification;

class Main {
    static function main() {
        // Create a toast notification instance
        var toast = new ToastNotification();
        
        // Initialize the notification system
        toast.initialize("YourAppName", "YourAppID");
        
        // Show a toast notification
        toast.show("Hello", "World");
        
        // You can also listen for events
        toast.addEventListener(ToastNotification.NOTIFICATION_SHOWN, function(e) {
            trace("Notification shown successfully");
        });
        
        toast.addEventListener(ToastNotification.NOTIFICATION_ERROR, function(e) {
            trace("Error showing notification: " + e.code);
        });
    }
}
```

## Building from Source

1. Clone the repository
2. Install dependencies:
```bash
haxelib install hxcpp
haxelib install openfl # If you want to use with OpenFL
```
3. Build the project:
```bash
haxe build.hxml
```

## License
MIT License - See License file for details.

## Credits
- [WinToastLib](https://github.com/mohabouje/WinToast/) by Mohammed Boujemaoui
- Developed by HyperCodeCrew
