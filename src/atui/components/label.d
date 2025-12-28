/// Simple label component
module atui.components.label;

import atui.api.tui;
import atui.api.input;

public class Label {
    uint x, y;
    string text;
    Color fgColor = Color.white();
    Color bgColor = Color.black();
    
    this(uint x, uint y, string text) {
        this.x = x;
        this.y = y;
        this.text = text;
    }
    
    void setText(string newText) { this.text = newText; }
    void setColor(Color fg, Color bg) { this.fgColor = fg; this.bgColor = bg; }
    void render() { print(x, y, text, fgColor, bgColor); }
}
