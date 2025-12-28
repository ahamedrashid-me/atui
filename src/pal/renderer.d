/**
 * Renderer Interface
 * 
 * Abstract interface for rendering backends (Framebuffer, OpenGL ES, ANSI).
 */

module atui.pal.renderer;

import atui.api.tui : Cell;

/// Renderer interface that backends must implement
public interface IRenderer {
    /// Initialize the renderer
    void initialize();

    /// Render a single cell at (x, y)
    void drawCell(uint x, uint y, Cell cell);

    /// Render entire buffer
    void drawBuffer(Cell[][] buffer);

    /// Clear the display
    void clear();

    /// Swap buffers / present to screen
    void present();

    /// Get display dimensions
    void getSize(out uint width, out uint height);

    /// Shutdown renderer
    void shutdown();
}

/// Abstract renderer class
public abstract class AbstractRenderer : IRenderer {
    protected uint width = 80;
    protected uint height = 24;

    public void getSize(out uint w, out uint h) {
        w = width;
        h = height;
    }

    public abstract void initialize();
    public abstract void drawCell(uint x, uint y, Cell cell);
    public abstract void drawBuffer(Cell[][] buffer);
    public abstract void clear();
    public abstract void present();
    public abstract void shutdown();
}

/// Global renderer instance
private __gshared IRenderer _renderer;

/// Set the active renderer
public void setRenderer(IRenderer renderer) {
    _renderer = renderer;
    if (_renderer) _renderer.initialize();
}

/// Get the active renderer
public IRenderer getRenderer() {
    return _renderer;
}
