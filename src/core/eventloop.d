/**
 * Event Loop - Core polling mechanism
 * 
 * Handles the main loop: Poll Input → Update State → Render
 */

module atui.core.eventloop;

import core.time : Duration, msecs;
import std.datetime : Clock;

/// Event loop that drives the application
public class EventLoop {
    private bool running = false;
    private Duration frameTime = 16.msecs; // ~60 FPS
    private long frameCount = 0;

    /// Start the event loop
    public void start() {
        running = true;
        mainLoop();
    }

    /// Stop the event loop
    public void stop() {
        running = false;
    }

    /// Set target frame time (in milliseconds)
    public void setFrameTime(Duration time) {
        frameTime = time;
    }

    /// Get current frame count
    public long getFrameCount() const {
        return frameCount;
    }

    private void mainLoop() {
        auto lastTime = Clock.currTime();

        while (running) {
            auto currentTime = Clock.currTime();
            auto deltaTime = currentTime - lastTime;
            lastTime = currentTime;

            // Poll input events
            pollInput();

            // Update application state
            updateState(deltaTime);

            // Render TUI
            render();

            frameCount++;

            // Frame rate limiting
            if (deltaTime < frameTime) {
                import core.thread : Thread;
                Thread.sleep(frameTime - deltaTime);
            }
        }
    }

    private void pollInput() {
        // TODO: Delegate to PAL input handler
    }

    private void updateState(Duration deltaTime) {
        // TODO: Update application state
    }

    private void render() {
        // TODO: Delegate to PAL renderer
    }
}
