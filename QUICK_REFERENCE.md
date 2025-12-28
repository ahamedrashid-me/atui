# ATUI Quick Reference Guide

## Project Overview

**ATUI** is a UI-independent TUI framework for writing portable text-based applications in D.

```
Write Once → Deploy Everywhere
  ↓
Single D source code
  ↓
Runs on Android | Linux | Raspberry Pi
```

---

## Core Concept: Strict Layer Separation

```
┌─────────────────────────────────────┐
│     YOUR APPLICATION CODE            │ ← Imports ONLY atui.api.*
├─────────────────────────────────────┤
│   FRAMEWORK PUBLIC API                │ ← tui, input, fs, net, permissions
├─────────────────────────────────────┤
│     CORE RUNTIME ENGINE               │ ← Event loop, Scheduler, State machine
├─────────────────────────────────────┤
│  PLATFORM ABSTRACTION LAYER (PAL)     │ ← Interface definitions
├─────────────────────────────────────┤
│   PLATFORM BACKENDS                   │ ← Linux/Android implementations
├─────────────────────────────────────┤
│      OPERATING SYSTEM                 │ ← Hardware control
└─────────────────────────────────────┘
```

**Rule #1**: Never import platform-specific modules from application code

---

## Quick Start

### 1. Initialize
```d
import atui.api;

void main() {
    initTUI(width, height);
    auto runtime = getGlobalRuntime();
    runtime.initialize();
```

### 2. Render
```d
    clear();
    print(x, y, "Text", Color.white(), Color.black());
    refresh();
```

### 3. Handle Input
```d
    auto event = readInput();
    if (event.type == InputEventType.KeyPress) {
        // Handle key
    }
```

### 4. Cleanup
```d
    runtime.stop();
}
```

---

## API Reference Summary

### TUI Graphics (`atui.api.tui`)
```d
void initTUI(uint width, uint height);
void clear();
void print(uint x, uint y, string text, Color fg, Color bg);
void refresh();
Color.white(), Color.black(), Color.red(), Color.green(), Color.blue();
Color c = Color(r, g, b);  // Custom RGB
```

### Input Events (`atui.api.input`)
```d
InputEvent readInput();

// Event types
enum InputEventType { KeyPress, KeyRelease, TouchStart, TouchMove, TouchEnd, SystemEvent }

// Special keys
enum SpecialKey { Enter, Escape, Backspace, Tab, ArrowUp, ArrowDown, ... }

// Access event data
event.keyData.keyChar
event.keyData.specialKey
event.keyData.isShiftPressed / isCtrlPressed / isAltPressed
event.touchData.x, .y, .pointerId
```

### Filesystem (`atui.api.filesystem`)
```d
auto fs = getFileSystem();
string contents = fs.readFile("path");
bool success = fs.writeFile("path", contents);
bool exists = fs.fileExists("path");
```

### Network (`atui.api.network`)
```d
auto net = getNetwork();
bool ok = net.connect(host, port);
bool sent = net.send(data);
ubyte[] data = net.receive(maxBytes);
net.close();
```

### Permissions (`atui.api.permissions`)
```d
auto status = Permissions.checkPermission(Permission.FileRead);
bool ok = Permissions.requestPermission(Permission.Network);
string error = Permissions.getPermissionError(Permission.FileRead);
```

### System Info (`atui.api.system`)
```d
Platform p = System.getPlatform();  // Android, Linux, etc.
string name = System.getPlatformName();
ulong uptime = System.getUptime();
System.exit(0);
```

---

## Runtime API (`atui.core.runtime`)

```d
auto runtime = getGlobalRuntime();
runtime.initialize();
runtime.run();
runtime.stop();
bool initialized = runtime.isInitialized();
```

---

## Project File Locations

| Component | Location |
|-----------|----------|
| Core Engine | `src/core/` |
| Framework API | `src/api/` |
| PAL Interfaces | `src/pal/` |
| Linux Backend | `src/backends/linux/` |
| Android Backend | `src/backends/android/` |
| Examples | `examples/` |

---

## Module Import Patterns

### ✅ CORRECT (Application Code)
```d
import atui.api;                    // Framework API
import atui.core.runtime;           // Runtime (as needed)
import atui.api.tui;                // Specific modules
import atui.api.input;
```

### ❌ INCORRECT (Never in App Code)
```d
import atui.pal.renderer;           // PAL - Never!
import atui.backends.linux.renderer; // Backend - Never!
import atui.backends.android;       // Backend - Never!
```

---

## Architecture: TUI Rendering Model

### Double Buffering with Diff Engine

```
Step 1: Clear and draw to back buffer
    buffer[y][x] = Cell(glyph, fg_color, bg_color)

Step 2: Call refresh() to compute differences
    only_changed_cells = diff(front_buffer, back_buffer)

Step 3: Render only changed cells
    for each changed_cell:
        render_backend.drawCell(x, y, cell)

Step 4: Swap buffers
    front_buffer = back_buffer
```

**Benefit**: Minimal draw calls, high efficiency, predictable timing

---

## Event Loop Overview

```
while (running) {
    // 1. Poll input from hardware
    events = input_device.pollEvents()
    
    // 2. Update application state
    app.handleEvents(events)
    
    // 3. Render to screen
    renderer.drawBuffer(screen_buffer)
    
    // 4. Frame rate limiting (~60 FPS)
    sleep_if_needed()
}
```

---

## Build Commands

```bash
# Build library
dub build

# Build with Linux config (excludes Android backend)
dub build --config=linux

# Build with Android config (excludes Linux backend)
dub build --config=android

# Build in release mode
dub build --build=release
```

---

## Design Principles Cheat Sheet

| Principle | Meaning | Example |
|-----------|---------|---------|
| **UI Independence** | No Android/terminal toolkit | Use ATUI API only |
| **Layer Separation** | Clear component boundaries | App→API→Engine→PAL→Backend→OS |
| **Determinism** | Reproducible behavior | Same input → same output always |
| **Survivability** | App continues if subsystem fails | Renderer fails → show text warning |
| **Portability** | Write once, deploy everywhere | Same D code on Android/Linux/Pi |

---

## Platform Differences (Transparent to App)

| Feature | Linux | Android |
|---------|-------|---------|
| Renderer | ANSI terminal or framebuffer | OpenGL ES 2.0+ |
| Input | evdev or stdin | Touch + hardware keys (JNI) |
| Resolution | Terminal size or FB dimensions | Screen size (DPI aware) |
| Colors | 256 colors (ANSI) or 24-bit | 32-bit RGBA |

**App Code**: Identical for all platforms

---

## Common Patterns

### Basic App Structure
```d
import atui.api;

void main() {
    initTUI(80, 24);
    auto runtime = getGlobalRuntime();
    runtime.initialize();
    
    // App logic here
    
    runtime.stop();
}
```

### Menu Loop
```d
int selected = 0;
while (running) {
    render();  // Draw menu
    auto event = readInput();
    if (event.type == InputEventType.KeyPress) {
        if (event.keyData.specialKey == SpecialKey.ArrowDown)
            selected++;
        else if (event.keyData.specialKey == SpecialKey.ArrowUp)
            selected--;
        else if (event.keyData.specialKey == SpecialKey.Enter)
            handleSelection(selected);
    }
}
```

### Permission Handling
```d
if (Permissions.checkPermission(Permission.FileRead) == PermissionStatus.Granted) {
    auto fs = getFileSystem();
    string data = fs.readFile("file.txt");
} else {
    print(5, 10, "File read permission denied", Color.red(), Color.black());
}
```

---

## Documentation Files

- **README.md** - Complete user guide with architecture details
- **ROADMAP.md** - Development timeline
- **BUILD_SUMMARY.md** - What's been built so far
- **This file** - Quick reference

---

## Key Files to Know

| File | Purpose |
|------|---------|
| `src/api/tui.d` | Graphics rendering API |
| `src/api/input.d` | Input event API |
| `src/core/runtime.d` | Runtime orchestrator |
| `src/core/eventloop.d` | Main polling loop |
| `src/pal/renderer.d` | Renderer interface (for backends) |
| `src/backends/linux/renderer.d` | Linux rendering implementation |
| `examples/hello_world.d` | Minimal example |
| `examples/menu_example.d` | Input handling example |

---

## Troubleshooting

### Issue: "unable to read module"
- Check module name matches file path
- Example: `module atui.api.tui` → file `src/api/tui.d`

### Issue: Build fails
- Ensure D compiler installed: `dmd --version`
- Ensure DUB installed: `dub --version`
- Check dub.json paths are correct

### Issue: App doesn't respond to input
- Make sure to call `readInput()` in your loop
- Check platform backend implements IInputDevice

### Issue: Text doesn't appear
- Call `refresh()` after drawing
- Check coordinates are within bounds (0-79, 0-23 for 80x24)

---

**ATUI Framework** - Write Once, Run Anywhere Text-Based Applications
