<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.TypesSystem/private/Format-FileLockingProcess.ps1
    folder: private
    name: format-file-locking-process
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.TypesSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
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
