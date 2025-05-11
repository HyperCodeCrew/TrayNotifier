package;

import traynotifier.Notifier;

/**
 * Example of using TrayNotifier library.
 */
class Main {
    public static function main() {
        // Check if toast notifications are supported on this system
        if (!Notifier.isCompatible()) {
            trace("Toast notifications are not supported on this system");
            return;
        }

        // Initialize the notification system
        var appName = "TrayNotifier Example";
        var appId = "com.hypercodecrew.traynotifier.example";
        
        if (!Notifier.initialize(appName, appId)) {
            trace("Failed to initialize toast notifications");
            return;
        }

        // Show a simple notification
        var result = Notifier.show(appId, "Hello from Haxe", "This is a toast notification from TrayNotifier library");
        
        if (result != 0) {
            trace('Failed to show notification, error code: $result');
        } else {
            trace("Notification shown successfully");
        }
    }
} 