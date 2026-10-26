# pwsh/Base.Files/types/FileLockingProcess.cs

A process that holds a file open, as the Windows Restart Manager reports it (`RestartManager`) and enriched with the process's own facts. It
is the result type of `Get-FileLockingProcess`.

## Properties

The Restart Manager part (`ProcessId`, `AppName`, `Started`) is always present. The enrichment (`Name`, `CommandLine`, `ParentProcessId`) is
null when the process exited between the two lookups. `ProcessId` together with `Started` identifies the process uniquely, and the string
form reads `pwsh.exe (PID 10276, started 2026-10-13 14:10)`: the executable name, else the Restart Manager's app name.
