/**
 * Linux Backend - Framebuffer/TTY Renderer
 * 
 * Renders to /dev/fb0 (framebuffer) or uses ANSI escape codes for terminal.
 */

module atui.backends.linux.renderer;

import atui.pal.renderer : AbstractRenderer;
import atui.api.tui : Cell;
import std.stdio : File, stdout, write, writef;
import std.format : format;

/// Terminal ANSI-based renderer
public class AnsiTerminalRenderer : AbstractRenderer {
    private bool initialized = false;
    private Cell[][] lastFrame;

    override public void initialize() {
        if (initialized) return;
        // Clear terminal and hide cursor
        write("\x1b[2J"); // Clear screen
        write("\x1b[?25l"); // Hide cursor
        write("\x1b[H"); // Home
        initialized = true;
    }

    override public void drawCell(uint x, uint y, Cell cell) {
        if (x >= width || y >= height) return;
        
        // Move cursor to position and draw cell with colors
        writef("\x1b[%d;%dH", y + 1, x + 1);
        writef("\x1b[38;2;%d;%d;%dm", cell.foreground.r, cell.foreground.g, cell.foreground.b);
        writef("\x1b[48;2;%d;%d;%dm", cell.background.r, cell.background.g, cell.background.b);
        write(cell.glyph);
    }

    override public void drawBuffer(Cell[][] buffer) {
        if (buffer.length == 0) return;
        
        write("\x1b[2J\x1b[H"); // Clear and home
        foreach (y; 0..buffer.length) {
            foreach (x; 0..buffer[y].length) {
                if (x > 0) write(" ");
                auto cell = buffer[y][x];
                writef("\x1b[38;2;%d;%d;%d;48;2;%d;%d;%dm%c\x1b[0m",
                    cell.foreground.r, cell.foreground.g, cell.foreground.b,
                    cell.background.r, cell.background.g, cell.background.b,
                    cell.glyph);
            }
            write("\r\n");
        }
    }

    override public void clear() {
        write("\x1b[2J\x1b[H");
    }

    override public void present() {
        stdout.flush();
    }

    override public void shutdown() {
        write("\x1b[?25h"); // Show cursor
        write("\x1b[0m"); // Reset colors
        write("\x1b[2J\x1b[H"); // Clear screen
        initialized = false;
    }
}

/// Framebuffer renderer for direct hardware access
public class FramebufferRenderer : AbstractRenderer {
    private File fbdev;
    private ubyte[] frameBuffer;
    private bool initialized = false;

    override public void initialize() {
        if (initialized) return;
        try {
            fbdev = File("/dev/fb0", "r+b");
            // TODO: Get actual framebuffer dimensions from ioctl
            // For now, assume 1920x1080 @ 32bpp
            width = 1920;
            height = 1080;
            frameBuffer = new ubyte[width * height * 4];
            initialized = true;
        } catch (Throwable t) {
            // Fallback to ANSI terminal if framebuffer unavailable
        }
    }

    override public void drawCell(uint x, uint y, Cell cell) {
        if (!initialized) return;
        // TODO: Convert cell to pixels and draw to framebuffer
        // This is complex as we need font rendering
    }

    override public void drawBuffer(Cell[][] buffer) {
        if (!initialized) return;
        // TODO: Render entire buffer
    }

    override public void clear() {
        if (!initialized) return;
        // TODO: Framebuffer clear
    }

    override public void present() {
        if (!initialized) return;
        try {
            fbdev.rawWrite(frameBuffer);
            fbdev.flush();
        } catch (Throwable t) {
            // Ignore write errors
        }
    }

    override public void shutdown() {
        if (fbdev.isOpen()) fbdev.close();
        initialized = false;
    }
}
