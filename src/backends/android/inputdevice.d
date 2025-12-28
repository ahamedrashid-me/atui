/**
 * Android Backend - Input Handler
 * 
 * Handles touch events and system input on Android.
 */

module atui.backends.android.inputdevice;

import atui.pal.inputdevice : IInputDevice;
import atui.api.input : InputEvent, InputEventType, SpecialKey;

/// Android touch and key input handler
public class AndroidInputDevice : IInputDevice {
    private InputEvent[] eventQueue;
    private bool initialized = false;

    override public void initialize() {
        if (initialized) return;
        // TODO: Register input listeners with Android framework
        initialized = true;
    }

    override public InputEvent[] pollEvents() {
        InputEvent[] result = eventQueue.dup;
        eventQueue.length = 0;
        return result;
    }

    override public bool hasEvents() {
        return eventQueue.length > 0;
    }

    override public void shutdown() {
        // TODO: Unregister input listeners
        initialized = false;
    }

    /// Called from JNI when touch event occurs
    public void onTouchEvent(int action, float x, float y, int pointerId) {
        InputEvent event;
        event.type = cast(InputEventType)action;
        event.touchData.x = cast(uint)x;
        event.touchData.y = cast(uint)y;
        event.touchData.pointerId = pointerId;
        eventQueue ~= event;
    }

    /// Called from JNI when key event occurs
    public void onKeyEvent(int keyCode, bool pressed) {
        InputEvent event;
        event.type = pressed ? InputEventType.KeyPress : InputEventType.KeyRelease;
        event.keyData.specialKey = cast(SpecialKey)mapAndroidKeyCode(keyCode);
        eventQueue ~= event;
    }

    private SpecialKey mapAndroidKeyCode(int code) {
        // TODO: Map Android key codes to SpecialKey enum
        return SpecialKey.None;
    }
}
