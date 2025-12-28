/**
 * System API
 * 
 * Platform and system information.
 */

module atui.api.system;

import std.stdint;

/// Platform type
public enum Platform {
    Unknown,
    Android,
    Linux,
    RaspberryPi,
    WebAssembly
}

/// System information
public class System {
    /// Get current platform
    public static Platform getPlatform() {
        version (Android) return Platform.Android;
        else version (linux) return Platform.Linux;
        else return Platform.Unknown;
    }

    /// Get platform name
    public static string getPlatformName() {
        final switch (getPlatform()) {
            case Platform.Android:
                return "Android";
            case Platform.Linux:
                return "Linux";
            case Platform.RaspberryPi:
                return "Raspberry Pi";
            case Platform.WebAssembly:
                return "WebAssembly";
            case Platform.Unknown:
                return "Unknown";
        }
    }

    /// Request system exit
    public static void exit(int code = 0) {
        import core.stdc.stdlib : exit;
        exit(code);
    }

    /// Get system uptime in milliseconds
    public static ulong getUptime() {
        import core.time : MonoTime;
        import std.conv : to;
        return cast(ulong)(MonoTime.currTime().ticks() / 1_000_000);
    }
}
