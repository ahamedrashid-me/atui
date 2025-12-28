# ATUI Framework - Complete Component Library

## Overview

ATUI now includes **14 production-ready TUI components** for building full-featured terminal applications. Components are organized into logical categories for easy understanding and usage.

## Component Categories

### 1. Basic Components (3)

#### Label
- **Purpose**: Display static text
- **Key Features**:
  - Static text rendering
  - Color support (foreground and background)
  - Auto-width adjustment
- **Usage**: Headers, descriptions, informational text
- **File**: `src/atui/components/label.d`

```d
auto label = new Label(x, y, width, height, "Hello World");
label.fgColor = Color.Yellow;
label.render();
```

#### Button
- **Purpose**: Interactive clickable button
- **Key Features**:
  - Focus support with highlight
  - Click callback (`onClick`)
  - Custom text
  - Border rendering
- **Usage**: User actions, confirmations, navigation
- **File**: `src/atui/components/button.d`

```d
auto btn = new Button(x, y, width, height, "[Click Me]");
btn.onClick = () => writeln("Button clicked!");
btn.render();
```

#### TextInput
- **Purpose**: Single-line text input field
- **Key Features**:
  - Text entry with cursor
  - Placeholder text
  - Focus support
  - `onChanged` callback
- **Usage**: Usernames, passwords, search boxes
- **File**: `src/atui/components/textinput.d`

```d
auto input = new TextInput(x, y, width, height);
input.placeholder = "Enter text...";
input.onChanged = (text) => writeln("Text: ", text);
input.handleInput(event);
```

---

### 2. Container Components (3)

#### Panel
- **Purpose**: Bordered container for grouping content
- **Key Features**:
  - Customizable border style
  - Optional title
  - Background color support
- **Usage**: Grouping related components
- **File**: `src/atui/components/panel.d`

```d
auto panel = new Panel(x, y, width, height, "My Panel");
panel.fgColor = Color.Cyan;
panel.render();
```

#### List
- **Purpose**: Scrollable list of items
- **Key Features**:
  - Multiple item selection
  - Keyboard navigation (arrow keys)
  - Scroll support for large lists
  - Focus highlighting
- **Usage**: Menus, file lists, option selection
- **File**: `src/atui/components/list.d`

```d
auto list = new List(x, y, width, height);
list.addItem("Option 1");
list.addItem("Option 2");
list.onChanged = (idx) => writeln("Selected: ", idx);
list.render();
```

#### Combobox
- **Purpose**: Dropdown selection list
- **Key Features**:
  - Collapsed/expanded states
  - Text search
  - Arrow key navigation
  - Space to toggle open/close
- **Usage**: Language selection, options menu, filters
- **File**: `src/atui/components/combobox.d`

```d
auto combo = new Combobox(x, y, width, height);
combo.addItem("C");
combo.addItem("D");
combo.addItem("Rust");
combo.onChanged = (idx) => writeln("Selected: ", idx);
```

---

### 3. Dialog Components (3)

#### Dialog
- **Purpose**: Modal dialog with buttons and message
- **Key Features**:
  - Customizable buttons
  - Message text
  - Optional title
  - Modal behavior
  - Button selection with Enter/Space
- **Usage**: Confirmations, alerts, user choices
- **File**: `src/atui/components/dialog.d`

```d
auto dialog = new Dialog(x, y, width, height, "Confirm Action", "Are you sure?");
dialog.addButton("Yes");
dialog.addButton("No");
dialog.onConfirm = (btnIdx) => writeln("Selected button: ", btnIdx);
```

#### InputDialog
- **Purpose**: Prompt for user input with title
- **Key Features**:
  - Input field with cursor
  - OK/Cancel buttons
  - Input validation ready
  - Prompt text
- **Usage**: Getting user input in modal form
- **File**: `src/atui/components/inputdialog.d`

```d
auto inputDlg = new InputDialog(x, y, width, height, "Enter name", "Name:");
inputDlg.onConfirm = (text) => writeln("Entered: ", text);
```

#### MessageBox
- **Purpose**: Simple message display box
- **Key Features**:
  - Word-wrapped text
  - Title support
  - Dismiss instruction
  - Optional callback
- **Usage**: Information display, notifications, alerts
- **File**: `src/atui/components/messagebox.d`

```d
auto msgBox = new MessageBox(x, y, width, height, "Info", "Operation complete!");
msgBox.onDismiss = () => writeln("Message dismissed");
```

---

### 4. Selection Components (2)

#### Checkbox
- **Purpose**: Boolean toggle with label
- **Key Features**:
  - Checked/unchecked states
  - Label text
  - Focus support
  - `onChanged` callback with boolean state
- **Usage**: Boolean options, settings, multi-select
- **File**: `src/atui/components/checkbox.d`

```d
auto checkbox = new Checkbox(x, y, "Enable Feature");
checkbox.onChanged = (checked) => writeln("Checked: ", checked);
checkbox.handleInput(event);
```

#### RadioButton
- **Purpose**: Mutually exclusive option selection
- **Key Features**:
  - Group management
  - Only one can be selected
  - Visual indicator (filled/empty)
  - Label text
- **Usage**: Mode selection, preferences, exclusive choices
- **File**: `src/atui/components/radiobutton.d`

```d
auto radio1 = new RadioButton(x, y, "Option A", "group1");
auto radio2 = new RadioButton(x+15, y, "Option B", "group1");
```

---

### 5. Text Editing (1)

#### TextArea
- **Purpose**: Multi-line text editor
- **Key Features**:
  - Multi-line editing with Enter
  - Arrow key navigation (up/down/left/right)
  - Cursor positioning
  - Vertical scrolling for large text
  - Backspace/Delete support
  - Visual cursor indicator
- **Usage**: Code editing, message composition, document editing
- **File**: `src/atui/components/textarea.d`

```d
auto textarea = new TextArea(x, y, width, height);
textarea.setText("Initial text");
textarea.onChanged = () => writeln("Content changed");
textarea.handleInput(event);
```

---

### 6. Status Components (2)

#### StatusBar
- **Purpose**: Multi-segment status display
- **Key Features**:
  - Multiple status segments
  - Left/center/right alignment
  - Color customization
  - Quick status updates
- **Usage**: Application status, mode indicators, info display
- **File**: `src/atui/components/statusbar.d`

```d
auto status = new StatusBar(x, y, width, height);
status.setSegment(0, "Ready");
status.setSegment(1, "Line 10:5");
status.setSegment(2, "UTF-8");
```

#### ProgressBar
- **Purpose**: Visual progress indicator
- **Key Features**:
  - Percentage-based display
  - Filled/empty visualization
  - Color support
  - Smooth animation ready
- **Usage**: File transfers, processing progress, loading
- **File**: `src/atui/components/progressbar.d`

```d
auto progress = new ProgressBar(x, y, width, height, 75);  // 75% complete
progress.fgColor = Color.Green;
progress.render();
```

---

## Quick Comparison Table

| Component | Type | Best For | Interactive |
|-----------|------|----------|-------------|
| Label | Text | Static display | No |
| Button | Input | User actions | Yes |
| TextInput | Input | Single-line input | Yes |
| Panel | Container | Grouping | No |
| List | Container | Item selection | Yes |
| Combobox | Selection | Dropdown menu | Yes |
| Dialog | Dialog | Confirmations | Yes |
| InputDialog | Dialog | Input prompt | Yes |
| MessageBox | Dialog | Alerts | Yes |
| Checkbox | Selection | Boolean toggle | Yes |
| RadioButton | Selection | Exclusive choice | Yes |
| TextArea | Input | Multi-line text | Yes |
| StatusBar | Status | Info display | No |
| ProgressBar | Status | Progress display | No |

---

## Architecture

All components follow a consistent architecture:

```d
class ComponentName {
    // Positioning and sizing
    uint x, y, width, height;
    
    // Visual properties
    Color fgColor, bgColor;
    bool visible;
    
    // State
    bool focused;
    
    // Callbacks for user interaction
    void delegate(...) onChanged;
    void delegate(...) onClick;
    
    // Core methods
    void render();           // Render to screen
    void setFocus(bool);     // Set focus state
    void handleInput(InputEvent event);  // Process input
}
```

---

## Usage Patterns

### Pattern 1: Simple Display
```d
auto label = new Label(x, y, w, h, "Hello");
label.render();
```

### Pattern 2: Interactive with Callback
```d
auto button = new Button(x, y, w, h, "[OK]");
button.onClick = () => doSomething();
button.handleInput(event);
button.render();
```

### Pattern 3: Modal Dialog
```d
auto dialog = new Dialog(x, y, w, h, "Title", "Message");
dialog.onConfirm = (idx) => handleResult(idx);
while (stillActive) {
    dialog.handleInput(getEvent());
    dialog.render();
}
```

### Pattern 4: Composite Application
```d
auto panel = new Panel(x1, y1, w1, h1, "Settings");
auto btn1 = new Button(x2, y2, w2, h2, "[Save]");
auto btn2 = new Button(x3, y3, w3, h3, "[Cancel]");

// Event loop
while (running) {
    auto event = getInputEvent();
    btn1.handleInput(event);
    btn2.handleInput(event);
    
    panel.render();
    btn1.render();
    btn2.render();
}
```

---

## Building with Components

### Step 1: Import Components
```d
import atui.components;
```

### Step 2: Initialize ATUI
```d
initATUI();
```

### Step 3: Create Components
```d
auto button = new Button(5, 5, 20, 3, "[Click]");
auto label = new Label(5, 10, 50, 1, "Status: Ready");
```

### Step 4: Event Loop
```d
while (appRunning) {
    auto event = getInputEvent();
    
    // Handle input
    button.handleInput(event);
    label.render();
    button.render();
}
```

### Step 5: Cleanup
```d
cleanupATUI();
```

---

## Component Statistics

- **Total Components**: 14
- **Interactive Components**: 10
- **Display-Only Components**: 4
- **Total Lines of Code**: ~900
- **Compiled Library Size**: 745 KB

---

## Examples

See the `examples/` directory for complete examples:

- `hello_world.d` - Basic setup
- `components_showcase.d` - Original 7 components demo
- `advanced_showcase.d` - All 14 components demo

---

## Next Steps

### Add More Components
- ScrollBar - Standalone scroll indicator
- Tree - Hierarchical list view
- Table - Data grid display
- Menu - Top-level menu bar
- Slider - Range input

### Enhance Existing
- Add drag-and-drop support
- Add mouse support integration
- Add animation framework
- Add theme system

### Documentation
- Component API reference
- Advanced styling guide
- Performance tuning guide
- Custom component tutorial

---

## Component Maturity

- ✅ Core Framework (Stable)
- ✅ Platform Abstraction (Stable)
- ✅ Linux Backend (Stable)
- ✅ 7 Original Components (Stable)
- ✅ 7 Advanced Components (Stable)
- 🔄 Mouse Support (In Development)
- 🔄 Theming System (Planned)

---

## File Structure

```
src/atui/components/
├── package.d           # Module exports
├── label.d            # Label component
├── button.d           # Button component
├── textinput.d        # Single-line input
├── panel.d            # Container panel
├── list.d             # Scrollable list
├── statusbar.d        # Status bar
├── progressbar.d      # Progress bar
├── dialog.d           # Modal dialog
├── inputdialog.d      # Input dialog
├── messagebox.d       # Message box
├── checkbox.d         # Checkbox
├── radiobutton.d      # Radio button
├── textarea.d         # Multi-line editor
└── combobox.d         # Dropdown selection
```

---

## License

ATUI Framework - All components are part of the ATUI project.

---

Last Updated: 2024
Total Components: 14
Build Status: ✅ All passing
