/**
 * Filesystem Interface
 * 
 * Platform-specific filesystem operations.
 */

module atui.pal.filesystem;

/// Filesystem operations interface
public interface IFileSystem {
    /// Read file
    string readFile(string path);

    /// Write file
    bool writeFile(string path, string contents);

    /// Check if file exists
    bool fileExists(string path);

    /// Delete file
    bool deleteFile(string path);

    /// List directory contents
    string[] listDirectory(string path);
}

/// Global filesystem instance
private __gshared IFileSystem _fileSystem;

/// Set the filesystem implementation
public void setFileSystem(IFileSystem fs) {
    _fileSystem = fs;
}

/// Get the filesystem implementation
public IFileSystem getFileSystem() {
    return _fileSystem;
}
