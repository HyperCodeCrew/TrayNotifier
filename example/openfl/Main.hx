package;

import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.display.Bitmap;
import openfl.Assets;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;

import traynotifier.openfl.ToastNotification;

/**
 * Example OpenFL application that demonstrates using TrayNotifier
 */
class Main extends Sprite {
    private var toastNotification:ToastNotification;
    private var statusText:TextField;
    private var titleInput:TextField;
    private var messageInput:TextField;
    
    public function new() {
        super();
        
        // Initialize the UI
        createUI();
        
        // Initialize the toast notification system
        toastNotification = new ToastNotification();
        
        // Add event listeners for toast notification events
        toastNotification.addEventListener(ToastNotification.NOTIFICATION_SHOWN, onNotificationShown);
        toastNotification.addEventListener(ToastNotification.NOTIFICATION_ERROR, onNotificationError);
        
        // Check if toast notifications are supported
        if (ToastNotification.isSupported()) {
            // Initialize toast notification system
            var appName = "TrayNotifier OpenFL Example";
            var appId = "com.hypercodecrew.traynotifier.openfl.example";
            
            if (toastNotification.initialize(appName, appId)) {
                updateStatus("ระบบการแจ้งเตือนพร้อมใช้งาน");
            } else {
                updateStatus("ไม่สามารถเริ่มต้นระบบการแจ้งเตือนได้");
            }
        } else {
            updateStatus("ระบบไม่รองรับการแจ้งเตือนแบบ toast");
        }
    }
    
    /**
     * Creates the user interface
     */
    private function createUI():Void {
        // Set stage background color
        this.graphics.beginFill(0xF0F0F0);
        this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
        this.graphics.endFill();
        
        // Title
        var title = new TextField();
        title.defaultTextFormat = new TextFormat("Arial", 20, 0x000000, true);
        title.text = "TrayNotifier สำหรับ OpenFL";
        title.autoSize = TextFieldAutoSize.LEFT;
        title.x = 20;
        title.y = 20;
        addChild(title);
        
        // Label for title input
        var titleLabel = new TextField();
        titleLabel.defaultTextFormat = new TextFormat("Arial", 14, 0x000000);
        titleLabel.text = "หัวข้อการแจ้งเตือน:";
        titleLabel.autoSize = TextFieldAutoSize.LEFT;
        titleLabel.x = 20;
        titleLabel.y = 70;
        addChild(titleLabel);
        
        // Title input field
        titleInput = new TextField();
        titleInput.defaultTextFormat = new TextFormat("Arial", 14, 0x000000);
        titleInput.border = true;
        titleInput.background = true;
        titleInput.backgroundColor = 0xFFFFFF;
        titleInput.width = 400;
        titleInput.height = 30;
        titleInput.type = openfl.text.TextFieldType.INPUT;
        titleInput.text = "ทดสอบการแจ้งเตือน";
        titleInput.x = 20;
        titleInput.y = 100;
        addChild(titleInput);
        
        // Label for message input
        var messageLabel = new TextField();
        messageLabel.defaultTextFormat = new TextFormat("Arial", 14, 0x000000);
        messageLabel.text = "ข้อความ:";
        messageLabel.autoSize = TextFieldAutoSize.LEFT;
        messageLabel.x = 20;
        messageLabel.y = 150;
        addChild(messageLabel);
        
        // Message input field
        messageInput = new TextField();
        messageInput.defaultTextFormat = new TextFormat("Arial", 14, 0x000000);
        messageInput.border = true;
        messageInput.background = true;
        messageInput.backgroundColor = 0xFFFFFF;
        messageInput.width = 400;
        messageInput.height = 60;
        messageInput.multiline = true;
        messageInput.wordWrap = true;
        messageInput.type = openfl.text.TextFieldType.INPUT;
        messageInput.text = "นี่คือข้อความตัวอย่างสำหรับการแจ้งเตือนแบบ toast บน Windows";
        messageInput.x = 20;
        messageInput.y = 180;
        addChild(messageInput);
        
        // Show notification button
        var showButton = new Sprite();
        showButton.graphics.beginFill(0x4CAF50);
        showButton.graphics.drawRoundRect(0, 0, 200, 40, 8, 8);
        showButton.graphics.endFill();
        showButton.x = 20;
        showButton.y = 260;
        showButton.buttonMode = true;
        showButton.addEventListener(MouseEvent.CLICK, onShowClick);
        addChild(showButton);
        
        // Button text
        var buttonText = new TextField();
        buttonText.defaultTextFormat = new TextFormat("Arial", 14, 0xFFFFFF, true);
        buttonText.text = "แสดงการแจ้งเตือน";
        buttonText.autoSize = TextFieldAutoSize.LEFT;
        buttonText.mouseEnabled = false;
        buttonText.x = showButton.x + (showButton.width - buttonText.width) / 2;
        buttonText.y = showButton.y + (showButton.height - buttonText.height) / 2;
        addChild(buttonText);
        
        // Status text
        statusText = new TextField();
        statusText.defaultTextFormat = new TextFormat("Arial", 12, 0x666666);
        statusText.autoSize = TextFieldAutoSize.LEFT;
        statusText.x = 20;
        statusText.y = 320;
        statusText.width = 400;
        addChild(statusText);
    }
    
    /**
     * Updates the status text
     */
    private function updateStatus(message:String):Void {
        statusText.text = "สถานะ: " + message;
    }
    
    /**
     * Handle show notification button click
     */
    private function onShowClick(e:MouseEvent):Void {
        var title = titleInput.text;
        var message = messageInput.text;
        
        if (title.length == 0 || message.length == 0) {
            updateStatus("กรุณากรอกหัวข้อและข้อความ");
            return;
        }
        
        updateStatus("กำลังแสดงการแจ้งเตือน...");
        toastNotification.show(title, message);
    }
    
    /**
     * Handle notification shown event
     */
    private function onNotificationShown(e:Event):Void {
        updateStatus("การแจ้งเตือนแสดงเรียบร้อยแล้ว");
    }
    
    /**
     * Handle notification error event
     */
    private function onNotificationError(e:Dynamic):Void {
        var code = e.code;
        updateStatus('เกิดข้อผิดพลาดในการแสดงการแจ้งเตือน (รหัส: $code)');
    }
} 