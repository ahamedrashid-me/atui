/**
 * Reminder Data Model
 * 
 * Defines reminder structure, priorities, and reminder manager.
 */

module reminder;

import std.array;
import std.algorithm;
import std.datetime.systime;
import std.datetime;
import std.string;
import std.conv;
import std.format;

enum Priority {
    Low,
    Medium,
    High
}

enum Category {
    Work,
    Personal,
    Shopping,
    Health,
    Other
}

enum ReminderStatus {
    Pending,
    Completed,
    Snoozed,
    Cancelled
}

struct Reminder {
    string id;
    string title;
    string description;
    Priority priority;
    Category category;
    ReminderStatus status;
    SysTime dueDate;
    SysTime createdDate;
    
    string toString() const {
        return format("Reminder(%s, %s, %s)", id, title, priority);
    }
}

struct ReminderStats {
    size_t pending;
    size_t completed;
    size_t overdue;
    size_t urgent;
}

class ReminderManager {
    private Reminder[string] reminders;
    private size_t reminderCount = 0;

    public this() {
        initializeSampleData();
    }

    private void initializeSampleData() {
        auto now = Clock.currTime();
        
        // Sample Reminder 1: Buy Groceries (High Priority, Personal)
        Reminder r1 = Reminder(
            "r001",
            "Buy Groceries",
            "Buy milk, bread, eggs, vegetables",
            Priority.High,
            Category.Shopping,
            ReminderStatus.Pending,
            now + dur!"days"(1),
            now
        );
        addReminder(r1);
        
        // Sample Reminder 2: Team Meeting (High Priority, Work)
        Reminder r2 = Reminder(
            "r002",
            "Team Meeting",
            "Quarterly planning and review meeting",
            Priority.High,
            Category.Work,
            ReminderStatus.Pending,
            now + dur!"hours"(2),
            now
        );
        addReminder(r2);
        
        // Sample Reminder 3: Gym Session (Medium Priority, Health)
        Reminder r3 = Reminder(
            "r003",
            "Gym Session",
            "45 min cardio + 30 min strength training",
            Priority.Medium,
            Category.Health,
            ReminderStatus.Pending,
            now + dur!"hours"(8),
            now
        );
        addReminder(r3);
        
        // Sample Reminder 4: Project Deadline (High Priority, Work)
        Reminder r4 = Reminder(
            "r004",
            "Project Deadline",
            "Submit final project deliverables",
            Priority.High,
            Category.Work,
            ReminderStatus.Pending,
            now + dur!"days"(3),
            now
        );
        addReminder(r4);
        
        // Sample Reminder 5: Dentist Appointment (Medium Priority, Health)
        Reminder r5 = Reminder(
            "r005",
            "Dentist Appointment",
            "Annual checkup and cleaning",
            Priority.Medium,
            Category.Health,
            ReminderStatus.Pending,
            now + dur!"days"(5),
            now
        );
        addReminder(r5);
        
        // Sample Reminder 6: Birthday Gift (Low Priority, Personal)
        Reminder r6 = Reminder(
            "r006",
            "Birthday Gift",
            "Buy gift for friend's birthday party",
            Priority.Low,
            Category.Personal,
            ReminderStatus.Pending,
            now + dur!"days"(1),
            now
        );
        addReminder(r6);
        
        // Sample Reminder 7: Car Maintenance (Medium Priority, Personal)
        Reminder r7 = Reminder(
            "r007",
            "Car Maintenance",
            "Oil change and tire rotation",
            Priority.Medium,
            Category.Personal,
            ReminderStatus.Pending,
            now + dur!"hours"(12),
            now
        );
        addReminder(r7);
        
        // Sample Reminder 8: Code Review (High Priority, Work)
        Reminder r8 = Reminder(
            "r008",
            "Code Review",
            "Review pull requests from team",
            Priority.High,
            Category.Work,
            ReminderStatus.Pending,
            now + dur!"days"(4),
            now
        );
        addReminder(r8);
    }

    public void addReminder(Reminder reminder) {
        reminders[reminder.id] = reminder;
        reminderCount++;
    }

    public Reminder[] getPendingReminders() {
        Reminder[] pending;
        foreach (id, reminder; reminders) {
            if (reminder.status == ReminderStatus.Pending) {
                pending ~= reminder;
            }
        }
        return pending.sort!((a, b) => a.dueDate < b.dueDate).array;
    }

    public Reminder[] getCompletedReminders() {
        Reminder[] completed;
        foreach (id, reminder; reminders) {
            if (reminder.status == ReminderStatus.Completed) {
                completed ~= reminder;
            }
        }
        return completed;
    }

    public ReminderStats getStats() {
        ReminderStats stats;
        auto now = Clock.currTime();
        
        foreach (id, reminder; reminders) {
            if (reminder.status == ReminderStatus.Pending) {
                stats.pending++;
                if (reminder.priority == Priority.High) {
                    stats.urgent++;
                }
                if (reminder.dueDate < now) {
                    stats.overdue++;
                }
            } else if (reminder.status == ReminderStatus.Completed) {
                stats.completed++;
            }
        }
        
        return stats;
    }

    public void completeReminder(size_t index) {
        auto pending = getPendingReminders();
        if (index < pending.length) {
            string id = pending[index].id;
            if (id in reminders) {
                reminders[id].status = ReminderStatus.Completed;
            }
        }
    }

    public void deleteReminder(size_t index) {
        auto pending = getPendingReminders();
        if (index < pending.length) {
            string id = pending[index].id;
            reminders.remove(id);
        }
    }

    public size_t getTotalCount() const {
        return reminderCount;
    }

    public string formatTimeRemaining(SysTime dueDate) {
        auto now = Clock.currTime();
        auto dur = dueDate - now;
        
        if (dur.total!"days" >= 1) {
            return format("%d days", dur.total!"days");
        } else if (dur.total!"hours" >= 1) {
            return format("%d hours", dur.total!"hours");
        } else if (dur.total!"minutes" >= 1) {
            return format("%d mins", dur.total!"minutes");
        } else if (dur.total!"seconds" > 0) {
            return "Now";
        } else {
            return "Overdue!";
        }
    }
}
