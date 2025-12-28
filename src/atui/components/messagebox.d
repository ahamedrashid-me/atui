/// MessageBox component - Simple message display
module atui.components.messagebox;

import atui.api.tui;
import atui.api.input;

public class MessageBox {
    uint x, y, width, height;
    string title;
    string message;
    bool visible = false;
    Color fgColor = Color.white();
    Color bgColor = Color.blue();
    void delegate() onDismiss;
    
    this(uint x, uint y, uint width, uint height, string title = "") {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        this.title = title;
    }
    
    void setMessage(string msg) { this.message = msg; }
    void show() { visible = true; }
    void hide() { visible = false; }
    
    void handleInput(InputEvent event) {
        if (!visible) return;
        if (event.type == InputEventType.KeyPress) {
            if (event.keyData.keyChar == ' ' || 
                event.keyData.specialKey == SpecialKey.Enter ||
                event.keyData.specialKey == SpecialKey.Escape) {
                visible = false;
                if (onDismiss) onDismiss();
            }
        }
    }
    
    void render() {
        if (!visible) return;
        
        // Draw background
        for (uint py = 0; py < height; py++) {
            for (uint px = 0; px < width; px++) {
                print(x + px, y + py, " ", fgColor, bgColor);
            }
        }
        
        // Draw border
        print(x, y, "╔", fgColor, bgColor);
        for (uint i = 1; i < width - 1; i++) print(x + i, y, "═", fgColor, bgColor);
        print(x + width - 1, y, "╗", fgColor, bgColor);
        
        // Draw title
        if (title.length > 0) {
            uint titlePos = cast(uint)((width - cast(uint)title.length) / 2);
            for (uint i = 0; i < title.length && titlePos + i < width - 1; i++) {
                print(x + titlePos + i, y + 1, title[i..i+1], fgColor, bgColor);
            }
        }
        
        // Draw message (word wrap)
        uint msgLine = 3;
        uint colPos = 0;
        for (uint i = 0; i < message.length && msgLine < height - 2; i++) {
            char ch = message[i];
            
            if (ch == '\n' || colPos >= width - 4) {
                msgLine++;
                colPos = 0;
                if (ch == '\n') continue;
            }
            
            if (msgLine < height - 2) {
                print(x + 2 + colPos, y + msgLine, ch ~ "", fgColor, bgColor);
                colPos++;
            }
        }
        
        // Draw side borders
        for (uint i = 1; i < height - 1; i++) {
            print(x, y + i, "║", fgColor, bgColor);
            print(x + width - 1, y + i, "║", fgColor, bgColor);
        }
        
        // Draw bottom border with instruction
        print(x, y + height - 1, "╚", fgColor, bgColor);
        string hint = "Press SPACE or ENTER";
        if (hint.length < width - 2) {
            uint hintPos = cast(uint)((width - cast(uint)hint.length) / 2);
            for (uint i = 0; i < hint.length; i++) {
                print(x + hintPos + i, y + height - 1, hint[i..i+1], fgColor, bgColor);
            }
        }
        print(x + width - 1, y + height - 1, "╝", fgColor, bgColor);
    }
}
