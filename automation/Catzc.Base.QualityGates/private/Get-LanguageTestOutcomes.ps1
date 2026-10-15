<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1
    kind: private-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-AUTO-BASH#2
      - ADR-AUTO-ENGINE
      - ADR-AUTO-GO#2
      - ADR-AUTO-PY#2
      - ADR-AUTO-TEST#8
---
#>

<#
.SYNOPSIS
    Runs a module's tests in one test language once and returns the Pester outcome of every discovered test.
.DESCRIPTION
    A test the runner reports but discovery did not list throws, so no result goes unreported.
.PARAMETER Language
    The test language: go, python or bash.
.PARAMETER Module
    The catzc module whose tests run.
.PARAMETER Case
    The module's discovered cases (Get-GoTestCases, Get-PythonTestCases, Get-BashTestCases).
.PARAMETER EntryScript
    The engine entry of a build run (the build's Import-Catzc.ps1); empty for the source run.
.PARAMETER Executable
    The worker never locates the tool, as a build run's engine does not carry the tools.yml entry.
.PARAMETER Engine
    Every test runs once per engine, so pwsh as the default is only one of several runs of a case.
.PARAMETER EngineExecutable
    pwsh runs the harness itself and needs none; an empty executable for any other engine skips that engine's run.
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
        [ValidateSet('go', 'python', 'bash')]
        [string] $Language,

        [Parameter(Mandatory)]
        [string] $Module,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [object[]] $Case,

        [string] $EntryScript,

        [string] $Executable,

        [ArgumentCompleter({ [Catzc.Base.Engines.ExecutionEngines]::Names })]
        [string] $Engine = [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name,

        [string] $EngineExecutable
    )

    $tool = @{ go = 'go'; python = 'uv'; bash = 'bash' }[$Language]
    $pwsh = [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name
    # The language's tool missing skips the language; an engine other than the running pwsh missing skips that engine.
    $missing = if (-not $Executable) {
        "tool_$($tool)_missing"
    }
    elseif ($Engine -ne $pwsh -and -not $EngineExecutable) {
        "tool_$($Engine)_missing"
    }
    if ($missing) {
        $outcomes = @{}
        foreach ($item in $Case) {
            $outcomes[$item.Key] = [pscustomobject]@{ Outcome = 'skip'; Reason = $missing; Message = '' }
        }
        return $outcomes
    }

    $outcomes = @{}
    $run = @{ Module = $Module; Engine = $Engine }
    if ($EngineExecutable) {
        $run['EngineExecutable'] = $EngineExecutable
    }
    if ($EntryScript) {
        $run['EntryScript'] = $EntryScript
    }
    $produced = if ($Language -eq 'go') {
        Invoke-GoTest @run -GoExecutable $Executable
    }
    elseif ($Language -eq 'python') {
        Invoke-PythonTest @run -UvExecutable $Executable
    }
    else {
        # A Bash test is Bash: it runs under the bash engine only, with the bash the source session located.
        $run.Remove('Engine')
        $run['EngineExecutable'] = $Executable
        Invoke-BashTest @run
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
        throw "The $Language tests of $Module reported test(s) the language bridge did not discover in the source: $($undiscovered -join ', '). Declare each as a top-level test function, or a one-line @test in Bash, that the discovery reads (ADR-AUTO-GO#2, ADR-AUTO-PY#2, ADR-AUTO-BASH#2)."
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
