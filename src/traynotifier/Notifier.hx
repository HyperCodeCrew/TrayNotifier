package traynotifier;

#if cpp
import cpp.Lib;
#end

/**
 * Native Windows Toast Notifications for Haxe/C++ using WinToastLib.
 */
class Notifier {
    /**
     * Shows a toast notification on Windows.
     * 
     * @param appId    The application identifier (should be unique for your app)
     * @param title    The title of the notification
     * @param message  The message body of the notification
     * @return Int     Returns 0 on success, error code otherwise
     */
    public static function show(appId:String, title:String, message:String):Int {
        #if cpp
        return _show(appId, title, message);
        #else
        trace("TrayNotifier only works on C++ target");
        return -1;
        #end
    }

    /**
     * Initializes the notification system. Call this before showing notifications.
     * 
     * @param appName  The name of the application
     * @param appId    The application identifier (should be unique for your app)
     * @return Bool    Returns true if initialization was successful
     */
    public static function initialize(appName:String, appId:String):Bool {
        #if cpp
        return _initialize(appName, appId);
        #else
        trace("TrayNotifier only works on C++ target");
        return false;
        #end
    }

    /**
     * Checks if the toast notification system is compatible with the current OS.
     * 
     * @return Bool    Returns true if the system supports toast notifications
     */
    public static function isCompatible():Bool {
        #if cpp
        return _isCompatible();
        #else
        return false;
        #end
    }

    // Native methods
    #if cpp
    private static var _show = Lib.loadLazy("traynotifier", "notifier_show", 3);
    private static var _initialize = Lib.loadLazy("traynotifier", "notifier_initialize", 2);
    private static var _isCompatible = Lib.loadLazy("traynotifier", "notifier_is_compatible", 0);
    #end
} 