/// Simple text input component
module atui.components.textinput;

import atui.api.tui;
import atui.api.input;

public class TextInput {
    uint x, y, width;
    string content;
    uint cursorPos;
    bool focused;
    void delegate() onChanged;
    
    this(uint x, uint y, uint width) {
        this.x = x;
        this.y = y;
        this.width = width;
    }
    
    void setText(string text) { this.content = text; cursorPos = 0; }
    string getText() { return content; }
    void setFocus(bool f) { focused = f; }
    
    void handleInput(InputEvent event) {
        if (event.type != InputEventType.KeyPress) return;
        
        char ch = event.keyData.keyChar;
        if (ch >= 32 && ch < 127 && content.length < width - 2) {
            content ~= ch;
            if (onChanged) onChanged();
        } else if (event.keyData.specialKey == SpecialKey.Backspace && content.length > 0) {
            content = content[0..$-1];
            if (onChanged) onChanged();
        }
    }
    
    void render() {
        Color bg = focused ? Color.blue() : Color.black();
        Color fg = Color.white();
        
        print(x, y, "|", fg, bg);
        string display = content.length < width - 2 ? content : content[$-(width-2)..$];
        print(x + 1, y, display, fg, bg);
        
        // Fill remaining
        for (uint i = cast(uint)content.length + 1; i < width - 1; i++) {
            print(x + i, y, " ", fg, bg);
        }
        print(x + width - 1, y, "|", fg, bg);
    }
}
