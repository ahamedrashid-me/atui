/**
 * Input API
 * 
 * Unified input model that abstracts platform differences.
 * Provides: key events, touch events, system events.
 */

module atui.api.input;

import std.stdint;

/// Input event types
public enum InputEventType {
    KeyPress,
    KeyRelease,
    TouchStart,
    TouchMove,
    TouchEnd,
    MouseClick,
    MouseDoubleClick,
    MouseDrag,
    MouseRelease,
    SystemEvent
}

/// Special keys
public enum SpecialKey {
    Enter,
    Escape,
    Backspace,
    Tab,
    ArrowUp,
    ArrowDown,
    ArrowLeft,
    ArrowRight,
    Delete,
    Home,
    End,
    PageUp,
    PageDown,
    None
}

/// Input event structure
public struct InputEvent {
    InputEventType type;
    KeyEventData keyData;
    TouchEventData touchData;
    MouseEventData mouseData;
    SystemEventData systemData;
}

public struct KeyEventData {
    char keyChar;
    SpecialKey specialKey;
    bool isShiftPressed;
    bool isCtrlPressed;
    bool isAltPressed;
}

public struct TouchEventData {
    uint x;
    uint y;
    uint pointerId;
}

public struct MouseEventData {
    uint x;
    uint y;
    ubyte button;  // 0=left, 1=middle, 2=right
    bool shiftKey;
    bool ctrlKey;
    bool altKey;
}

public struct SystemEventData {
    string eventName;
}

/// Input handler
public class InputHandler {
    private InputEvent[] eventQueue;
    private bool initialized = false;

    public this() {
        initialized = true;
    }

    /// Queue an input event
    public void queueEvent(InputEvent event) {
        eventQueue ~= event;
    }

    /// Get next event without removing it
    public InputEvent peekEvent() {
        if (eventQueue.length > 0) {
            return eventQueue[0];
        }
        return InputEvent();
    }

    /// Get and remove next event
    public InputEvent pollEvent() {
        if (eventQueue.length > 0) {
            auto event = eventQueue[0];
            eventQueue = eventQueue[1..$];
            return event;
        }
        return InputEvent();
    }

    /// Check if events are available
    public bool hasEvents() const {
        return eventQueue.length > 0;
    }

    /// Clear event queue
    public void clearQueue() {
        eventQueue.length = 0;
    }
}

/// Global input handler
private __gshared InputHandler _inputHandler;

/// Get the global input handler
public InputHandler getInputHandler() {
    if (_inputHandler is null) {
        _inputHandler = new InputHandler();
    }
    return _inputHandler;
}

/// Read next key from input
public InputEvent readInput() {
    return getInputHandler().pollEvent();
}
