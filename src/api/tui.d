/**
 * TUI Graphics API
 * 
 * Provides rendering primitives for text-based UIs.
 * Uses a logical screen buffer with double buffering.
 */

module atui.api.tui;

import std.stdint;

/// Color representation (RGBA)
public struct Color {
    uint8_t r;
    uint8_t g;
    uint8_t b;
    uint8_t a = 255;

    this(uint8_t r_, uint8_t g_, uint8_t b_, uint8_t a_ = 255) {
        r = r_; g = g_; b = b_; a = a_;
    }

    static Color white() { return Color(255, 255, 255); }
    static Color black() { return Color(0, 0, 0); }
    static Color red() { return Color(255, 0, 0); }
    static Color green() { return Color(0, 255, 0); }
    static Color blue() { return Color(0, 0, 255); }
    static Color yellow() { return Color(255, 255, 0); }
    static Color cyan() { return Color(0, 255, 255); }
    static Color magenta() { return Color(255, 0, 255); }
}

/// A single cell in the logical screen buffer
public struct Cell {
    dchar glyph;
    Color foreground;
    Color background;
}

/// Logical screen buffer (double-buffered)
public class ScreenBuffer {
    private Cell[][] buffer;
    private uint width;
    private uint height;
    private Cell[][] backbuffer;

    public this(uint width, uint height) {
        this.width = width;
        this.height = height;
        buffer = new Cell[][](height, width);
        backbuffer = new Cell[][](height, width);
        clear();
    }

    /// Write a glyph at position (x, y)
    public void putChar(uint x, uint y, dchar glyph, Color fg, Color bg) {
        if (x >= width || y >= height) return;
        backbuffer[y][x] = Cell(glyph, fg, bg);
    }

    /// Write text string at position (x, y)
    public void putString(uint x, uint y, string text, Color fg, Color bg) {
        foreach (size_t i, dchar ch; text) {
            putChar(cast(uint)(x + i), y, ch, fg, bg);
        }
    }

    /// Clear the screen
    public void clear() {
        foreach (y; 0..height) {
            foreach (x; 0..width) {
                backbuffer[y][x] = Cell(' ', Color.white(), Color.black());
            }
        }
    }

    /// Swap front and back buffers
    public void present() {
        auto temp = buffer;
        buffer = backbuffer;
        backbuffer = temp;
    }

    /// Get dimensions
    public void getSize(out uint w, out uint h) const {
        w = width;
        h = height;
    }

    /// Detect changed cells for efficient rendering
    public Cell[] getDiffCells(out uint[] changedIndices) {
        Cell[] changes;
        foreach (i; 0..width*height) {
            uint y = i / width;
            uint x = i % width;
            if (buffer[y][x].glyph != backbuffer[y][x].glyph ||
                buffer[y][x].foreground.red != backbuffer[y][x].foreground.red) {
                changes ~= backbuffer[y][x];
                changedIndices ~= i;
            }
        }
        return changes;
    }
}

/// Global screen buffer instance
private __gshared ScreenBuffer _screenBuffer;

/// Initialize the TUI system
public void initTUI(uint width, uint height) {
    if (_screenBuffer is null) {
        _screenBuffer = new ScreenBuffer(width, height);
    }
}

/// Get the global screen buffer
public ScreenBuffer getScreenBuffer() {
    if (_screenBuffer is null) {
        initTUI(80, 24);
    }
    return _screenBuffer;
}

/// Print text to the TUI
public void print(uint x, uint y, string text, Color fg = Color.white(), Color bg = Color.black()) {
    getScreenBuffer().putString(x, y, text, fg, bg);
}

/// Clear the screen
public void clear() {
    getScreenBuffer().clear();
}

/// Refresh the display
public void refresh() {
    getScreenBuffer().present();
}
