/**
 * Professional Reminder App with Proper Component Architecture
 * 
 * Demonstrates a real GUI framework with:
 * - Component hierarchy (parent-child relationships)
 * - Event routing and propagation
 * - Focus management
 * - Layer-based rendering
 * - Component lifecycle
 * - State management
 */

import std.stdio;
import std.string;
import std.algorithm;
import std.array;
import std.conv;
import std.format;
import std.range;
import core.thread;
import core.time;
import core.stdc.stdlib;
import core.sys.posix.unistd;
import core.sys.posix.fcntl;

import api;
import atui.components.panel;
import atui.components.button;
import atui.components.textinput;
import atui.components.checkbox;
import atui.components.list;
import atui.components.label;
import atui.components.statusbar;
import atui.components.progressbar;
import reminder;

struct AnsiCodes {
    static enum {
        CLEAR_SCREEN = "\x1B[2J\x1B[H",
        HIDE_CURSOR = "\x1B[?25l",
        SHOW_CURSOR = "\x1B[?25h",
        RESET = "\x1B[0m",
        BOLD = "\x1B[1m",
        DIM = "\x1B[2m",
        REVERSE = "\x1B[7m",
        FG_BLACK = "\x1B[30m",
        FG_RED = "\x1B[31m",
        FG_GREEN = "\x1B[32m",
        FG_YELLOW = "\x1B[33m",
        FG_BLUE = "\x1B[34m",
        FG_MAGENTA = "\x1B[35m",
        FG_CYAN = "\x1B[36m",
        FG_WHITE = "\x1B[37m",
        BG_BLACK = "\x1B[40m",
        BG_RED = "\x1B[41m",
        BG_GREEN = "\x1B[42m",
        BG_YELLOW = "\x1B[43m",
        BG_BLUE = "\x1B[44m",
        BG_MAGENTA = "\x1B[45m",
        BG_CYAN = "\x1B[46m",
        BG_WHITE = "\x1B[47m",
    }
}

// Component Event Types
enum EventType {
    KeyPress,
    KeyRelease,
    FocusGained,
    FocusLost,
    Click,
    StateChanged,
    Custom
}

struct ComponentEvent {
    EventType type;
    char keyChar = '\0';
    int buttonIndex = -1;
    bool handled = false;
}

// Base Component Interface
abstract class Component {
    protected uint x, y, width, height;
    protected bool focused = false;
    protected bool visible = true;
    protected Component parent;
    protected Component[] children;
    protected string name;
    
    this(uint x, uint y, uint width, uint height, string name = "") {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        this.name = name;
    }
    
    // Lifecycle methods
    void initialize() { }
    
    abstract void render();
    
    void handleEvent(ComponentEvent event) {
        if (!visible) return;
        
        // Event routing to children first (bubbling up)
        foreach (child; children) {
            if (!event.handled) {
                child.handleEvent(event);
            }
        }
        
        // Then process for this component
        if (!event.handled) {
            onEvent(event);
        }
    }
    
    protected void onEvent(ComponentEvent event) { }
    
    // Component tree management
    void addChild(Component child) {
        child.parent = this;
        children ~= child;
    }
    
    void setFocus(bool f) {
        if (f && !focused) {
            focused = true;
            ComponentEvent e = ComponentEvent(EventType.FocusGained);
            onEvent(e);
        } else if (!f && focused) {
            focused = false;
            ComponentEvent e = ComponentEvent(EventType.FocusLost);
            onEvent(e);
        }
    }
    
    bool hasFocus() const { return focused; }
    void setVisible(bool v) { visible = v; }
    bool isVisible() const { return visible; }
    
    Component getChild(string childName) {
        foreach (child; children) {
            if (child.name == childName) return child;
        }
        return null;
    }
}

// Container Component (like a Panel that holds other components)
class Container : Component {
    protected string title;
    
    this(uint x, uint y, uint width, uint height, string title = "") {
        super(x, y, width, height, title);
        this.title = title;
    }
    
    override void render() {
        // Render container border
        renderBorder();
        
        // Render all child components
        foreach (child; children) {
            if (child.isVisible()) {
                child.render();
            }
        }
    }
    
    private void renderBorder() {
        writef("%s%s┌", AnsiCodes.BOLD, AnsiCodes.FG_CYAN);
        for (uint i = 1; i < width - 1; i++) write("─");
        writef("┐%s\n", AnsiCodes.RESET);
        
        writef("%s%s│ %-*s │%s\n", AnsiCodes.BOLD, AnsiCodes.FG_CYAN,
               width - 4, title, AnsiCodes.RESET);
        
        writef("%s%s├", AnsiCodes.BOLD, AnsiCodes.FG_CYAN);
        for (uint i = 1; i < width - 1; i++) write("─");
        writef("┤%s\n", AnsiCodes.RESET);
        
        // Content area
        for (uint i = 2; i < height - 1; i++) {
            writef("%s│ %-*s │%s\n", AnsiCodes.FG_CYAN, width - 4, "", AnsiCodes.RESET);
        }
        
        writef("%s%s└", AnsiCodes.BOLD, AnsiCodes.FG_CYAN);
        for (uint i = 1; i < width - 1; i++) write("─");
        writef("┘%s\n", AnsiCodes.RESET);
    }
}

// Specialized Components
class ReminderListComponent : Component {
    public Reminder[] reminders;
    public int selectedIndex = 0;
    public int scrollOffset = 0;
    private void delegate(int) onSelectionChanged;
    
    this(uint x, uint y, uint width, uint height) {
        super(x, y, width, height, "ReminderList");
    }
    
    void setReminders(Reminder[] rems) {
        reminders = rems;
        if (selectedIndex >= reminders.length) selectedIndex = 0;
    }
    
    int getSelectedIndex() const { return selectedIndex; }
    
    override void render() {
        writef("%s%s┌", AnsiCodes.FG_MAGENTA, AnsiCodes.BOLD);
        for (uint i = 1; i < width - 1; i++) write("─");
        writefln("┐%s", AnsiCodes.RESET);
        
        writef("%s%s│ %-*s │%s\n", AnsiCodes.FG_MAGENTA, AnsiCodes.BOLD,
               width - 4, "REMINDERS (↑↓ Navigate)", AnsiCodes.RESET);
        
        writef("%s%s├", AnsiCodes.FG_MAGENTA, AnsiCodes.BOLD);
        for (uint i = 1; i < width - 1; i++) write("─");
        writefln("┤%s", AnsiCodes.RESET);
        
        for (uint i = 0; i < height - 4; i++) {
            if (i + scrollOffset < reminders.length) {
                Reminder rem = reminders[i + scrollOffset];
                
                if (cast(int)(i + scrollOffset) == selectedIndex && focused) {
                    writef("%s%s│ %s", AnsiCodes.REVERSE, AnsiCodes.FG_BLACK, AnsiCodes.BOLD);
                } else {
                    writef("%s│ ", AnsiCodes.FG_MAGENTA);
                }
                
                string priorityIcon = rem.priority == Priority.High ? "🔴" : 
                                     rem.priority == Priority.Medium ? "🟡" : "🟢";
                string line = format("%s %-30s", priorityIcon, rem.title[0..min(30, $)]);
                writef("%-*s", width - 4, line);
                writefln("%s│%s", AnsiCodes.FG_MAGENTA, AnsiCodes.RESET);
            } else {
                writef("%s│ %-*s │%s\n", AnsiCodes.FG_MAGENTA, width - 4, "", AnsiCodes.RESET);
            }
        }
        
        writef("%s%s└", AnsiCodes.FG_MAGENTA, AnsiCodes.BOLD);
        for (uint i = 1; i < width - 1; i++) write("─");
        writefln("┘%s", AnsiCodes.RESET);
    }
    
    override void onEvent(ComponentEvent event) {
        switch (event.type) {
            case EventType.KeyPress:
                if (event.keyChar == 'A') { // Up arrow
                    if (selectedIndex > 0) {
                        selectedIndex--;
                        if (selectedIndex < scrollOffset) scrollOffset--;
                        if (onSelectionChanged) onSelectionChanged(selectedIndex);
                    }
                } else if (event.keyChar == 'B') { // Down arrow
                    if (selectedIndex < cast(int)reminders.length - 1) {
                        selectedIndex++;
                        if (selectedIndex >= scrollOffset + cast(int)(height - 5)) scrollOffset++;
                        if (onSelectionChanged) onSelectionChanged(selectedIndex);
                    }
                }
                break;
            default:
                break;
        }
    }
}

class ReminderDetailComponent : Component {
    private Reminder currentReminder;
    private bool hasReminder = false;
    
    this(uint x, uint y, uint width, uint height) {
        super(x, y, width, height, "ReminderDetail");
    }
    
    void setReminder(Reminder rem) {
        currentReminder = rem;
        hasReminder = true;
    }
    
    override void render() {
        writef("%s%s┌", AnsiCodes.FG_BLUE, AnsiCodes.BOLD);
        for (uint i = 1; i < width - 1; i++) write("─");
        writefln("┐%s", AnsiCodes.RESET);
        
        writef("%s%s│ %-*s │%s\n", AnsiCodes.FG_BLUE, AnsiCodes.BOLD,
               width - 4, "DETAIL VIEW", AnsiCodes.RESET);
        
        writef("%s%s├", AnsiCodes.FG_BLUE, AnsiCodes.BOLD);
        for (uint i = 1; i < width - 1; i++) write("─");
        writefln("┤%s", AnsiCodes.RESET);
        
        if (hasReminder) {
            writef("%s│ %s%-15s: %s%-*s │%s\n",
                   AnsiCodes.FG_BLUE, AnsiCodes.BOLD, "Title",
                   AnsiCodes.FG_CYAN, width - 22, currentReminder.title, AnsiCodes.RESET);
            
            writef("%s│ %s%-15s: %s%-*s │%s\n",
                   AnsiCodes.FG_BLUE, AnsiCodes.BOLD, "Priority",
                   AnsiCodes.FG_CYAN, width - 22, to!string(currentReminder.priority), AnsiCodes.RESET);
            
            writef("%s│ %s%-15s: %s%-*s │%s\n",
                   AnsiCodes.FG_BLUE, AnsiCodes.BOLD, "Category",
                   AnsiCodes.FG_CYAN, width - 22, to!string(currentReminder.category), AnsiCodes.RESET);
            
            writef("%s│ %s%-15s: %s%-*s │%s\n",
                   AnsiCodes.FG_BLUE, AnsiCodes.BOLD, "Description",
                   AnsiCodes.FG_CYAN, width - 22, currentReminder.description[0..min(width-22, $)], AnsiCodes.RESET);
            
            // Fill remaining space
            for (uint i = 4; i < height - 3; i++) {
                writef("%s│ %-*s │%s\n", AnsiCodes.FG_BLUE, width - 4, "", AnsiCodes.RESET);
            }
        } else {
            for (uint i = 0; i < height - 4; i++) {
                writef("%s│ %-*s │%s\n", AnsiCodes.FG_BLUE, width - 4,
                       i == 2 ? "No reminder selected" : "", AnsiCodes.RESET);
            }
        }
        
        writef("%s%s└", AnsiCodes.FG_BLUE, AnsiCodes.BOLD);
        for (uint i = 1; i < width - 1; i++) write("─");
        writefln("┘%s", AnsiCodes.RESET);
    }
}

class ButtonBarComponent : Component {
    public Button[] buttons;
    public int focusedButton = 0;
    private void delegate(int) onButtonClick;
    
    this(uint x, uint y, uint width, uint height) {
        super(x, y, width, height, "ButtonBar");
    }
    
    void addButton(string label, void delegate() callback) {
        Button btn = new Button(cast(uint)(x + 3 + buttons.length * 18), cast(uint)(y + 2), label);
        btn.onClick = callback;
        buttons ~= btn;
    }
    
    override void render() {
        writef("%s%s┌", AnsiCodes.FG_GREEN, AnsiCodes.BOLD);
        for (uint i = 1; i < width - 1; i++) write("─");
        writefln("┐%s", AnsiCodes.RESET);
        
        writef("%s%s│ %-*s │%s\n", AnsiCodes.FG_GREEN, AnsiCodes.BOLD,
               width - 4, "ACTIONS", AnsiCodes.RESET);
        
        writef("%s%s├", AnsiCodes.FG_GREEN, AnsiCodes.BOLD);
        for (uint i = 1; i < width - 1; i++) write("─");
        writefln("┤%s", AnsiCodes.RESET);
        
        writef("%s│ ", AnsiCodes.FG_GREEN);
        foreach (idx, btn; buttons) {
            if (idx == focusedButton && focused) {
                writef("%s%s[ %s ]%s ", AnsiCodes.REVERSE, AnsiCodes.FG_YELLOW, btn.label, AnsiCodes.RESET);
            } else {
                writef("[ %s ] ", btn.label);
            }
        }
        int padding = cast(int)width - cast(int)(buttons.length * 15) - 4;
        for (int i = 0; i < padding; i++) write(" ");
        writefln("%s│%s", AnsiCodes.FG_GREEN, AnsiCodes.RESET);
        
        writef("%s%s└", AnsiCodes.FG_GREEN, AnsiCodes.BOLD);
        for (uint i = 1; i < width - 1; i++) write("─");
        writefln("┘%s", AnsiCodes.RESET);
    }
    
    override void onEvent(ComponentEvent event) {
        switch (event.type) {
            case EventType.KeyPress:
                if (event.keyChar == 'C') { // Right arrow
                    focusedButton = (focusedButton + 1) % cast(int)buttons.length;
                } else if (event.keyChar == 'D') { // Left arrow
                    focusedButton = focusedButton > 0 ? focusedButton - 1 : cast(int)buttons.length - 1;
                } else if (event.keyChar == ' ' || event.keyChar == '\r') {
                    if (focusedButton < buttons.length && buttons[focusedButton].onClick) {
                        buttons[focusedButton].onClick();
                    }
                }
                break;
            default:
                break;
        }
    }
}

// Main Application Component
class ReminderApp : Component {
    private ReminderManager reminderMgr;
    private ReminderListComponent listComponent;
    private ReminderDetailComponent detailComponent;
    private ButtonBarComponent buttonBar;
    private Label statsLabel;
    private bool running = true;
    private Component focusedComponent;
    
    this() {
        super(0, 0, 120, 30, "ReminderApp");
        reminderMgr = new ReminderManager();
        initializeComponentTree();
    }
    
    private void initializeComponentTree() {
        // Create component hierarchy
        listComponent = new ReminderListComponent(1, 7, 60, 12);
        detailComponent = new ReminderDetailComponent(62, 7, 57, 12);
        buttonBar = new ButtonBarComponent(1, 23, 118, 3);
        statsLabel = new Label(3, 4, "");
        
        addChild(listComponent);
        addChild(detailComponent);
        addChild(buttonBar);
        
        // Setup initial data
        auto reminders = reminderMgr.getPendingReminders();
        listComponent.setReminders(reminders);
        if (reminders.length > 0) {
            detailComponent.setReminder(reminders[0]);
        }
        
        // Setup callbacks
        listComponent.onSelectionChanged = (int idx) {
            if (idx < reminders.length) {
                detailComponent.setReminder(reminders[idx]);
            }
        };
        
        buttonBar.addButton("✓ Complete", { completeReminder(); });
        buttonBar.addButton("🗑 Delete", { deleteReminder(); });
        buttonBar.addButton("⏱ Snooze", { snoozeReminder(); });
        buttonBar.addButton("🔍 Filter", { toggleFilter(); });
        buttonBar.addButton("❌ Quit", { running = false; });
        
        // Set initial focus
        focusedComponent = listComponent;
        listComponent.setFocus(true);
    }
    
    override void render() {
        write(AnsiCodes.CLEAR_SCREEN);
        
        // Header
        renderHeader();
        writeln();
        
        // Stats
        renderStats();
        writeln();
        
        // Component tree rendering (each component renders itself)
        foreach (child; children) {
            if (child.isVisible()) {
                child.render();
            }
        }
        writeln();
        
        // Status bar
        renderStatusBar();
    }
    
    private void renderHeader() {
        writef("%s%s┌", AnsiCodes.BOLD, AnsiCodes.FG_CYAN);
        for (int i = 1; i < 120 - 1; i++) write("─");
        writefln("┐%s", AnsiCodes.RESET);
        
        writef("%s%s│ %s📋 REMINDER APP v0.2.0 - Component-Based GUI Framework%s",
               AnsiCodes.BOLD, AnsiCodes.FG_CYAN, AnsiCodes.FG_WHITE, AnsiCodes.RESET);
        int padding = 120 - 60;
        for (int i = 0; i < padding; i++) write(" ");
        writefln("%s%s│%s", AnsiCodes.FG_CYAN, AnsiCodes.BOLD, AnsiCodes.RESET);
        
        writef("%s%s└", AnsiCodes.BOLD, AnsiCodes.FG_CYAN);
        for (int i = 1; i < 120 - 1; i++) write("─");
        writefln("┘%s", AnsiCodes.RESET);
    }
    
    private void renderStats() {
        auto stats = reminderMgr.getStats();
        
        writef("%s%s┌", AnsiCodes.FG_YELLOW, AnsiCodes.BOLD);
        for (int i = 1; i < 120 - 1; i++) write("─");
        writefln("┐%s", AnsiCodes.RESET);
        
        string statsText = format("%s📊 Pending: %d  │  Completed: %d  │  Total: %d  │  Urgent: %d%s",
                                  AnsiCodes.FG_GREEN, stats.pending, stats.completed,
                                  reminderMgr.getTotalCount(), stats.urgent, AnsiCodes.RESET);
        writef("%s│ %-*s │%s\n", AnsiCodes.FG_YELLOW, 116, statsText, AnsiCodes.RESET);
        
        writef("%s%s└", AnsiCodes.FG_YELLOW, AnsiCodes.BOLD);
        for (int i = 1; i < 120 - 1; i++) write("─");
        writefln("┘%s", AnsiCodes.RESET);
    }
    
    private void renderStatusBar() {
        writef("%s%s", AnsiCodes.BG_CYAN, AnsiCodes.FG_BLACK);
        string statusText = " REMINDER APP v0.2.0 | Component Architecture: Container > Panel > Button/List/Detail | Focus: " ~ 
                           (focusedComponent.name) ~ " ";
        writef("%-*s", 120, statusText);
        writefln("%s", AnsiCodes.RESET);
    }
    
    private void completeReminder() {
        int idx = listComponent.getSelectedIndex();
        reminderMgr.completeReminder(idx);
        refreshList();
    }
    
    private void deleteReminder() {
        int idx = listComponent.getSelectedIndex();
        reminderMgr.deleteReminder(idx);
        refreshList();
    }
    
    private void snoozeReminder() {
        // Snooze implementation
    }
    
    private void toggleFilter() {
        // Filter implementation
    }
    
    private void refreshList() {
        auto reminders = reminderMgr.getPendingReminders();
        listComponent.setReminders(reminders);
        if (reminders.length > 0) {
            detailComponent.setReminder(reminders[0]);
        }
    }
    
    public void run() {
        system("clear");
        write(AnsiCodes.HIDE_CURSOR);
        scope(exit) {
            write(AnsiCodes.SHOW_CURSOR);
            system("clear");
        }
        
        while (running) {
            render();
            handleKeyboardInput();
            Thread.sleep(dur!"msecs"(10));
        }
    }
    
    private void handleKeyboardInput() {
        ubyte[4] buf;
        int flags = fcntl(0, F_GETFL);
        fcntl(0, F_SETFL, flags | O_NONBLOCK);
        
        int bytesRead = cast(int)read(0, buf.ptr, 4);
        
        if (bytesRead > 0) {
            char ch = cast(char)buf[0];
            
            // Handle global commands first
            if (ch == 'q' || ch == 'Q') {
                running = false;
                fcntl(0, F_SETFL, flags);
                return;
            }
            
            // Handle ANSI escape sequences for arrow keys
            if (bytesRead >= 3 && buf[0] == 27 && buf[1] == '[') {
                char arrowCode = cast(char)buf[2];
                
                if (focusedComponent == listComponent) {
                    if (arrowCode == 'A') { // Up arrow
                        Reminder[] reminders = listComponent.reminders;
                        int selectedIdx = listComponent.selectedIndex;
                        if (selectedIdx > 0) {
                            listComponent.selectedIndex--;
                            if (listComponent.selectedIndex < listComponent.scrollOffset) {
                                listComponent.scrollOffset--;
                            }
                            if (reminders.length > 0 && listComponent.selectedIndex < reminders.length) {
                                detailComponent.setReminder(reminders[listComponent.selectedIndex]);
                            }
                        }
                    } else if (arrowCode == 'B') { // Down arrow
                        Reminder[] reminders = listComponent.reminders;
                        if (listComponent.selectedIndex < cast(int)reminders.length - 1) {
                            listComponent.selectedIndex++;
                            if (listComponent.selectedIndex >= listComponent.scrollOffset + cast(int)(listComponent.height - 5)) {
                                listComponent.scrollOffset++;
                            }
                            if (reminders.length > 0 && listComponent.selectedIndex < reminders.length) {
                                detailComponent.setReminder(reminders[listComponent.selectedIndex]);
                            }
                        }
                    }
                } else if (focusedComponent == buttonBar) {
                    if (arrowCode == 'C') { // Right arrow
                        buttonBar.focusedButton = (buttonBar.focusedButton + 1) % cast(int)buttonBar.buttons.length;
                    } else if (arrowCode == 'D') { // Left arrow
                        buttonBar.focusedButton = buttonBar.focusedButton > 0 ? buttonBar.focusedButton - 1 : cast(int)buttonBar.buttons.length - 1;
                    }
                }
            } else {
                // Regular key press
                if (ch == '\t') {
                    // Tab to next component
                    focusedComponent = focusedComponent == listComponent ? buttonBar : listComponent;
                } else if (ch == ' ' || ch == '\r' || ch == '\n') {
                    // Space or Enter on button bar
                    if (focusedComponent == buttonBar && buttonBar.focusedButton < cast(int)buttonBar.buttons.length) {
                        if (buttonBar.buttons[buttonBar.focusedButton].onClick) {
                            buttonBar.buttons[buttonBar.focusedButton].onClick();
                        }
                    }
                } else if (ch == 'c' || ch == 'C') {
                    completeReminder();
                } else if (ch == 'd') {
                    deleteReminder();
                }
            }
        }
        
        fcntl(0, F_SETFL, flags);
    }
}

int main() {
    ReminderApp app = new ReminderApp();
    app.run();
    return 0;
}
