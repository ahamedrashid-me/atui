/**
 * Table Component
 * 
 * Data table with sorting, filtering, and selection.
 * Features: column headers, sorting, row selection, pagination.
 */

module atui.components.table;

import std.array;
import std.algorithm;
import std.string;
import atui.api.input;

/// Table column definition
public struct TableColumn {
    string header;
    string fieldName;
    uint width = 20;
    bool sortable = true;
    string alignment = "left";
}

/// Table row data
public struct TableRow {
    string[] cells;
    bool selected = false;
    string id;
}

/// Sort direction
public enum SortDirection {
    Ascending,
    Descending,
    None
}

/// Table component
public class Table {
    private TableColumn[] columns;
    private TableRow[] rows;
    private uint[] selectedRows;
    private uint focusedRow = 0;
    private uint startX = 0;
    private uint startY = 0;
    private uint width = 80;
    private uint height = 20;
    private uint pageSize = 10;
    private uint currentPage = 0;
    private string sortColumn = "";
    private SortDirection sortDir = SortDirection.None;
    private string foregroundColor = "white";
    private string backgroundColor = "black";
    private string headerColor = "cyan";

    public this() {
    }

    /// Add column definition
    public void addColumn(TableColumn col) {
        columns ~= col;
    }

    /// Add row data
    public void addRow(TableRow row) {
        rows ~= row;
    }

    /// Set row data
    public void setRows(TableRow[] newRows) {
        rows = newRows.dup;
    }

    /// Select a row
    public void selectRow(uint rowIndex) {
        if (rowIndex < rows.length) {
            if (rows[focusedRow].selected) {
                rows[focusedRow].selected = false;
            }
            rows[rowIndex].selected = true;
            focusedRow = rowIndex;
        }
    }

    /// Toggle row selection
    public void toggleRowSelection(uint rowIndex) {
        if (rowIndex < rows.length) {
            rows[rowIndex].selected = !rows[rowIndex].selected;
            if (rows[rowIndex].selected) {
                selectedRows ~= rowIndex;
            } else {
                selectedRows = selectedRows.remove!(a => a == rowIndex);
            }
        }
    }

    /// Sort by column
    public void sortByColumn(string columnName, SortDirection dir = SortDirection.Ascending) {
        sortColumn = columnName;
        sortDir = dir;

        auto colIndex = columns.countUntil!(c => c.fieldName == columnName);
        if (colIndex < 0) return;

        if (dir == SortDirection.Ascending) {
            rows.sort!((a, b) => a.cells[colIndex] < b.cells[colIndex]);
        } else {
            rows.sort!((a, b) => a.cells[colIndex] > b.cells[colIndex]);
        }
    }

    /// Handle keyboard input
    public void handleKeyEvent(KeyEventData data) {
        switch (data.specialKey) {
            case SpecialKey.ArrowUp:
                if (focusedRow > 0) {
                    selectRow(focusedRow - 1);
                }
                break;
            case SpecialKey.ArrowDown:
                if (focusedRow < rows.length - 1) {
                    selectRow(focusedRow + 1);
                }
                break;
            case SpecialKey.Enter:
                toggleRowSelection(focusedRow);
                break;
            case SpecialKey.PageUp:
                if (currentPage > 0) {
                    currentPage--;
                }
                break;
            case SpecialKey.PageDown:
                if ((currentPage + 1) * pageSize < rows.length) {
                    currentPage++;
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
            if (relY > 0) {  // Skip header
                uint rowIndex = (currentPage * pageSize) + relY - 1;
                if (rowIndex < rows.length) {
                    if (data.button == 0) {  // Left click
                        selectRow(rowIndex);
                    }
                }
            }
        }
    }

    /// Render the table
    public string render() {
        string output = "";

        // Render header
        string header = "";
        foreach (col; columns) {
            header ~= padRight(col.header, col.width) ~ " ";
        }
        output ~= header ~ "\n";

        // Render separator
        string separator = "";
        foreach (col; columns) {
            separator ~= repeat("─", col.width).array.to!string ~ " ";
        }
        output ~= separator ~ "\n";

        // Render visible rows
        uint startRow = currentPage * pageSize;
        uint endRow = (startRow + pageSize < rows.length) ? startRow + pageSize : cast(uint) rows.length;

        foreach (i; startRow .. endRow) {
            if (i >= rows.length) break;

            string line = "";
            foreach (j, col; columns) {
                if (j < rows[i].cells.length) {
                    line ~= padRight(rows[i].cells[j], col.width) ~ " ";
                } else {
                    line ~= repeat(" ", col.width + 1).array.to!string;
                }
            }

            if (rows[i].selected) {
                line = "> " ~ line;
            } else {
                line = "  " ~ line;
            }

            output ~= line ~ "\n";
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

    /// Set page size
    public void setPageSize(uint size) {
        pageSize = size;
    }

    /// Set colors
    public void setColors(string fg, string bg, string header) {
        foregroundColor = fg;
        backgroundColor = bg;
        headerColor = header;
    }

    /// Get selected row indices
    public uint[] getSelectedRows() const {
        return selectedRows.dup;
    }

    /// Get row count
    public uint getRowCount() const {
        return cast(uint) rows.length;
    }

    /// Helper: pad right
    private string padRight(string str, uint width) {
        if (str.length >= width) {
            return str[0 .. width];
        }
        return str ~ repeat(" ", width - str.length).array.to!string;
    }
}
