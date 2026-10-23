---
name: devbox-diagnose
description:
  Where a devbox's Windows, VS Code and process evidence lives and how a line of it is read; for devbox-vscode-diagnostics; input is the
  symptom and its time window.
user-invocable: false
allowed-tools: Bash, Read, Write
metadata:
  catzc:
    config:
      model_floor: haiku
      needs: [pwsh]
---

# devbox-diagnose

1. Windows: `Get-WinEvent` on Application and System in the window (Application Error, .NET Runtime, Windows Error Reporting, Kernel-Power
   41, bugcheck 1001), `$env:LOCALAPPDATA\CrashDumps`, and the boot time from `Win32_OperatingSystem`; a report older than the boot is a
   stale re-report, never a crash of today.
2. VS Code: `$env:APPDATA\Code\logs\<session stamp>\` holds main.log (an extension host exit with code 0 after "received terminate message
   from renderer" is a reload, not a crash), ptyhost.log (terminal reattach and grace-time shutdowns), `window<n>\exthost\exthost.log` and
   one folder per extension: `ms-vscode.powershell\PowerShell.log` ("terminated or Extension Terminal was closed" is logged on every reload
   by design) and `ms-dotnettools.csdevkit\Projects.log` (design-time build warnings, the lines the editor highlights); a yellow warning on
   a terminal tab is "Terminal Environment Changes": extensions contributed variables after the terminal started, and
   `terminal.integrated.environmentChangesRelaunch` relaunches, so kills, every terminal not yet typed into.
3. Processes: `code --status` (VS Code's own process tree with memory per process, GPU state, the window's title) and
   `code --list-extensions --show-versions`; `Win32_Process` for pwsh, dotnet, MSBuild and Microsoft.CodeAnalysis.LanguageServer with
   ParentProcessId, CreationDate and CommandLine; `where.exe dotnet`, `dotnet --list-sdks`, `dotnet --list-runtimes`; one script per layer,
   never a foreground `Get-WinEvent`.
4. Reading: read the extension-host activation list (`window<n>\exthost\exthost.log`) and a log's head first, before any log search; every
   claim carries its line verbatim with its timestamp, layers are correlated within one minute, and no line means no cause.
