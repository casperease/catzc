# Debug in VS Code

The recommended workflow is to drive the **PowerShell Integrated Console** directly: dot-source the importer once, set breakpoints in the
editor, then call the function from the console. Because every function loads into the session, you debug by _invoking_, not by launching a
script.

## One-time setup

Install the recommended extensions — VS Code offers them from `.vscode/extensions.json` (the key one is `ms-vscode.powershell`). The
workspace `.vscode/settings.json` already points the Integrated Console at PowerShell 7
(`"powershell.powerShellDefaultVersion": "PowerShell (x64)"`) and wires squiggles to `PSScriptAnalyzerSettings.psd1`, so analyzer warnings
show inline as you type.

## Debugging a public function

1. Open the PowerShell Integrated Console (Command Palette → _PowerShell: Show Integrated Console_).
2. Load the system:

   ```powershell
   . ./importer.ps1
   ```

3. Open the function's `.ps1` file and click the gutter to set a breakpoint.
4. Call the function from the console:

   ```powershell
   Get-Widgets -Source ./sample.json
   ```

   Execution pauses at the breakpoint. Use the Debug side panel (or `F10`/`F11`) to step, inspect locals, and evaluate expressions in the
   Debug Console.

## Debugging a private function

`private/` functions are loaded into module scope but not exported, so you can't call them from the console by default. Import with
`-ExportPrivates` to make them reachable:

```powershell
. ./importer.ps1 -ExportPrivates
Resolve-StorageEndpoint -Account 'foo'    # a private helper, now callable
```

Set the breakpoint in the `private/*.ps1` file and invoke it the same way. `-ExportPrivates` only changes what the manifest exports — it
does not change behavior, so it's safe for a debugging session.

## The `Debug Module` launch config

`.vscode/launch.json` ships one configuration that runs the importer under the debugger:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Debug Module",
      "type": "PowerShell",
      "request": "launch",
      "script": "${workspaceFolder}/importer.ps1",
      "cwd": "${workspaceFolder}"
    }
  ]
}
```

Press `F5` to run it. This is handy for stepping through the **import itself** (bootstrap, manifest generation, type compilation). For
debugging ordinary functions, the Integrated Console flow above is faster — you keep one warm session and re-invoke as you edit.

## Re-loading after an edit

The importer is the boundary at which the session's view of the repo is fixed, so **re-run `. ./importer.ps1` after changing a `.ps1`** to
pick up the change. Two exceptions:

- A **C# type** edit cannot be hot-swapped — the loader will tell you to start a fresh session (see
  [Add a C# type](BCL/add-a-dotnet-type.md)).
- Set breakpoints _before_ invoking; changing a file mid-break runs the old parsed copy until you re-import.

## Diagnosing a slow or broken import

```powershell
. ./importer.ps1 -DiagnoseLoadTime     # per-stage timing: vendor load, type compile, per-module parse
```

A large cold "file-read I/O" line on an enterprise machine is antivirus scanning the `.ps1` files on first open; the fix is an AV exclusion
for the working copy and `automation/.vendor/`, not a code change (see
[effective-in-enterprises](../../../adr/automation/effective-in-enterprises.md)). On Windows, if the importer warns that `$env:PSModulePath`
contains a network share, run the one-time helper it points you at (`automation/Catzc.Base.Environment/assets/Set-LocalPSModulePath.ps1`).

## When something throws

In a script, `trap { Write-Exception $_; break }` after the importer prints a full stack trace. Interactively, the prompt hook does this for
you after any failed command — read the trace top-to-bottom; the `Assert-*` message names the exact assumption that failed.
