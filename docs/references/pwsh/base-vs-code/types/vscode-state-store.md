# pwsh/Base.VSCode/types/VscodeStateStore.cs

Reads and writes one key of VS Code's state store (`state.vscdb`, an SQLite database of key and value rows in `ItemTable`).

## Access

It goes through the SQLite that Windows ships (`winsqlite3.dll`), so no package is fetched.

## Writes

VS Code holds the store in memory while it runs and writes it back on exit, so a write lands only while VS Code is closed, which the caller
asserts.
