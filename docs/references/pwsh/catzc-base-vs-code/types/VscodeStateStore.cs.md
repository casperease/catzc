# pwsh/Catzc.Base.VSCode/types/VscodeStateStore.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public static class VscodeStateStore`, written with `//`.

```text
One key of VS Code's state store (state.vscdb, an SQLite database of key/value rows in ItemTable), read and written through the
SQLite Windows ships (winsqlite3.dll), so no package is fetched. VS Code holds the store in memory while it runs and writes it back on
exit: a write lands only while VS Code is closed, which the caller asserts.
```
