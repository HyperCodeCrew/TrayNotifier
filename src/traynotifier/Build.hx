package traynotifier;

/**
 * Helper class to build the TrayNotifier library.
 */
class Build {
    public static function main() {
        #if cpp
        // Print compilation success message
        Sys.println("TrayNotifier library compiled successfully.");
        Sys.println("You can now use `haxelib install` to install the library.");
        #else
        Sys.println("TrayNotifier only supports C++ target.");
        #end
    }
} 