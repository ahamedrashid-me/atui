/**
 * Network Interface
 * 
 * Platform-specific network operations.
 */

module atui.pal.network;

/// Network operations interface
public interface INetwork {
    /// Connect to remote host
    bool connect(string host, ushort port);

    /// Send data
    bool send(ubyte[] data);

    /// Receive data
    ubyte[] receive(size_t maxBytes);

    /// Close connection
    void close();
}

/// Global network instance
private __gshared INetwork _network;

/// Set the network implementation
public void setNetwork(INetwork net) {
    _network = net;
}

/// Get the network implementation
public INetwork getNetwork() {
    return _network;
}
