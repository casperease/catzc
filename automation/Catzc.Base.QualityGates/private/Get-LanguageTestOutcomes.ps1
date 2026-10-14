<#
.SYNOPSIS
    Runs a module's tests in one test language once and returns the Pester outcome of every discovered test.
.DESCRIPTION
    The language bridge's run step (tests/Language.Bridge.ps1 calls it once per test folder, in its BeforeAll); each
    generated Pester test then reports its own outcome:

      - tool missing: when -Executable is empty (the run's source session found no managed tool at the tools.yml pin,
        Get-LanguageTestExecutable), nothing runs and every case is skipped with the constrained skip key
        tool_go_missing or tool_uv_missing
        ([ADR-AUTO-TEST#8](/docs/adr/automation/test-automation.md#rule-adr-auto-test8));
      - otherwise the language's runner runs the module's tests (against -EntryScript in a build run): Invoke-GoTest
        for go, Invoke-PythonTest for python. Each case takes the outcome of its result — both result types share
        the shape Package/Name/Outcome/Output — pass; fail, with the test output; or skip, with the skip key
        go_test_skipped or python_test_skipped and the test output.

    Throws when the runner reports a test the discovery did not list (a declaration the static discovery cannot
    read), so no result goes unreported; a listed case with no result fails with that message. A failure of the
    runner itself (go vet or ruff check, a package that does not build) propagates, which fails every test of the
    module with the tool output.
.PARAMETER Language
    The test language: go or python.
.PARAMETER Module
    The catzc module whose tests run.
.PARAMETER Case
    The module's discovered cases (Get-GoTestCases, Get-PythonTestCases).
.PARAMETER EntryScript
    The engine entry of a build run (the build's Import-Catzc.ps1); empty for the source run.
.PARAMETER Executable
    The managed tool the run's source session located and checked against the pin (go, or uv for python), handed
    down through the shard and the bridge container; empty when there is none. The worker never locates the tool
    itself: a build run's engine does not carry the tools.yml entry.
.OUTPUTS
    [hashtable] Case key -> [pscustomobject] { Outcome (pass|fail|skip); Reason (the skip key, or empty); Message
    (the failure text, or the test output of a skip) }.
.EXAMPLE
    $outcomes = Get-LanguageTestOutcomes -Language go -Module Catzc.Base.Repository -Case $cases -Executable $go
#>
function Get-LanguageTestOutcomes {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('go', 'python')]
        [string] $Language,

        [Parameter(Mandatory)]
        [string] $Module,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [object[]] $Case,

        [string] $EntryScript,

        [string] $Executable
    )

    $tool = @{ go = 'go'; python = 'uv' }[$Language]
    $outcomes = @{}
    if (-not $Executable) {
        foreach ($item in $Case) {
            $outcomes[$item.Key] = [pscustomobject]@{ Outcome = 'skip'; Reason = "tool_$($tool)_missing"; Message = '' }
        }
        return $outcomes
    }

    $run = @{ Module = $Module }
    if ($EntryScript) {
        $run['EntryScript'] = $EntryScript
    }
    $produced = if ($Language -eq 'go') {
        Invoke-GoTest @run -GoExecutable $Executable
    }
    else {
        Invoke-PythonTest @run -UvExecutable $Executable
    }
    $results = @{}
    foreach ($result in @($produced)) {
        $results["$($result.Package) $($result.Name)"] = $result
    }

    $keys = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($item in $Case) {
        [void]$keys.Add($item.Key)
    }
    $undiscovered = @($results.Keys | Where-Object { -not $keys.Contains($_) } | Sort-Object)
    if ($undiscovered.Count -gt 0) {
        throw "The $Language tests of $Module reported test(s) the language bridge did not discover in the source: $($undiscovered -join ', '). Declare each as a top-level test function the discovery reads (ADR-AUTO-GO#2, ADR-AUTO-PY#2)."
    }

    foreach ($item in $Case) {
        $result = $results[$item.Key]
        $outcomes[$item.Key] = if ($null -eq $result) {
            [pscustomobject]@{ Outcome = 'fail'; Reason = ''; Message = "The $Language test run reported no result for $($item.Key)." }
        }
        elseif ($result.Outcome -eq 'fail') {
            [pscustomobject]@{ Outcome = 'fail'; Reason = ''; Message = "$($item.Name) failed:`n$($result.Output)" }
        }
        elseif ($result.Outcome -eq 'skip') {
            [pscustomobject]@{ Outcome = 'skip'; Reason = "$($Language)_test_skipped"; Message = $result.Output }
        }
        else {
            [pscustomobject]@{ Outcome = 'pass'; Reason = ''; Message = '' }
        }
    }
    $outcomes
}
