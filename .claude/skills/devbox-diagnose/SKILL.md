---
name: devbox-diagnose
description: >
  Find why a pwsh session, the editor or a cats import misbehaves on this devbox from the Windows, VS Code and process evidence, every claim
  with its log line; changes nothing; input is the symptom and its time window.
user-invocable: false
allowed-tools: Bash, Read, Write
metadata:
  catzc:
    config:
      model_floor: sonnet
      needs: [pwsh]
---

# devbox-diagnose

Take the symptom word for word and its window (default: today); every probe is one script in the scratchpad run in the background as
catzc-run says, one script per layer, its output read from the file; change nothing.

1. Windows: `Get-WinEvent` on Application and System in the window (Application Error, .NET Runtime, Windows Error Reporting, Kernel-Power
   41, bugcheck 1001), `$env:LOCALAPPDATA\CrashDumps`, and the boot time from `Win32_OperatingSystem`; a report older than the boot is a
   stale re-report, never a crash of today.
2. VS Code: `$env:APPDATA\Code\logs\<session stamp>\` holds main.log (an extension host exit with code 0 after "received terminate message
   from renderer" is a reload, not a crash), ptyhost.log (terminal reattach and grace-time shutdowns), `window<n>\exthost\exthost.log` and
   one folder per extension: `ms-vscode.powershell\PowerShell.log` ("terminated or Extension Terminal was closed" is logged on every reload
   by design) and `ms-dotnettools.csdevkit\Projects.log` (design-time build warnings); a yellow warning on a terminal tab is "Terminal
   Environment Changes", and `terminal.integrated.environmentChangesRelaunch` relaunches, so kills, every terminal not yet typed into.
3. Processes: `code --status` and `code --list-extensions --show-versions`; `Win32_Process` for pwsh, dotnet, MSBuild and
   Microsoft.CodeAnalysis.LanguageServer with ParentProcessId, CreationDate and CommandLine; `where.exe dotnet`, the SDKs and runtimes, the
   pwsh version, free memory.
4. Repo: what every session runs at start (the profile, `.vscode/settings.json`, `.vscode/tasks.json`, `importer.ps1` and the console path
   of `Invoke-Importer`), the run lock, and the one types hash (`Get-CombinedTypeHash`) against the index's `pwsh/.compiled`.
5. Read the exthost activation list and a log's head before any log search; correlate the layers within one minute of each death, a death
   preceded by a reload being its effect; name a cause only where a line shows it, else "no line shows a crash" and each untested hypothesis
   with its probe.
6. Report a timeline table (time, layer, line verbatim, reading), the verdict, and the one change recommended, labelled as such.
