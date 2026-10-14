<#
.SYNOPSIS
    Runs a module's Go tests once and returns the Pester outcome of every discovered Go test.
.DESCRIPTION
    The Go bridge's run step (tests/Go.Bridge.ps1 calls it once per module, in its BeforeAll); each generated
    Pester test then reports its own outcome:

      - go missing: when -GoExecutable is empty (the run's source session found no managed go at the tools.yml pin,
        Get-GoTestExecutable), nothing runs and every case is skipped with the constrained skip key 'tool_go_missing'
        ([ADR-AUTO-TEST#8](/docs/adr/automation/test-automation.md#rule-adr-auto-test8));
      - otherwise Invoke-GoTest runs the module's Go tests (against -EntryScript in a build run) and each case takes
        the outcome of its GoTestResult: pass; fail, with the Go output; or skip, with the skip key 'go_test_skipped'
        and the Go output.

    Throws when go reports a test the discovery did not list (a declaration Get-GoTestCases cannot read), so no Go
    result goes unreported; a listed case with no result fails with that message. A failure of Invoke-GoTest itself
    (go vet, a package that does not build) propagates, which fails every test of the module with the go output.
.PARAMETER Module
    The catzc module whose Go tests run.
.PARAMETER Case
    The module's discovered cases (Get-GoTestCases).
.PARAMETER EntryScript
    The engine entry of a build run (the build's Import-Catzc.ps1); empty for the source run.
.PARAMETER GoExecutable
    The managed go the run's source session located and checked against the pin (Get-GoTestExecutable), handed
    down through the shard and the bridge container; empty when there is none. The worker never locates go itself:
    a build run's engine does not carry the tools.yml entry.
.OUTPUTS
    [hashtable] Case key -> [pscustomobject] { Outcome (pass|fail|skip); Reason (the skip key, or empty); Message
    (the failure text, or the Go output of a skip) }.
.EXAMPLE
    $outcomes = Get-GoTestOutcomes -Module Catzc.Base.Repository -Case (Get-GoTestCases -Folder $folder) -GoExecutable (Get-GoTestExecutable)
#>
function Get-GoTestOutcomes {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [string] $Module,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [object[]] $Case,

        [string] $EntryScript,

        [string] $GoExecutable
    )

    $outcomes = @{}
    if (-not $GoExecutable) {
        foreach ($item in $Case) {
            $outcomes[$item.Key] = [pscustomobject]@{ Outcome = 'skip'; Reason = 'tool_go_missing'; Message = '' }
        }
        return $outcomes
    }

    $goTest = @{ Module = $Module; GoExecutable = $GoExecutable }
    if ($EntryScript) {
        $goTest['EntryScript'] = $EntryScript
    }
    $results = @{}
    foreach ($result in @(Invoke-GoTest @goTest)) {
        $results["$($result.Package) $($result.Name)"] = $result
    }

    $keys = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($item in $Case) {
        [void]$keys.Add($item.Key)
    }
    $undiscovered = @($results.Keys | Where-Object { -not $keys.Contains($_) } | Sort-Object)
    if ($undiscovered.Count -gt 0) {
        throw "go test reported test(s) the Go bridge did not discover in the *_test.go files of $($Module): $($undiscovered -join ', '). Declare each as a top-level func Test<Name>(t *testing.T)."
    }

    foreach ($item in $Case) {
        $result = $results[$item.Key]
        $outcomes[$item.Key] = if ($null -eq $result) {
            [pscustomobject]@{ Outcome = 'fail'; Reason = ''; Message = "go test reported no result for $($item.Key)." }
        }
        elseif ($result.Outcome -eq 'fail') {
            [pscustomobject]@{ Outcome = 'fail'; Reason = ''; Message = "$($item.Name) failed:`n$($result.Output)" }
        }
        elseif ($result.Outcome -eq 'skip') {
            [pscustomobject]@{ Outcome = 'skip'; Reason = 'go_test_skipped'; Message = $result.Output }
        }
        else {
            [pscustomobject]@{ Outcome = 'pass'; Reason = ''; Message = '' }
        }
    }
    $outcomes
}
