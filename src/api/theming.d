/**
 * Theming System
 * 
 * Unified theming system with color schemes and style management.
 * Features: predefined themes, custom themes, dynamic switching.
 */

module atui.api.theming;

import std.array;
import std.string;

/// Color definition
public struct Color {
    ubyte r;
    ubyte g;
    ubyte b;
    ubyte a = 255;

    this(ubyte r, ubyte g, ubyte b) {
        this.r = r;
        this.g = g;
        this.b = b;
    }
}

/// Palette colors for a theme
public struct ColorPalette {
    Color primary;
    Color secondary;
    Color accent;
    Color foreground;
    Color background;
    Color success;
    Color warning;
    Color error;
    Color disabled;
    Color border;
}

/// Theme structure
public struct Theme {
    string name;
    string id;
    ColorPalette colors;
    float fontSize = 12.0;
    string fontFamily = "monospace";
    uint borderWidth = 1;
    string borderStyle = "solid";
}

/// Theme Manager
public class ThemeManager {
    private Theme[] themes;
    private Theme currentTheme;
    private Theme[string] themeMap;

    public this() {
        initializeDefaultThemes();
    }

    /// Initialize built-in themes
    private void initializeDefaultThemes() {
        // Light theme
        Theme light = Theme(
            name: "Light",
            id: "light",
            colors: ColorPalette(
                primary: Color(0, 102, 204),
                secondary: Color(102, 102, 102),
                accent: Color(255, 153, 0),
                foreground: Color(0, 0, 0),
                background: Color(255, 255, 255),
                success: Color(51, 153, 51),
                warning: Color(255, 153, 0),
                error: Color(204, 0, 0),
                disabled: Color(192, 192, 192),
                border: Color(200, 200, 200)
            )
        );

        // Dark theme
        Theme dark = Theme(
            name: "Dark",
            id: "dark",
            colors: ColorPalette(
                primary: Color(100, 181, 246),
                secondary: Color(176, 190, 197),
                accent: Color(255, 193, 7),
                foreground: Color(230, 230, 230),
                background: Color(33, 33, 33),
                success: Color(102, 194, 102),
                warning: Color(255, 179, 71),
                error: Color(239, 83, 80),
                disabled: Color(97, 97, 97),
                border: Color(66, 66, 66)
            )
        );

        // Monokai theme
        Theme monokai = Theme(
            name: "Monokai",
            id: "monokai",
            colors: ColorPalette(
                primary: Color(102, 217, 239),
                secondary: Color(174, 129, 255),
                accent: Color(249, 38, 114),
                foreground: Color(248, 248, 240),
                background: Color(39, 40, 34),
                success: Color(166, 226, 46),
                warning: Color(253, 151, 31),
                error: Color(248, 248, 0),
                disabled: Color(117, 113, 94),
                border: Color(60, 60, 50)
            )
        );

        // Dracula theme
        Theme dracula = Theme(
            name: "Dracula",
            id: "dracula",
            colors: ColorPalette(
                primary: Color(139, 233, 253),
                secondary: Color(189, 147, 249),
                accent: Color(255, 121, 198),
                foreground: Color(248, 248, 242),
                background: Color(40, 42, 54),
                success: Color(80, 250, 123),
                warning: Color(241, 250, 140),
                error: Color(255, 85, 85),
                disabled: Color(98, 114, 164),
                border: Color(68, 71, 90)
            )
        );

        addTheme(light);
        addTheme(dark);
        addTheme(monokai);
        addTheme(dracula);

        currentTheme = dark;
    }

    /// Add custom theme
    public void addTheme(Theme theme) {
        themes ~= theme;
        themeMap[theme.id] = theme;
    }

    /// Get theme by ID
    public Theme getTheme(string id) {
        if (id in themeMap) {
            return themeMap[id];
        }
        return currentTheme;
    }

    /// Switch to theme
    public void setCurrentTheme(string id) {
        if (id in themeMap) {
            currentTheme = themeMap[id];
        }
    }

    /// Get current theme
    public Theme getCurrentTheme() const {
        return currentTheme;
    }

    /// Get all available themes
    public string[] getAvailableThemes() {
        string[] names;
        foreach (theme; themes) {
            names ~= theme.id;
        }
        return names;
    }

    /// Create custom theme
    public void createCustomTheme(string name, string id, ColorPalette colors) {
        Theme custom = Theme(
            name: name,
            id: id,
            colors: colors
        );
        addTheme(custom);
    }

    /// Export theme as string (JSON-like format)
    public string exportTheme(string id) {
        if (id !in themeMap) return "";
        
        Theme theme = themeMap[id];
        string output = "Theme: " ~ theme.name ~ " (" ~ theme.id ~ ")\n";
        output ~= "Primary: RGB(" ~ theme.colors.primary.r.to!string ~ ","
                ~ theme.colors.primary.g.to!string ~ ","
                ~ theme.colors.primary.b.to!string ~ ")\n";
        output ~= "Background: RGB(" ~ theme.colors.background.r.to!string ~ ","
                ~ theme.colors.background.g.to!string ~ ","
                ~ theme.colors.background.b.to!string ~ ")\n";
        output ~= "Foreground: RGB(" ~ theme.colors.foreground.r.to!string ~ ","
                ~ theme.colors.foreground.g.to!string ~ ","
                ~ theme.colors.foreground.b.to!string ~ ")\n";
        
        return output;
    }

    /// Get color from current theme
    public Color getPrimaryColor() const {
        return currentTheme.colors.primary;
    }

    /// Get background color
    public Color getBackgroundColor() const {
        return currentTheme.colors.background;
    }

    /// Get foreground color
    public Color getForegroundColor() const {
        return currentTheme.colors.foreground;
    }

    /// Get accent color
    public Color getAccentColor() const {
        return currentTheme.colors.accent;
    }

    /// Get success color
    public Color getSuccessColor() const {
        return currentTheme.colors.success;
    }

    /// Get error color
    public Color getErrorColor() const {
        return currentTheme.colors.error;
    }

    /// Get warning color
    public Color getWarningColor() const {
        return currentTheme.colors.warning;
    }
}

/// Global theme manager instance
public ThemeManager themeManager = null;

/// Initialize global theme manager
public void initThemeManager() {
    if (themeManager is null) {
        themeManager = new ThemeManager();
    }
}

/// Get global theme manager
public ThemeManager getThemeManager() {
    if (themeManager is null) {
        initThemeManager();
    }
    return themeManager;
}
