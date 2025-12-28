# Task Manager - ATUI Example Application

A terminal-based task management application that demonstrates the ATUI framework capabilities.

## Features

✨ **ATUI Framework Showcase**
- **Components**: Panel, List, Button, Label, StatusBar
- **Input Handling**: Keyboard navigation and commands
- **Theming System**: Switch between Light, Dark, Monokai, and Dracula themes
- **Event-Driven**: Responsive user interface with real-time updates

📋 **Task Management**
- Create new tasks with priority levels
- Mark tasks as pending, in progress, or completed
- Delete completed or unwanted tasks
- Filter tasks by status
- View task statistics and completion percentage

⌨️ **Keyboard Controls**

| Key | Action |
|-----|--------|
| `N` | New task |
| `C` | Mark task as completed |
| `D` | Delete task |
| `T` | Switch theme |
| `P` | Filter: Pending tasks |
| `I` | Filter: In Progress tasks |
| `O` | Filter: Completed tasks |
| `A` | Filter: All tasks |
| `Q` | Quit application |

🎨 **Themes**
1. **Light** - Light background with dark text
2. **Dark** - Dark background with light text
3. **Monokai** - Classic developer theme
4. **Dracula** - Purple/magenta theme

## Building

```bash
dub build
```

Or from the ATUI root directory:

```bash
cd examples/taskmanager
dub build
```

## Running

```bash
dub run
```

## Project Structure

```
taskmanager/
├── main.d           # Main application logic
├── task.d           # Task data model and manager
├── dub.json         # DUB package configuration
└── README.md        # This file
```

## Technical Details

### Components Used

- **Panel**: Main container for the UI
- **List**: Display task list with selection
- **Button**: Interactive buttons for actions
- **Label**: Display text and statistics
- **StatusBar**: Status information display

### Features Demonstrated

1. **Component Integration**: Multiple ATUI components working together
2. **Input Handling**: Keyboard event processing and command handling
3. **Theme Management**: Dynamic theme switching using the theming system
4. **Data Management**: Task storage and filtering
5. **UI Updates**: Real-time display updates based on state changes

## Future Enhancements

- [ ] Mouse click support for task selection
- [ ] Tree view for task categories
- [ ] Table view for detailed task information
- [ ] Task editing dialog
- [ ] Data persistence (save/load tasks)
- [ ] Search and filter functionality
- [ ] Task due dates and reminders

## License

MIT License - Same as ATUI Framework
