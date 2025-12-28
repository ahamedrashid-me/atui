/**
 * Filesystem API
 * 
 * Abstracted file system operations.
 */

module atui.api.filesystem;

import std.stdio : File;
import std.file : FileException;

/// File system operations
public class FileSystem {
    /// Read file contents
    static string readFile(string path) {
        try {
            auto file = File(path, "r");
            scope(exit) file.close();
            return file.readln();
        } catch (FileException e) {
            return "";
        }
    }

    /// Write to file
    static bool writeFile(string path, string contents) {
        try {
            auto file = File(path, "w");
            scope(exit) file.close();
            file.write(contents);
            return true;
        } catch (FileException e) {
            return false;
        }
    }

    /// Check if file exists
    static bool fileExists(string path) {
        import std.file : exists;
        try {
            return exists(path);
        } catch (Throwable t) {
            return false;
        }
    }
}

/// Global filesystem instance
private __gshared FileSystem _fs;

/// Get the filesystem API
public FileSystem getFileSystem() {
    if (_fs is null) {
        _fs = new FileSystem();
    }
    return _fs;
}
