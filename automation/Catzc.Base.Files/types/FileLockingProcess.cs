/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Files/types/FileLockingProcess.cs
    kind: csharp-type
    language: csharp
    track: automation
    module: Catzc.Base.Files
    relatives:
      page: docs/references/automation/catzc-base-files/types/FileLockingProcess.cs.md
---
*/

using System;
using System.Globalization;

namespace Catzc.Base.Files;

public sealed class FileLockingProcess
{
    // The holding process's id.
    public int ProcessId { get; }

    // The executable name (e.g. pwsh.exe); null when the process is gone.
    public string Name { get; }

    // The Restart Manager's display name for the application (its window title or file description).
    public string AppName { get; }

    // When the process started (local time) — together with ProcessId it identifies the process uniquely.
    public DateTime Started { get; }

    // The full command line; null when the process is gone or the caller may not read it.
    public string CommandLine { get; }

    // The parent process's id; null when the process is gone.
    public int? ParentProcessId { get; }

    public FileLockingProcess(int processId, string appName, DateTime started)
        : this(processId, null, appName, started, null, null)
    {
    }

    public FileLockingProcess(int processId, string name, string appName, DateTime started, string commandLine, int? parentProcessId)
    {
        ProcessId = processId;
        Name = name;
        AppName = appName;
        Started = started;
        CommandLine = commandLine;
        ParentProcessId = parentProcessId;
    }

    // "pwsh.exe (PID 10276, started 2026-10-13 14:10)" — the executable name, else the Restart Manager's app name.
    public override string ToString()
    {
        var label = string.IsNullOrEmpty(Name) ? AppName : Name;
        return string.Format(CultureInfo.InvariantCulture, "{0} (PID {1}, started {2:yyyy-MM-dd HH:mm})", label, ProcessId, Started);
    }
}
