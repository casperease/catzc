<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Split-TestAutomationFiles.ps1
    folder: private
    name: split-test-automation-files
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Split-TestAutomationFiles.Tests.ps1
    cites:
      - ADR-AUTO-TEST#{26,33}
---
#>

function Split-TestAutomationFiles {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        $Discovery,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $TestFiles
    )

    $serialLookup = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $greedyLookup = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($test in $Discovery.Tests) {
        # The test's run file: its test file, or the Go test folder of a Go bridge test.
        $file = Get-TestRunFile -Test $test
        if (-not $file) {
            continue
        }
        if ((Get-TestBlockTag -Test $test -Valid 'serial').Count -gt 0) {
            [void]$serialLookup.Add($file)
        }
        if ((Get-TestBlockTag -Test $test -Valid 'greedy').Count -gt 0) {
            [void]$greedyLookup.Add($file)
        }
    }

    $parallelFiles = [System.Collections.Generic.List[string]]::new()
    $greedyFiles = [System.Collections.Generic.List[string]]::new()
    $serialFiles = [System.Collections.Generic.List[string]]::new()
    foreach ($file in ($TestFiles | Sort-Object)) {
        if ($serialLookup.Contains($file)) {
            $serialFiles.Add($file)
        }
        elseif ($greedyLookup.Contains($file)) {
            $greedyFiles.Add($file)
        }
        else {
            $parallelFiles.Add($file)
        }
    }

    [pscustomobject]@{
        Parallel = @($parallelFiles)
        Greedy   = @($greedyFiles)
        Serial   = @($serialFiles)
    }
}
