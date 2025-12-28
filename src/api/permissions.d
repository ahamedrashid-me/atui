/**
 * Permissions API
 * 
 * Handle platform permissions gracefully.
 */

module atui.api.permissions;

/// Permission types
public enum Permission {
    FileRead,
    FileWrite,
    Network,
    SystemAccess,
    Location,
    Camera
}

/// Permission status
public enum PermissionStatus {
    Granted,
    Denied,
    Unknown
}

/// Permissions handler
public class Permissions {
    /// Check if permission is granted
    public static PermissionStatus checkPermission(Permission perm) {
        // TODO: Check actual platform permissions
        return PermissionStatus.Unknown;
    }

    /// Request permission
    public static bool requestPermission(Permission perm) {
        // TODO: Request permission from OS
        return false;
    }

    /// Handle permission denial gracefully
    public static string getPermissionError(Permission perm) {
        final switch (perm) {
            case Permission.FileRead:
                return "File read permission denied";
            case Permission.FileWrite:
                return "File write permission denied";
            case Permission.Network:
                return "Network access denied";
            case Permission.SystemAccess:
                return "System access denied";
            case Permission.Location:
                return "Location permission denied";
            case Permission.Camera:
                return "Camera permission denied";
        }
    }
}
