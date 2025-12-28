/// Simple panel component
module atui.components.panel;

import atui.api.tui;
import atui.api.input;

public class Panel {
    uint x, y, width, height;
    string title;
    Color fgColor = Color.white();
    Color bgColor = Color.black();
    
    this(uint x, uint y, uint width, uint height, string title = "") {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        this.title = title;
    }
    
    void render() {
        // Top border
        print(x, y, "┌", fgColor, bgColor);
        for (uint i = 1; i < width - 1; i++) {
            print(x + i, y, "─", fgColor, bgColor);
        }
        print(x + width - 1, y, "┐", fgColor, bgColor);
        
        // Side borders
        for (uint i = 1; i < height - 1; i++) {
            print(x, y + i, "│", fgColor, bgColor);
            print(x + width - 1, y + i, "│", fgColor, bgColor);
        }
        
        // Bottom border
        if (height > 1) {
            print(x, y + height - 1, "└", fgColor, bgColor);
            for (uint i = 1; i < width - 1; i++) {
                print(x + i, y + height - 1, "─", fgColor, bgColor);
            }
            print(x + width - 1, y + height - 1, "┘", fgColor, bgColor);
        }
    }
}
