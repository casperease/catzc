<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Invoke-RuffFormat.ps1.md"
  header: "generated"
---
#>

function Invoke-RuffFormat {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $File,

        [switch] $DryRun
    )

    if ($File.Count -eq 0) {
        return , [string[]] @()
    }
    $pythonRoot = Join-Path (Get-RepositoryRoot) (Get-Config -Config python).ResolveRoot((Get-RepositoryRoot))

    $changed = [System.Collections.Generic.List[string]]::new()
    foreach ($batch in @(Split-CommandLineBatch -Item $File)) {
        # --check exits 1 when a file would change and names each on a 'Would reformat: <path>' line.
        $check = Invoke-PythonWorkspaceTool -Tool 'ruff format --check' -File $batch
        if ($check.ExitCode -notin 0, 1) {
            throw "ruff could not format the Python files (exit $($check.ExitCode)):`n$($check.Full)"
        }
        foreach ($line in ($check.Full -split '\r?\n')) {
            if ($line -match '^Would reformat:\s*(.+)$') {
                $changed.Add([System.IO.Path]::GetFullPath($Matches[1].Trim(), $pythonRoot))
            }
        }
    }
    if ($changed.Count -gt 0 -and -not $DryRun) {
        foreach ($batch in @(Split-CommandLineBatch -Item $changed.ToArray())) {
            $write = Invoke-PythonWorkspaceTool -Tool 'ruff format' -File $batch
            if ($write.ExitCode -ne 0) {
                throw "ruff could not format the Python files (exit $($write.ExitCode)):`n$($write.Full)"
            }
        }
    }

    , [string[]] $changed.ToArray()
}
