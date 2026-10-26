using System;
using System.Runtime.InteropServices;
using System.Text;

namespace Catzc.Base.VSCode;

// One key of VS Code's state store, state.vscdb, read and written through the SQLite Windows ships, so nothing is fetched.
public static class VscodeStateStore
{
    private const int Ok = 0;
    private const int Row = 100;
    private const int Done = 101;
    private const int OpenReadOnly = 0x1;
    private const int OpenReadWriteCreate = 0x2 | 0x4;
    private static readonly IntPtr Transient = new IntPtr(-1);

    [DllImport("winsqlite3.dll")]
    private static extern int sqlite3_open_v2(byte[] filename, out IntPtr db, int flags, IntPtr vfs);

    [DllImport("winsqlite3.dll")]
    private static extern int sqlite3_close_v2(IntPtr db);

    [DllImport("winsqlite3.dll")]
    private static extern int sqlite3_prepare_v2(IntPtr db, byte[] sql, int length, out IntPtr statement, IntPtr tail);

    [DllImport("winsqlite3.dll")]
    private static extern int sqlite3_bind_text(IntPtr statement, int index, byte[] text, int length, IntPtr destructor);

    [DllImport("winsqlite3.dll")]
    private static extern int sqlite3_step(IntPtr statement);

    [DllImport("winsqlite3.dll")]
    private static extern IntPtr sqlite3_column_text(IntPtr statement, int column);

    [DllImport("winsqlite3.dll")]
    private static extern int sqlite3_finalize(IntPtr statement);

    [DllImport("winsqlite3.dll")]
    private static extern IntPtr sqlite3_errmsg(IntPtr db);

    // The key's value, or null when the store has no row for it.
    public static string Read(string path, string key)
    {
        string value = null;
        Run(path, OpenReadOnly, "SELECT value FROM ItemTable WHERE key = ?", key, null, statement =>
        {
            IntPtr text = sqlite3_column_text(statement, 0);
            value = text == IntPtr.Zero ? null : Marshal.PtrToStringUTF8(text);
        });
        return value;
    }

    // Writes the key's value, replacing the row it had; the table is VS Code's own, created only if the store has none.
    public static void Write(string path, string key, string value)
    {
        Run(path, OpenReadWriteCreate, "CREATE TABLE IF NOT EXISTS ItemTable (key TEXT UNIQUE ON CONFLICT REPLACE, value BLOB)", null, null, null);
        Run(path, OpenReadWriteCreate, "INSERT OR REPLACE INTO ItemTable (key, value) VALUES (?, ?)", key, value, null);
    }

    private static byte[] Utf8(string text) => Encoding.UTF8.GetBytes(text + "\0");

    private static void Run(string path, int flags, string sql, string first, string second, Action<IntPtr> row)
    {
        if (!OperatingSystem.IsWindows()) { throw new PlatformNotSupportedException("The VS Code state store is reached through winsqlite3.dll, which is Windows-only."); }
        if (sqlite3_open_v2(Utf8(path), out IntPtr db, flags, IntPtr.Zero) != Ok) { Fail(db, "open " + path); }
        try
        {
            if (sqlite3_prepare_v2(db, Utf8(sql), -1, out IntPtr statement, IntPtr.Zero) != Ok) { Fail(db, "prepare"); }
            try
            {
                if (first != null) { sqlite3_bind_text(statement, 1, Encoding.UTF8.GetBytes(first), Encoding.UTF8.GetByteCount(first), Transient); }
                if (second != null) { sqlite3_bind_text(statement, 2, Encoding.UTF8.GetBytes(second), Encoding.UTF8.GetByteCount(second), Transient); }
                int step;
                while ((step = sqlite3_step(statement)) == Row) { row?.Invoke(statement); }
                if (step != Done) { Fail(db, "step"); }
            }
            finally { sqlite3_finalize(statement); }
        }
        finally { sqlite3_close_v2(db); }
    }

    private static void Fail(IntPtr db, string what)
    {
        string message = db == IntPtr.Zero ? "no handle" : Marshal.PtrToStringUTF8(sqlite3_errmsg(db));
        throw new InvalidOperationException(string.Format("VS Code state store: {0} failed: {1}", what, message));
    }
}
