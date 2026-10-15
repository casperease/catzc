<#
.SYNOPSIS
    Formats the processes holding a file as one human-readable phrase.
.DESCRIPTION
    Returns null for no holders, so the caller can fall back to holder-free wording.
    [comment:1](/docs/references/automation/catzc-base-typessystem/private/Format-FileLockingProcess.ps1.md#comment1)
.PARAMETER Holder
    The holders, as returned by Get-FileLockingProcess.
.EXAMPLE
    Format-FileLockingProcess (Get-FileLockingProcess $dll)
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
