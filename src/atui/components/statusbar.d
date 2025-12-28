/// Status bar component
module atui.components.statusbar;

import atui.api.tui;
import atui.api.input;

public class StatusBar {
    uint x, y, width;
    string[] segments;
    Color fgColor = Color.black();
    Color bgColor = Color.cyan();
    
    this(uint x, uint y, uint width) {
        this.x = x;
        this.y = y;
        this.width = width;
    }
    
    void setSegments(string[] labels) {
        segments = labels.dup;
    }
    
    void setSegment(int index, string text) {
        if (index >= 0 && index < cast(int)segments.length) {
            segments[index] = text;
        }
    }
    
    void render() {
        uint segWidth = width / (segments.length > 0 ? segments.length : 1);
        
        for (uint i = 0; i < segments.length; i++) {
            string text = segments[i];
            if (text.length > segWidth) text = text[0..segWidth];
            while (text.length < segWidth) text ~= " ";
            
            print(x + i * segWidth, y, text, fgColor, bgColor);
        }
    }
}
