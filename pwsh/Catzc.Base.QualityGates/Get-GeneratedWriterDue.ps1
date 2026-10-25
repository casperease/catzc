<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-quality-gates/Get-GeneratedWriterDue.ps1.md"
  warning: "Generated Header"
---
#>

function Get-GeneratedWriterDue {
    [CmdletBinding()]
    [OutputType([Catzc.Base.QualityGates.GeneratedWriterDue])]
    param(
        [string[]] $Name,

        [string[]] $ChangedPath,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string] $MemoPath = (Join-Path (Get-OutputRoot) 'cache/generated-writers.json')
    )

    # Naming writers narrows the walk to their inputs, so one writer's check never pays for the whole table.
    $writers = @((Get-Config -Config generated-files).writers.Values | Where-Object { -not $Name -or $_.name -in $Name })
    $memo = Get-GeneratedWriterMemo -MemoPath $MemoPath
    $walk = Get-GeneratedWriterInputFile -InputGlob @($writers | ForEach-Object { @($_.inputs) }) -RepositoryRoot $RepositoryRoot
    $changed = $null
    foreach ($writer in $writers) {
        $inputs = @($writer.inputs | Where-Object { $_ })
        $outputs = @($writer.outputs | Where-Object { $_ })
        $hasLists = ($inputs.Count + $outputs.Count) -gt 0
        if (-not $hasLists) {
            if ($null -eq $changed) {
                $changed = [string[]] @(if ($PSBoundParameters.ContainsKey('ChangedPath')) {
                        $ChangedPath
                    }
                    else {
                        Get-GitChangedPath
                    })
            }
            [Catzc.Base.QualityGates.GeneratedWriterDue]::new($writer.name, $changed.Count -gt 0, $hasLists)
            continue
        }
        $due = $false
        foreach ($output in $outputs) {
            if ($output.IndexOfAny([char[]] '*?[') -lt 0 -and -not [System.IO.File]::Exists((Join-Path $RepositoryRoot $output))) {
                $due = $true
                break
            }
        }
        if (-not $due) {
            $due = $memo[$writer.name] -cne (Get-GeneratedWriterStamp -InputGlob $inputs -Walk $walk -RepositoryRoot $RepositoryRoot)
        }
        [Catzc.Base.QualityGates.GeneratedWriterDue]::new($writer.name, $due, $hasLists)
    }
}
