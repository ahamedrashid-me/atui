/// Simple button component
module atui.components.button;

import atui.api.tui;
import atui.api.input;
import std.string : format;

public class Button {
    uint x, y;
    string label;
    bool focused;
    Color fgColor = Color.white();
    Color bgColor = Color.cyan();
    Color focusedFg = Color.black();
    Color focusedBg = Color.white();
    void delegate() onClick;
    
    this(uint x, uint y, string label) {
        this.x = x;
        this.y = y;
        this.label = label;
    }
    
    void setFocus(bool f) { focused = f; }
    void handleInput(InputEvent event) {
        if (event.type == InputEventType.KeyPress) {
            if (event.keyData.keyChar == ' ' || event.keyData.specialKey == SpecialKey.Enter) {
                if (onClick) onClick();
            }
        }
    }
    
    void render() {
        auto fg = focused ? focusedFg : fgColor;
        auto bg = focused ? focusedBg : bgColor;
        auto text = format("[ %s ]", label);
        print(x, y, text, fg, bg);
    }
}
