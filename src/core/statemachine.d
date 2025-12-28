/**
 * State Machine - Application lifecycle management
 */

module atui.core.statemachine;

import std.exception : enforce;

/// Application states
public enum AppState {
    Initial,
    Initialized,
    Running,
    Paused,
    Stopped,
    Error
}

/// State machine for application lifecycle
public class StateMachine {
    private AppState currentState = AppState.Initial;
    private void delegate(AppState, AppState)[] stateChangeCallbacks;

    /// Transition to a new state
    public void transition(AppState newState) {
        if (currentState == newState) return;

        auto oldState = currentState;
        currentState = newState;

        // Notify all state change listeners
        foreach (callback; stateChangeCallbacks) {
            callback(oldState, newState);
        }
    }

    /// Get current state
    public AppState getCurrentState() const {
        return currentState;
    }

    /// Register a callback for state transitions
    public void onStateChange(void delegate(AppState, AppState) callback) {
        stateChangeCallbacks ~= callback;
    }

    /// Check if in a specific state
    public bool isInState(AppState state) const {
        return currentState == state;
    }
}
