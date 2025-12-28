# ATUI Framework Development Roadmap

## Phase 1: Core Framework (Current)
- [x] Project structure setup
- [x] Core runtime engine (event loop, scheduler, state machine)
- [x] Framework Public API definitions
- [x] Platform Abstraction Layer
- [x] Linux backend stubs (ANSI terminal)
- [x] Android backend stubs (OpenGL ES)
- [x] Example applications
- [ ] Comprehensive documentation
- [ ] Unit tests

## Phase 2: v0.2.0 - Enhanced Input & Components (Q1 2025)
- [x] Mouse support (click, drag, double-click)
- [x] Tree component for hierarchical data
- [x] Table component with sorting
- [x] Theming system with color schemes
- [x] Extended component library (16 components)
- [ ] Mouse documentation
- [ ] Tree & Table examples

## Phase 3: Linux Implementation
- [ ] Complete ANSI terminal renderer
- [ ] Framebuffer renderer with font support
- [ ] evdev input device implementation
- [ ] Terminal raw mode handling
- [ ] Linux filesystem backend
- [ ] Linux network backend
- [ ] Raspberry Pi hardware acceleration
- [ ] Testing on actual Raspberry Pi

## Phase 3: Android Implementation
- [ ] JNI bindings for native code
- [ ] Android activity bootstrapping
- [ ] OpenGL ES 2.0 rendering pipeline
- [ ] Font atlas generation and rendering
- [ ] Touch event mapping
- [ ] Android permissions framework
- [ ] APK packaging automation
- [ ] Testing on Android devices

## Phase 4: Advanced Features
- [ ] Widget library (buttons, text input, etc.)
- [ ] Layout system
- [ ] Animation framework
- [ ] Particle effects
- [ ] Sound support
- [ ] Save/restore state serialization
- [ ] Plugin system

## Phase 5: Polish & Release
- [ ] Performance optimization
- [ ] Comprehensive testing
- [ ] Full documentation
- [ ] Example applications showcase
- [ ] Community contributions
- [ ] Public release (v1.0)

## Known TODOs

### Renderer Implementation
- Glyph rendering to framebuffer
- Font atlas management
- OpenGL ES shader compilation
- Double-buffer synchronization
- EGL context management on Android

### Input Handling
- evdev event parsing
- Touch gesture recognition
- Hardware key mapping
- IME (Input Method Editor) support

### Build System
- Android NDK integration script
- Gradle build automation
- Cross-compilation setup
- CI/CD pipeline

## Performance Targets

- 60 FPS minimum on modern hardware
- 30 FPS on Raspberry Pi Zero
- <16ms frame time
- Minimal CPU usage when idle
- <50MB APK size (Android)

## Testing Strategy

1. Unit tests for core engine
2. Integration tests for API
3. Platform-specific tests for backends
4. Performance benchmarks
5. Device compatibility testing

## Community & Contributions

Once Phase 1 is complete, the project will be open for contributions in areas such as:
- Performance optimization
- Additional platforms (WebAssembly, etc.)
- Widget library expansion
- Documentation and tutorials
- Example applications

