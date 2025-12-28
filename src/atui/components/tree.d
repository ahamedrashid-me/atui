/**
 * Tree Component
 * 
 * Hierarchical tree view for displaying nested data structures.
 * Features: expand/collapse, keyboard navigation, selection.
 */

module atui.components.tree;

import std.array;
import std.algorithm;
import atui.api.input;

/// Tree node structure
public struct TreeNode {
    string label;
    string id;
    TreeNode[] children;
    bool expanded = false;
    bool selected = false;
    uint level = 0;
}

/// Tree component
public class Tree {
    private TreeNode[] nodes;
    private TreeNode* selectedNode;
    private uint focusedIndex = 0;
    private uint startX = 0;
    private uint startY = 0;
    private uint width = 80;
    private uint height = 20;
    private string foregroundColor = "white";
    private string backgroundColor = "black";
    private TreeNode[] flattenedNodes;

    public this() {
        flattenNodes();
    }

    /// Add a root node
    public void addNode(TreeNode node) {
        node.level = 0;
        nodes ~= node;
        flattenNodes();
    }

    /// Flatten tree for rendering
    private void flattenNodes() {
        flattenedNodes = [];
        foreach (node; nodes) {
            flattenRecursive(node);
        }
    }

    private void flattenRecursive(TreeNode node) {
        flattenedNodes ~= node;
        if (node.expanded) {
            foreach (child; node.children) {
                flattenRecursive(child);
            }
        }
    }

    /// Toggle node expansion
    public void toggleNode(uint index) {
        if (index < flattenedNodes.length) {
            flattenedNodes[index].expanded = !flattenedNodes[index].expanded;
            flattenNodes();
        }
    }

    /// Set selected node
    public void selectNode(uint index) {
        if (index < flattenedNodes.length) {
            if (selectedNode !is null) {
                (*selectedNode).selected = false;
            }
            selectedNode = &flattenedNodes[index];
            (*selectedNode).selected = true;
            focusedIndex = index;
        }
    }

    /// Handle keyboard input
    public void handleKeyEvent(KeyEventData data) {
        switch (data.specialKey) {
            case SpecialKey.ArrowUp:
                if (focusedIndex > 0) {
                    selectNode(focusedIndex - 1);
                }
                break;
            case SpecialKey.ArrowDown:
                if (focusedIndex < flattenedNodes.length - 1) {
                    selectNode(focusedIndex + 1);
                }
                break;
            case SpecialKey.ArrowRight:
                if (focusedIndex < flattenedNodes.length) {
                    if (!flattenedNodes[focusedIndex].expanded && 
                        flattenedNodes[focusedIndex].children.length > 0) {
                        toggleNode(focusedIndex);
                    }
                }
                break;
            case SpecialKey.ArrowLeft:
                if (focusedIndex < flattenedNodes.length) {
                    if (flattenedNodes[focusedIndex].expanded) {
                        toggleNode(focusedIndex);
                    }
                }
                break;
            default:
                break;
        }
    }

    /// Handle mouse click
    public void handleMouseClick(MouseEventData data) {
        if (data.x >= startX && data.x < startX + width &&
            data.y >= startY && data.y < startY + height) {
            uint relY = data.y - startY;
            if (relY < flattenedNodes.length) {
                selectNode(relY);
            }
        }
    }

    /// Render the tree
    public string render() {
        string output = "";
        uint yOffset = 0;

        foreach (i, node; flattenedNodes) {
            if (yOffset >= height) break;

            string line = "";
            
            // Indentation
            for (uint j = 0; j < node.level; j++) {
                line ~= "  ";
            }

            // Expand/collapse indicator
            if (node.children.length > 0) {
                line ~= node.expanded ? "▼ " : "▶ ";
            } else {
                line ~= "  ";
            }

            // Selection marker
            if (node.selected) {
                line ~= "> ";
            } else {
                line ~= "  ";
            }

            // Node label
            line ~= node.label;

            // Padding
            while (line.length < width) {
                line ~= " ";
            }

            output ~= line ~ "\n";
            yOffset++;
        }

        return output;
    }

    /// Set dimensions
    public void setDimensions(uint x, uint y, uint w, uint h) {
        startX = x;
        startY = y;
        width = w;
        height = h;
    }

    /// Set colors
    public void setColors(string fg, string bg) {
        foregroundColor = fg;
        backgroundColor = bg;
    }

    /// Get selected node ID
    public string getSelectedNodeId() {
        if (selectedNode !is null) {
            return (*selectedNode).id;
        }
        return "";
    }

    /// Get node count
    public uint getNodeCount() const {
        return cast(uint) flattenedNodes.length;
    }
}
