/// Progress bar component
module atui.components.progressbar;

import atui.api.tui;
import atui.api.input;
import std.string : format;

public class ProgressBar {
    uint x, y, width;
    float progress = 0.0f;
    string label;
    Color fgColor = Color.cyan();
    Color bgColor = Color.black();
    
    this(uint x, uint y, uint width) {
        this.x = x;
        this.y = y;
        this.width = width;
    }
    
    void setProgress(float p) { 
        progress = p < 0.0f ? 0.0f : (p > 1.0f ? 1.0f : p);
    }
    
    void render() {
        uint filledWidth = cast(uint)(width * progress);
        if (filledWidth > width) filledWidth = width;
        
        string bar = "[";
        for (uint i = 0; i < width - 2; i++) {
            bar ~= (i < filledWidth) ? "█" : "░";
        }
        bar ~= "]";
        
        int percent = cast(int)(progress * 100);
        string text = format("%-*s %3d%%", width + 2, bar, percent);
        print(x, y, text, fgColor, bgColor);
    }
}
