/**
 * Core Runtime Engine - Central event loop and scheduler
 * 
 * Responsibilities:
 * - Event loop: Poll Input → Update State → Render TUI
 * - Scheduler: Manage task execution and timing
 * - State machine: Track application lifecycle
 */

module atui.core.runtime;

import atui.core.eventloop : EventLoop;
import atui.core.scheduler : Scheduler;
import atui.core.statemachine : StateMachine, AppState;

/// Main runtime engine for ATUI framework
public class AtuiRuntime {
    private EventLoop eventLoop;
    private Scheduler scheduler;
    private StateMachine stateMachine;
    private bool initialized = false;

    /// Initialize the runtime
    public void initialize() {
        if (initialized) return;
        
        this.eventLoop = new EventLoop();
        this.scheduler = new Scheduler();
        this.stateMachine = new StateMachine();
        
        initialized = true;
    }

    /// Start the main event loop
    public void run() {
        if (!initialized) initialize();
        
        stateMachine.transition(AppState.Running);
        eventLoop.start();
    }

    /// Stop the event loop gracefully
    public void stop() {
        if (eventLoop) {
            eventLoop.stop();
        }
        stateMachine.transition(AppState.Stopped);
    }

    /// Check if runtime is initialized
    public bool isInitialized() const {
        return initialized;
    }

    /// Get the event loop instance
    public EventLoop getEventLoop() {
        return eventLoop;
    }

    /// Get the scheduler instance
    public Scheduler getScheduler() {
        return scheduler;
    }

    /// Get the state machine instance
    public StateMachine getStateMachine() {
        return stateMachine;
    }
}

/// Global runtime instance (singleton pattern)
private __gshared AtuiRuntime _globalRuntime;

/// Get or create the global runtime instance
public AtuiRuntime getGlobalRuntime() {
    if (_globalRuntime is null) {
        _globalRuntime = new AtuiRuntime();
    }
    return _globalRuntime;
}
