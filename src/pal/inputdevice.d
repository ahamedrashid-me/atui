/**
 * Input Device Interface
 * 
 * Abstract interface for input backends.
 */

module atui.pal.inputdevice;

import atui.api.input : InputEvent;

/// Input device interface
public interface IInputDevice {
    /// Initialize the input device
    void initialize();

    /// Poll for input events
    InputEvent[] pollEvents();

    /// Check if events are available
    bool hasEvents();

    /// Shutdown input device
    void shutdown();
}

/// Global input device instance
private __gshared IInputDevice _inputDevice;

/// Set the active input device
public void setInputDevice(IInputDevice device) {
    _inputDevice = device;
    if (_inputDevice) _inputDevice.initialize();
}

/// Get the active input device
public IInputDevice getInputDevice() {
    return _inputDevice;
}
