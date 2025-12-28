/// Combobox component - Dropdown selection
module atui.components.combobox;

import atui.api.tui;
import atui.api.input;
import std.string : format;

public class Combobox {
    uint x, y, width;
    string[] options;
    int selectedIndex = 0;
    bool expanded = false;
    bool focused = false;
    void delegate() onChanged;
    Color fgColor = Color.white();
    Color bgColor = Color.black();
    Color dropdownBg = Color.blue();
    
    this(uint x, uint y, uint width) {
        this.x = x;
        this.y = y;
        this.width = width;
    }
    
    void setOptions(string[] opts) {
        options = opts.dup;
        selectedIndex = 0;
    }
    
    void addOption(string opt) {
        options ~= opt;
    }
    
    int getSelectedIndex() { return selectedIndex; }
    string getSelectedOption() {
        return (selectedIndex >= 0 && selectedIndex < cast(int)options.length) ? options[selectedIndex] : "";
    }
    
    void setFocus(bool f) { focused = f; }
    
    void handleInput(InputEvent event) {
        if (event.type != InputEventType.KeyPress) return;
        
        if (!expanded) {
            if (event.keyData.keyChar == ' ' || event.keyData.specialKey == SpecialKey.Enter) {
                expanded = true;
            }
        } else {
            if (event.keyData.specialKey == SpecialKey.ArrowDown && 
                selectedIndex < cast(int)options.length - 1) {
                selectedIndex++;
                if (onChanged) onChanged();
            } else if (event.keyData.specialKey == SpecialKey.ArrowUp && selectedIndex > 0) {
                selectedIndex--;
                if (onChanged) onChanged();
            } else if (event.keyData.keyChar == ' ' || event.keyData.specialKey == SpecialKey.Enter) {
                expanded = false;
            } else if (event.keyData.specialKey == SpecialKey.Escape) {
                expanded = false;
            }
        }
    }
    
    void render() {
        auto fg = focused ? Color.black() : fgColor;
        auto bg = focused ? Color.cyan() : bgColor;
        
        if (!expanded) {
            // Closed state
            string displayText = getSelectedOption();
            if (displayText.length > width - 3) displayText = displayText[0..width-3];
            string text = format("%-*s v", width - 1, displayText);
            print(x, y, text, fg, bg);
        } else {
            // Expanded dropdown
            for (uint i = 0; i < options.length && i < 5; i++) {
                bool isSelected = (cast(int)i == selectedIndex);
                auto optFg = isSelected ? Color.black() : fgColor;
                auto optBg = isSelected ? Color.white() : dropdownBg;
                
                string opt = options[i];
                if (opt.length > width - 2) opt = opt[0..width-2];
                string text = format("%-*s", width, opt);
                print(x, y + i, text, optFg, optBg);
            }
        }
    }
}
