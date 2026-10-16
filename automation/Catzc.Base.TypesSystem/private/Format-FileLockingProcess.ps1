<#
---
catzc:
  derived:
    path: automation/Catzc.Base.TypesSystem/private/Format-FileLockingProcess.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.TypesSystem
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: private
  config:
    synopsis: Formats the processes holding a file as one human-readable phrase.
    description: |-
      Joins the holders into "pwsh.exe (PID 10276, started 2026-10-13 14:10) — the VS Code PowerShell
      extension, this session (PID 37552)". The current process is labelled "this session"; a VS Code
      PowerShell Editor Services host is named as such, since its pwsh.exe is otherwise indistinguishable from
      a console. Returns $null when there are no holders, so the caller can fall back to holder-free wording.
    parameters:
      Holder: The holders, as returned by Get-FileLockingProcess.
    examples:
      - Format-FileLockingProcess (Get-FileLockingProcess $dll)
---
#>

function Format-FileLockingProcess {
    [OutputType([string])]
    param(
        [AllowEmptyCollection()]
        [Catzc.Base.Files.FileLockingProcess[]] $Holder = @()
    )

    if ($Holder.Count -eq 0) {
        return $null
    }

    $labels = foreach ($process in $Holder) {
        if ($process.ProcessId -eq $PID) {
            "this session (PID $PID)"
        }
        elseif ($process.CommandLine -match 'PowerShellEditorServices') {
            "$process — the VS Code PowerShell extension"
        }
        else {
            "$process"
        }
    }
    $labels -join ', '
}
