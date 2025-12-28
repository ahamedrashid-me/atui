/// InputDialog component - Simple input dialog
module atui.components.inputdialog;

import atui.api.tui;
import atui.api.input;
import std.string : format;

public class InputDialog {
    uint x, y, width, height;
    string title;
    string prompt;
    string inputText;
    uint cursorPos = 0;
    bool visible = false;
    bool confirmed = false;
    Color dialogFg = Color.white();
    Color dialogBg = Color.blue();
    Color inputBg = Color.black();
    void delegate(string) onConfirm;
    
    this(uint x, uint y, uint width, uint height, string title = "") {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        this.title = title;
    }
    
    void setPrompt(string p) { this.prompt = p; }
    void show() { visible = true; inputText = ""; cursorPos = 0; }
    void hide() { visible = false; }
    string getInput() const { return inputText; }
    
    void handleInput(InputEvent event) {
        if (!visible || event.type != InputEventType.KeyPress) return;
        
        char ch = event.keyData.keyChar;
        
        if (ch >= 32 && ch < 127 && inputText.length < width - 6) {
            inputText ~= ch;
            cursorPos++;
        } else if (event.keyData.specialKey == SpecialKey.Backspace && inputText.length > 0) {
            inputText = inputText[0..$-1];
            if (cursorPos > 0) cursorPos--;
        } else if (event.keyData.specialKey == SpecialKey.Enter) {
            if (onConfirm) onConfirm(inputText);
            visible = false;
        } else if (event.keyData.specialKey == SpecialKey.Escape) {
            visible = false;
        }
    }
    
    void render() {
        if (!visible) return;
        
        // Draw background
        for (uint py = 0; py < height; py++) {
            for (uint px = 0; px < width; px++) {
                print(x + px, y + py, " ", dialogFg, dialogBg);
            }
        }
        
        // Draw border
        print(x, y, "┌", dialogFg, dialogBg);
        for (uint i = 1; i < width - 1; i++) print(x + i, y, "─", dialogFg, dialogBg);
        print(x + width - 1, y, "┐", dialogFg, dialogBg);
        
        // Draw title
        if (title.length > 0) {
            uint titlePos = cast(uint)((width - cast(uint)title.length) / 2);
            for (uint i = 0; i < title.length && titlePos + i < width - 1; i++) {
                print(x + titlePos + i, y + 1, title[i..i+1], dialogFg, dialogBg);
            }
        }
        
        // Draw prompt
        uint promptLine = 3;
        for (uint i = 0; i < prompt.length && i < width - 4; i++) {
            print(x + 2 + i, y + promptLine, prompt[i..i+1], dialogFg, dialogBg);
        }
        
        // Draw input field
        uint inputLine = 5;
        print(x + 2, y + inputLine, "│", dialogFg, dialogBg);
        
        string display = inputText.length < width - 6 ? inputText : inputText[$-(width-6)..$];
        for (uint i = 0; i < cast(uint)display.length && i < width - 6; i++) {
            string ch = (i == cursorPos && visible) ? "█" : (display[i] ~ "");
            print(x + 3 + i, y + inputLine, ch, dialogFg, inputBg);
        }
        
        // Clear remaining input
        for (uint i = cast(uint)display.length; i < width - 6; i++) {
            print(x + 3 + i, y + inputLine, " ", dialogFg, inputBg);
        }
        
        print(x + width - 3, y + inputLine, "│", dialogFg, dialogBg);
        
        // Draw buttons
        string okBtn = "[ OK ]";
        string cancelBtn = "[ Cancel ]";
        uint btnY = height - 2;
        uint okX = x + 4;
        uint cancelX = x + width - 13;
        
        for (uint i = 0; i < okBtn.length; i++) {
            print(okX + i, y + btnY, okBtn[i..i+1], Color.black(), Color.cyan());
        }
        
        for (uint i = 0; i < cancelBtn.length; i++) {
            print(cancelX + i, y + btnY, cancelBtn[i..i+1], dialogFg, dialogBg);
        }
        
        // Draw side borders
        for (uint i = 1; i < height - 1; i++) {
            print(x, y + i, "│", dialogFg, dialogBg);
            print(x + width - 1, y + i, "│", dialogFg, dialogBg);
        }
        
        // Draw bottom border
        print(x, y + height - 1, "└", dialogFg, dialogBg);
        for (uint i = 1; i < width - 1; i++) print(x + i, y + height - 1, "─", dialogFg, dialogBg);
        print(x + width - 1, y + height - 1, "┘", dialogFg, dialogBg);
    }
}
