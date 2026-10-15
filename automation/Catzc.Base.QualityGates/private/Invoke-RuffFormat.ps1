<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Invoke-RuffFormat.ps1
    kind: automation-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-AUTO-PY#8
      - ADR-PRIN-CONFIG#2
  config:
    synopsis: 'The ruff formatter engine: formats the given Python files with the pinned ruff and returns the files it changed.'
    description: |-
      One Format-Code engine adapter ([ADR-PRIN-CONFIG#2](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config2)).
      ruff is pinned in python.yml and runs from the Python test workspace's environment with the workspace's settings
      (the 140-column line, the pinned Python) for every file, wherever it lives (Invoke-PythonWorkspaceTool;
      [ADR-AUTO-PY#8](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py8)).
      `ruff format --check` names the files whose formatting differs; without -DryRun, `ruff format` rewrites exactly
      those. Throws with "Run Install-Uv" when no uv at the pin is found, and with ruff's message for a file it cannot
      parse.
    parameters:
      File: Absolute paths of the .py files to format.
      DryRun: List the files ruff would change without writing them.
    outputs: '[string[]] Absolute paths of the files changed (or, under -DryRun, that would change).'
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
