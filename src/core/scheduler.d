/**
 * Scheduler - Task and timing management
 */

module atui.core.scheduler;

import core.time : Duration;

/// Task scheduler for deferred and periodic execution
public class Scheduler {
    private struct Task {
        Duration delay;
        void delegate() callback;
        bool repeating;
        Duration period;
    }

    private Task[] tasks;
    private bool running = false;

    /// Schedule a one-time task after a delay
    public void schedule(Duration delay, void delegate() callback) {
        tasks ~= Task(delay, callback, false, Duration.zero);
    }

    /// Schedule a periodic task
    public void scheduleRepeating(Duration period, void delegate() callback) {
        tasks ~= Task(Duration.zero, callback, true, period);
    }

    /// Start executing scheduled tasks
    public void start() {
        running = true;
    }

    /// Stop the scheduler
    public void stop() {
        running = false;
    }

    /// Process all due tasks
    public void tick(Duration deltaTime) {
        if (!running) return;

        foreach (ref task; tasks) {
            if (task.delay > Duration.zero) {
                task.delay -= deltaTime;
                if (task.delay <= Duration.zero) {
                    task.callback();
                    if (task.repeating) {
                        task.delay = task.period;
                    }
                }
            }
        }
    }
}
