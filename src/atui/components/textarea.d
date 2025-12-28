/// TextArea component - Multi-line text editor
module atui.components.textarea;

import atui.api.tui;
import atui.api.input;
import std.string : format;

public class TextArea {
    uint x, y, width, height;
    string[] lines;
    uint cursorLine = 0;
    uint cursorCol = 0;
    uint scrollLine = 0;
    bool focused = false;
    void delegate() onChanged;
    Color fgColor = Color.white();
    Color bgColor = Color.black();
    Color cursorColor = Color.cyan();
    
    this(uint x, uint y, uint width, uint height) {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        lines ~= "";
    }
    
    void setText(string text) {
        lines.length = 0;
        uint pos = 0;
        while (pos < text.length) {
            auto nl = pos;
            while (nl < text.length && text[nl] != '\n') nl++;
            lines ~= text[pos..nl].idup;
            pos = nl + 1;
        }
        if (lines.length == 0) lines ~= "";
        cursorLine = 0;
        cursorCol = 0;
        scrollLine = 0;
    }
    
    string getText() const {
        string result;
        foreach (i, line; lines) {
            result ~= line;
            if (i < cast(int)lines.length - 1) result ~= "\n";
        }
        return result;
    }
    
    void setFocus(bool f) { focused = f; }
    
    void handleInput(InputEvent event) {
        if (event.type != InputEventType.KeyPress) return;
        
        char ch = event.keyData.keyChar;
        
        // Character input
        if (ch >= 32 && ch < 127 && cursorLine < lines.length) {
            string line = lines[cursorLine];
            if (cursorCol <= line.length) {
                lines[cursorLine] = line[0..cursorCol] ~ ch ~ line[cursorCol..$];
                cursorCol++;
                if (onChanged) onChanged();
            }
        } else {
            // Special keys
            auto key = event.keyData.specialKey;
            
            if (key == SpecialKey.Backspace && cursorCol > 0 && cursorLine < lines.length) {
                string line = lines[cursorLine];
                lines[cursorLine] = line[0..cursorCol-1] ~ line[cursorCol..$];
                cursorCol--;
                if (onChanged) onChanged();
            } else if (key == SpecialKey.Enter && cursorLine < lines.length) {
                string line = lines[cursorLine];
                string nextPart = line[cursorCol..$];
                lines[cursorLine] = line[0..cursorCol];
                lines = lines[0..cursorLine+1] ~ [nextPart] ~ lines[cursorLine+1..$];
                cursorLine++;
                cursorCol = 0;
                if (onChanged) onChanged();
            } else if (key == SpecialKey.ArrowUp && cursorLine > 0) {
                cursorLine--;
                if (cursorCol > cast(uint)lines[cursorLine].length) {
                    cursorCol = cast(uint)lines[cursorLine].length;
                }
                if (cursorLine < scrollLine) scrollLine = cursorLine;
            } else if (key == SpecialKey.ArrowDown && cursorLine < cast(int)lines.length - 1) {
                cursorLine++;
                if (cursorCol > cast(uint)lines[cursorLine].length) {
                    cursorCol = cast(uint)lines[cursorLine].length;
                }
                if (cursorLine >= scrollLine + height - 2) {
                    scrollLine = cursorLine - height + 3;
                }
            } else if (key == SpecialKey.ArrowLeft && cursorCol > 0) {
                cursorCol--;
            } else if (key == SpecialKey.ArrowRight && cursorLine < lines.length) {
                if (cursorCol < lines[cursorLine].length) cursorCol++;
            }
        }
    }
    
    void render() {
        // Draw border
        print(x, y, "┌", fgColor, bgColor);
        for (uint i = 1; i < width - 1; i++) print(x + i, y, "─", fgColor, bgColor);
        print(x + width - 1, y, "┐", fgColor, bgColor);
        
        // Draw text lines
        for (uint i = 0; i < height - 2 && scrollLine + i < cast(uint)lines.length; i++) {
            print(x, y + i + 1, "│", fgColor, bgColor);
            
            string line = lines[scrollLine + i];
            for (uint j = 0; j < width - 2 && j < cast(uint)line.length; j++) {
                string displayChar = (scrollLine + i == cursorLine && j == cursorCol && focused) ? "█" : (line[j] ~ "");
                print(x + j + 1, y + i + 1, displayChar, fgColor, bgColor);
            }
            
            // Clear rest of line
            for (uint j = cast(uint)line.length; j < width - 2; j++) {
                print(x + j + 1, y + i + 1, " ", fgColor, bgColor);
            }
            
            print(x + width - 1, y + i + 1, "│", fgColor, bgColor);
        }
        
        // Clear remaining lines
        for (uint i = (scrollLine + height - 2 < cast(uint)lines.length ? height - 2 : cast(uint)lines.length - scrollLine); 
             i < height - 2; i++) {
            print(x, y + i + 1, "│", fgColor, bgColor);
            for (uint j = 0; j < width - 2; j++) {
                print(x + j + 1, y + i + 1, " ", fgColor, bgColor);
            }
            print(x + width - 1, y + i + 1, "│", fgColor, bgColor);
        }
        
        // Draw bottom border
        print(x, y + height - 1, "└", fgColor, bgColor);
        for (uint i = 1; i < width - 1; i++) print(x + i, y + height - 1, "─", fgColor, bgColor);
        print(x + width - 1, y + height - 1, "┘", fgColor, bgColor);
    }
}
