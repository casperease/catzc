<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1
    kind: automation-function
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Get-LanguageTestOutcomes.Tests.ps1
    adrs:
      - ADR-AUTO-BASH#2
      - ADR-AUTO-ENGINE
      - ADR-AUTO-GO#2
      - ADR-AUTO-PY#2
      - ADR-AUTO-TEST#8
  config:
    synopsis: Runs a module's tests in one test language once and returns the Pester outcome of every discovered test.
    description: |-
      The language bridge's run step (tests/Language.Bridge.ps1 calls it once per test folder, in its BeforeAll); each
      generated Pester test then reports its own outcome:

        - tool missing: when -Executable is empty (the run's source session found no managed tool at the tools.yml pin,
          Get-LanguageTestExecutable), nothing runs and every case is skipped with the constrained skip key
          tool_go_missing, tool_uv_missing or tool_bash_missing; when -EngineExecutable is empty for an engine other
          than pwsh, that engine's run skips every case with tool_<engine>_missing
          ([ADR-AUTO-TEST#8](/docs/adr/automation/test-automation.md#rule-adr-auto-test8));
        - otherwise the language's runner runs the module's tests (against -EntryScript in a build run): Invoke-GoTest
          for go, Invoke-PythonTest for python, Invoke-BashTest for bash (under the bash engine only: a Bash test is
          Bash). Each case takes the outcome of its result — the result types share the shape
          Package/Name/Outcome/Output — pass; fail, with the test output; or skip, with the skip key
          go_test_skipped, python_test_skipped or bash_test_skipped and the test output.

      Throws when the runner reports a test the discovery did not list (a declaration the static discovery cannot
      read), so no result goes unreported; a listed case with no result fails with that message. A failure of the
      runner itself (go vet or ruff check, a package that does not build) propagates, which fails every test of the
      module with the tool output.
    parameters:
      Language: 'The test language: go, python or bash.'
      Module: The catzc module whose tests run.
      Case: The module's discovered cases (Get-GoTestCases, Get-PythonTestCases, Get-BashTestCases).
      EntryScript: The engine entry of a build run (the build's Import-Catzc.ps1); empty for the source run.
      Executable: |-
        The managed tool the run's source session located and checked against the pin (go, uv for python, the bash
        engine for bash), handed
        down through the shard and the bridge container; empty when there is none. The worker never locates the tool
        itself: a build run's engine does not carry the tools.yml entry.
      Engine: |-
        The execution engine the tests start ([ADR-AUTO-ENGINE](/docs/adr/automation/execution-engines.md)): one of the
        model's engines, pwsh by default. Every test runs once per engine.
      EngineExecutable: |-
        The engine's executable the run's source session located; empty for an engine it did not find, whose run of the
        tests then skips with tool_<engine>_missing. pwsh, the engine running the harness, needs none.
    outputs: |-
      [hashtable] Case key -> [pscustomobject] { Outcome (pass|fail|skip); Reason (the skip key, or empty); Message
      (the failure text, or the test output of a skip) }.
    examples:
      - '$outcomes = Get-LanguageTestOutcomes -Language go -Module Catzc.Base.Repository -Case $cases -Executable $go'
---
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
