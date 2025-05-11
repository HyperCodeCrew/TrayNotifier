package traynotifier.openfl;

import openfl.events.EventDispatcher;
import openfl.events.Event;
import traynotifier.Notifier;

/**
 * OpenFL wrapper for TrayNotifier library.
 * Provides Windows toast notifications in OpenFL applications.
 */
class ToastNotification extends EventDispatcher {
    /**
     * Event dispatched when toast notification is shown successfully.
     */
    public static inline var NOTIFICATION_SHOWN:String = "notificationShown";

    /**
     * Event dispatched when toast notification fails to show.
     */
    public static inline var NOTIFICATION_ERROR:String = "notificationError";

    /**
     * Application name used for notifications
     */
    private static var _appName:String;

    /**
     * Application ID used for notifications
     */
    private static var _appId:String;

    /**
     * Whether the notification system is initialized
     */
    private static var _initialized:Bool = false;

    /**
     * Constructor
     */
    public function new() {
        super();
    }

    /**
     * Initializes the toast notification system
     * 
     * @param appName The name of your application
     * @param appId A unique identifier for your application (e.g. "com.company.app")
     * @return Boolean indicating whether initialization was successful
     */
    public function initialize(appName:String, appId:String):Bool {
        #if windows
        if (!Notifier.isCompatible()) {
            return false;
        }

        _appName = appName;
        _appId = appId;
        _initialized = Notifier.initialize(appName, appId);
        return _initialized;
        #else
        return false;
        #end
    }

    /**
     * Shows a toast notification
     * 
     * @param title The title of the notification
     * @param message The message body of the notification
     * @return Boolean indicating whether the notification was shown successfully
     */
    public function show(title:String, message:String):Bool {
        #if windows
        if (!_initialized && _appName != null && _appId != null) {
            _initialized = initialize(_appName, _appId);
        }

        if (!_initialized) {
            dispatchEvent(new NotificationEvent(NOTIFICATION_ERROR, -1));
            return false;
        }

        var result = Notifier.show(_appId, title, message);
        
        if (result == 0) {
            dispatchEvent(new NotificationEvent(NOTIFICATION_SHOWN, 0));
            return true;
        } else {
            dispatchEvent(new NotificationEvent(NOTIFICATION_ERROR, result));
            return false;
        }
        #else
        return false;
        #end
    }

    /**
     * Checks if toast notifications are supported on this system
     * 
     * @return Boolean indicating whether toast notifications are supported
     */
    public static function isSupported():Bool {
        #if windows
        return Notifier.isCompatible();
        #else
        return false;
        #end
    }
}

/**
 * Event class for toast notifications
 */
class NotificationEvent extends Event {
    /**
     * Error code if an error occurred, or 0 for success
     */
    public var code:Int;
    
    /**
     * Constructor
     * 
     * @param type Event type
     * @param code Error code (0 for success)
     */
    public function new(type:String, code:Int) {
        super(type, false, false);
        this.code = code;
    }
    
    /**
     * Clone the event
     */
    public override function clone():Event {
        return new NotificationEvent(type, code);
    }
    
    /**
     * String representation
     */
    public override function toString():String {
        return '[NotificationEvent type=$type code=$code]';
    }
} 