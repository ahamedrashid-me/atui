/**
 * Linux Backend - Input Handler (evdev + Terminal)
 */

module atui.backends.linux.inputdevice;

import atui.pal.inputdevice : IInputDevice;
import atui.api.input : InputEvent, InputEventType, SpecialKey;
import std.stdio : File, stdin;
import core.sys.posix.termios : termios, tcgetattr, tcsetattr, TCSANOW;
import core.sys.posix.fcntl : fcntl, F_SETFL, F_GETFL, O_NONBLOCK;
import core.sys.posix.unistd : read;

/// Terminal input device handler using stdin
public class TerminalInputDevice : IInputDevice {
    private InputEvent[] eventQueue;
    private bool initialized = false;
    private termios originalSettings;
    private termios rawSettings;

    override public void initialize() {
        if (initialized) return;
        
        // Save original terminal settings
        tcgetattr(0, &originalSettings);
        rawSettings = originalSettings;
        
        // Disable canonical mode and echo
        rawSettings.c_lflag &= ~(cast(uint)0x00000001); // ICANON
        rawSettings.c_lflag &= ~(cast(uint)0x00000008); // ECHO
        rawSettings.c_cc[6] = 0; // VMIN = 0
        rawSettings.c_cc[5] = 0; // VTIME = 0
        
        tcsetattr(0, TCSANOW, &rawSettings);
        
        // Set non-blocking mode
        int flags = fcntl(0, F_GETFL, 0);
        fcntl(0, F_SETFL, flags | O_NONBLOCK);
        
        initialized = true;
    }

    override public InputEvent[] pollEvents() {
        InputEvent[] result = eventQueue.dup;
        eventQueue.length = 0;
        
        // Try to read from stdin
        ubyte[1] buffer;
        int bytesRead = cast(int)read(0, buffer.ptr, 1);
        
        if (bytesRead > 0) {
            InputEvent event;
            event.type = InputEventType.KeyPress;
            event.keyData.keyChar = cast(char)buffer[0];
            
            // Map special keys
            if (buffer[0] == 27) { // Escape
                event.keyData.specialKey = SpecialKey.Escape;
            } else if (buffer[0] == 13) { // Enter
                event.keyData.specialKey = SpecialKey.Enter;
            } else if (buffer[0] == 8 || buffer[0] == 127) { // Backspace
                event.keyData.specialKey = SpecialKey.Backspace;
            } else if (buffer[0] == 9) { // Tab
                event.keyData.specialKey = SpecialKey.Tab;
            }
            
            eventQueue ~= event;
            result ~= event;
        }
        
        return result;
    }

    override public bool hasEvents() {
        return eventQueue.length > 0;
    }

    override public void shutdown() {
        if (initialized) {
            // Restore original terminal settings
            tcsetattr(0, TCSANOW, &originalSettings);
            initialized = false;
        }
    }
}
