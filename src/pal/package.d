/**
 * Platform Abstraction Layer (PAL)
 * 
 * Isolates platform-specific implementations from the core engine.
 * Defines interfaces that backends must implement.
 */

module atui.pal;

public import atui.pal.renderer;
public import atui.pal.inputdevice;
public import atui.pal.filesystem;
public import atui.pal.network;
