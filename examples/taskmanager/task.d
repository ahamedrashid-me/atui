/**
 * Task Model
 * 
 * Defines task structure and manager for the Task Manager application.
 */

module examples.taskmanager.task;

import std.array;
import std.algorithm;
import std.datetime;

/// Task status enum
public enum TaskStatus {
    Pending,
    InProgress,
    Completed
}

/// Task structure
public struct Task {
    string id;
    string title;
    string description;
    TaskStatus status;
    DateTime createdAt;
    DateTime? completedAt;
    uint priority;  // 1 = high, 2 = medium, 3 = low
}

/// Task Manager
public class TaskManager {
    private Task[] tasks;
    private uint taskCounter = 0;
    private Task* selectedTask;

    public this() {
        initializeSampleTasks();
    }

    /// Initialize with sample tasks
    private void initializeSampleTasks() {
        addTask("Build ATUI library", "Complete the TUI framework", TaskStatus.Completed, 1);
        addTask("Implement Tree component", "Create hierarchical data view", TaskStatus.Completed, 1);
        addTask("Add theming system", "Support multiple color themes", TaskStatus.Completed, 2);
        addTask("Build Task Manager app", "Create example application", TaskStatus.InProgress, 1);
        addTask("Write documentation", "Complete API documentation", TaskStatus.Pending, 2);
        addTask("Add unit tests", "Improve code coverage", TaskStatus.Pending, 3);
    }

    /// Add new task
    public void addTask(string title, string description, TaskStatus status, uint priority) {
        Task task = Task(
            id: "task_" ~ taskCounter.to!string,
            title: title,
            description: description,
            status: status,
            createdAt: Clock.currTime(),
            completedAt: status == TaskStatus.Completed ? Clock.currTime() : null,
            priority: priority
        );
        tasks ~= task;
        taskCounter++;
    }

    /// Get all tasks
    public Task[] getAllTasks() {
        return tasks.dup;
    }

    /// Get tasks by status
    public Task[] getTasksByStatus(TaskStatus status) {
        return tasks.filter!(t => t.status == status).array;
    }

    /// Update task status
    public void updateTaskStatus(string id, TaskStatus newStatus) {
        foreach (ref task; tasks) {
            if (task.id == id) {
                task.status = newStatus;
                if (newStatus == TaskStatus.Completed) {
                    task.completedAt = Clock.currTime();
                }
                return;
            }
        }
    }

    /// Delete task
    public void deleteTask(string id) {
        tasks = tasks.filter!(t => t.id != id).array;
    }

    /// Get task count by status
    public uint getCountByStatus(TaskStatus status) {
        return cast(uint) tasks.filter!(t => t.status == status).array.length;
    }

    /// Get total tasks
    public uint getTotalCount() const {
        return cast(uint) tasks.length;
    }

    /// Get completion percentage
    public ubyte getCompletionPercentage() const {
        if (tasks.length == 0) return 0;
        uint completed = cast(uint) tasks.filter!(t => t.status == TaskStatus.Completed).array.length;
        return cast(ubyte) ((completed * 100) / tasks.length);
    }
}

import std.conv;
import std.datetime.systime;
