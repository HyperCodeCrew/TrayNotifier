#define IMPLEMENT_API
#include <hx/CFFI.h>
#include "../../../include/wintoastlib.h"
#include <string>

using namespace WinToastLib;

// Global instance of WinToast
static std::shared_ptr<WinToast> toast = nullptr;

// Handler for toast notifications
class ToastHandler : public IWinToastHandler {
public:
    ToastHandler() = default;
    void toastActivated() const override {}
    void toastActivated(int actionIndex) const override {}
    void toastActivated(std::wstring response) const override {}
    void toastDismissed(WinToastDismissalReason state) const override {}
    void toastFailed() const override {}
};

// Function to convert UTF8 string to wide string
std::wstring utf8_to_wide(const char* utf8Str) {
    int wideSize = MultiByteToWideChar(CP_UTF8, 0, utf8Str, -1, NULL, 0);
    if (wideSize == 0) return std::wstring();
    
    std::wstring wideStr(wideSize, 0);
    MultiByteToWideChar(CP_UTF8, 0, utf8Str, -1, &wideStr[0], wideSize);
    wideStr.resize(wideSize - 1); // Remove the null terminator
    
    return wideStr;
}

// Haxe function: Check if the system is compatible with toast notifications
value notifier_is_compatible() {
    return alloc_bool(WinToast::isCompatible());
}
DEFINE_PRIM(notifier_is_compatible, 0);

// Haxe function: Initialize the toast notification system
value notifier_initialize(value appName, value appId) {
    if (!val_is_string(appName) || !val_is_string(appId)) {
        return alloc_bool(false);
    }
    
    std::wstring wAppName = utf8_to_wide(val_string(appName));
    std::wstring wAppId = utf8_to_wide(val_string(appId));
    
    // Initialize WinToast instance
    toast = std::make_shared<WinToast>();
    toast->setAppName(wAppName);
    toast->setAppUserModelId(wAppId);
    
    WinToast::WinToastError error;
    bool result = toast->initialize(&error);
    
    return alloc_bool(result);
}
DEFINE_PRIM(notifier_initialize, 2);

// Haxe function: Show a toast notification
value notifier_show(value appId, value title, value message) {
    if (!val_is_string(appId) || !val_is_string(title) || !val_is_string(message)) {
        return alloc_int(-1);
    }
    
    // Check if toast is initialized
    if (!toast || !toast->isInitialized()) {
        std::wstring wAppId = utf8_to_wide(val_string(appId));
        
        // Initialize on-the-fly if needed
        toast = std::make_shared<WinToast>();
        toast->setAppName(L"TrayNotifier App");
        toast->setAppUserModelId(wAppId);
        
        WinToast::WinToastError error;
        if (!toast->initialize(&error)) {
            return alloc_int(error);
        }
    }
    
    // Create toast template
    WinToastTemplate templ(WinToastTemplate::Text02);
    templ.setTextField(utf8_to_wide(val_string(title)), WinToastTemplate::FirstLine);
    templ.setTextField(utf8_to_wide(val_string(message)), WinToastTemplate::SecondLine);
    
    // Show toast
    WinToast::WinToastError error;
    auto handler = new ToastHandler();
    INT64 id = toast->showToast(templ, handler, &error);
    
    if (error != WinToast::NoError) {
        return alloc_int(error);
    }
    
    return alloc_int(0); // Success
}
DEFINE_PRIM(notifier_show, 3);

// Initialize Haxe extension
extern "C" void traynotifier_main() {
    // Nothing to do here
}
DEFINE_ENTRY_POINT(traynotifier_main);

extern "C" int traynotifier_register_prims() { return 0; } 