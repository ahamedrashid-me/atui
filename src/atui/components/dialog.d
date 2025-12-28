/// Dialog component - Modal dialog boxes
module atui.components.dialog;

import atui.api.tui;
import atui.api.input;
import std.string : format;

public class Dialog {
    uint x, y, width, height;
    string title;
    string message;
    string[] buttons;
    int selectedButton = 0;
    bool visible = false;
    Color fgColor = Color.white();
    Color bgColor = Color.blue();
    Color buttonFg = Color.black();
    Color buttonBg = Color.cyan();
    void delegate(int) onButtonClick;  // Called with button index
    
    this(uint x, uint y, uint width, uint height, string title = "") {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        this.title = title;
    }
    
    void setMessage(string msg) { this.message = msg; }
    void setButtons(string[] btns) { 
        buttons = btns.dup;
        selectedButton = 0;
    }
    void show() { visible = true; }
    void hide() { visible = false; }
    
    void handleInput(InputEvent event) {
        if (!visible || event.type != InputEventType.KeyPress) return;
        
        if (event.keyData.specialKey == SpecialKey.ArrowLeft && selectedButton > 0) {
            selectedButton--;
        } else if (event.keyData.specialKey == SpecialKey.ArrowRight && 
                   selectedButton < cast(int)buttons.length - 1) {
            selectedButton++;
        } else if (event.keyData.keyChar == ' ' || event.keyData.specialKey == SpecialKey.Enter) {
            if (onButtonClick) onButtonClick(selectedButton);
            visible = false;
        } else if (event.keyData.specialKey == SpecialKey.Escape) {
            visible = false;
        }
    }
    
    void render() {
        if (!visible) return;
        
        // Draw semi-transparent overlay (fill background)
        for (uint py = 0; py < height; py++) {
            for (uint px = 0; px < width; px++) {
                print(x + px, y + py, " ", fgColor, bgColor);
            }
        }
        
        // Draw border
        print(x, y, "┌", fgColor, bgColor);
        for (uint i = 1; i < width - 1; i++) print(x + i, y, "─", fgColor, bgColor);
        print(x + width - 1, y, "┐", fgColor, bgColor);
        
        // Draw title
        if (title.length > 0) {
            uint titlePos = cast(uint)((width - cast(uint)title.length) / 2);
            for (uint i = 0; i < title.length && i < width - 2; i++) {
                print(x + titlePos + i, y + 1, title[i..i+1], fgColor, bgColor);
            }
        }
        
        // Draw message
        uint msgLine = 3;
        for (uint i = 0; i < message.length && msgLine < height - 3; i++) {
            if (message[i] == '\n') {
                msgLine++;
            } else {
                print(x + 2 + (i % (width - 4)), y + msgLine, message[i..i+1], fgColor, bgColor);
            }
        }
        
        // Draw buttons
        uint buttonY = height - 2;
        uint totalBtnWidth = 0;
        foreach (btn; buttons) {
            totalBtnWidth += btn.length + 6;  // [ btn ]
        }
        
        uint startX = (width - totalBtnWidth) / 2;
        uint currentX = startX;
        
        foreach (i, btn; buttons) {
            bool isSelected = (cast(int)i == selectedButton);
            auto fg = isSelected ? Color.black() : buttonFg;
            auto bg = isSelected ? Color.white() : buttonBg;
            
            string btnText = format("[ %s ]", btn);
            for (uint j = 0; j < btnText.length && currentX < x + width - 1; j++) {
                print(x + currentX, y + buttonY, btnText[j..j+1], fg, bg);
                currentX++;
            }
            currentX++;
        }
        
        // Draw side borders
        for (uint i = 1; i < height - 1; i++) {
            print(x, y + i, "│", fgColor, bgColor);
            print(x + width - 1, y + i, "│", fgColor, bgColor);
        }
        
        // Draw bottom border
        print(x, y + height - 1, "└", fgColor, bgColor);
        for (uint i = 1; i < width - 1; i++) print(x + i, y + height - 1, "─", fgColor, bgColor);
        print(x + width - 1, y + height - 1, "┘", fgColor, bgColor);
    }
}
