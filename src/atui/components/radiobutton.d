/// RadioButton component - Mutually exclusive options
module atui.components.radiobutton;

import atui.api.tui;
import atui.api.input;

public class RadioButton {
    uint x, y;
    string label;
    int groupId;
    bool selected = false;
    bool focused = false;
    static int[int] selectedIndex;  // groupId -> selected index
    void delegate() onChanged;
    Color fgColor = Color.white();
    Color bgColor = Color.black();
    
    this(uint x, uint y, string label, int groupId, bool initialState = false) {
        this.x = x;
        this.y = y;
        this.label = label;
        this.groupId = groupId;
        this.selected = initialState;
    }
    
    void setSelected(bool state) { 
        if (state && !selected) {
            selected = true;
            if (onChanged) onChanged();
        } else if (!state && selected) {
            selected = false;
        }
    }
    bool isSelected() const { return selected; }
    void setFocus(bool f) { focused = f; }
    
    void handleInput(InputEvent event) {
        if (event.type != InputEventType.KeyPress) return;
        
        if (event.keyData.keyChar == ' ' || event.keyData.specialKey == SpecialKey.Enter) {
            if (!selected) {
                selected = true;
                if (onChanged) onChanged();
            }
        }
    }
    
    void render() {
        auto fg = focused ? Color.black() : fgColor;
        auto bg = focused ? Color.white() : bgColor;
        
        string indicator = selected ? "(●) " : "(○) ";
        string displayText = indicator ~ label;
        print(x, y, displayText, fg, bg);
    }
}
