/// Checkbox component - Boolean toggle
module atui.components.checkbox;

import atui.api.tui;
import atui.api.input;

public class Checkbox {
    uint x, y;
    string label;
    bool checked = false;
    bool focused = false;
    void delegate() onChanged;
    Color fgColor = Color.white();
    Color bgColor = Color.black();
    
    this(uint x, uint y, string label, bool initialState = false) {
        this.x = x;
        this.y = y;
        this.label = label;
        this.checked = initialState;
    }
    
    void setChecked(bool state) { 
        if (state != checked) {
            checked = state;
            if (onChanged) onChanged();
        }
    }
    bool isChecked() const { return checked; }
    void setFocus(bool f) { focused = f; }
    
    void handleInput(InputEvent event) {
        if (event.type != InputEventType.KeyPress) return;
        
        if (event.keyData.keyChar == ' ' || event.keyData.specialKey == SpecialKey.Enter) {
            checked = !checked;
            if (onChanged) onChanged();
        }
    }
    
    void render() {
        auto fg = focused ? Color.black() : fgColor;
        auto bg = focused ? Color.white() : bgColor;
        
        string checkmark = checked ? "[X] " : "[ ] ";
        string displayText = checkmark ~ label;
        print(x, y, displayText, fg, bg);
    }
}
