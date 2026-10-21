<#
---
catzc:
  immutable:
    with_body_sha: "704b7446adde"
  edges:
    docs: "[Format-FileLockingProcess.ps1.md](../../../docs/references/pwsh/catzc-base-types-system/private/Format-FileLockingProcess.ps1.md)"
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
