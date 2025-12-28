/// Simple list component
module atui.components.list;

import atui.api.tui;
import atui.api.input;
import std.string : format;

public class List {
    uint x, y, width, height;
    string[] items;
    int selectedIndex = 0;
    bool focused;
    void delegate() onChanged;
    
    this(uint x, uint y, uint width, uint height) {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }
    
    void addItem(string item) { items ~= item; }
    int getSelectedIndex() { return selectedIndex; }
    string getSelectedItem() { return selectedIndex >= 0 && selectedIndex < items.length ? items[selectedIndex] : ""; }
    void setFocus(bool f) { focused = f; }
    
    void handleInput(InputEvent event) {
        if (event.type != InputEventType.KeyPress || items.length == 0) return;
        
        if (event.keyData.specialKey == SpecialKey.ArrowDown && selectedIndex < cast(int)items.length - 1) {
            selectedIndex++;
            if (onChanged) onChanged();
        } else if (event.keyData.specialKey == SpecialKey.ArrowUp && selectedIndex > 0) {
            selectedIndex--;
            if (onChanged) onChanged();
        }
    }
    
    void render() {
        Color bg = focused ? Color.white() : Color.black();
        Color fg = focused ? Color.black() : Color.white();
        
        for (uint i = 0; i < height && i < items.length; i++) {
            bool isSelected = (cast(int)i == selectedIndex);
            auto itemBg = isSelected ? Color.cyan() : bg;
            auto itemFg = isSelected ? Color.black() : fg;
            
            string display = format("%-*s", width - 1, items[i]);
            if (display.length > width) display = display[0..width];
            print(x, y + i, display, itemFg, itemBg);
        }
    }
}
