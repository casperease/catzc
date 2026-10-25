<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-LanguageTestOutcomes.ps1.md"
  header: "generated"
---
#>

function Get-LanguageTestOutcomes {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
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

        [string] $EngineExecutable,

        # The test folder the discovery named, a module's own tests/ or the holder's; the runner finds the holder's when it is empty.
        [string] $Folder
    )

    $entry = @((Get-Config -Config languages).languages | Where-Object { $_.name -ceq $Language })
    $tests = if ($entry.Count -eq 1) {
        $entry[0].tests
    }
    if ($null -eq $tests) {
        throw "Language '$Language' declares no tests entry in languages.yml, so no runner runs its tests."
    }
    $pwsh = [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name
    # The language's tool missing skips the language; an engine other than the running pwsh missing skips that engine.
    $missing = if (-not $Executable) {
        "tool_$($tests.ExecutableName)_missing"
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
    if ($Folder) {
        $run['Folder'] = $Folder
    }
    if ($tests.engine) {
        # A language that is an engine runs its tests under that engine only, with the executable the source session located.
        $run.Remove('Engine')
    }
    $run[$tests.executable_parameter] = $Executable
    $produced = & $tests.runner @run
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
        throw "The $Language tests of $Module reported test(s) the language bridge did not discover in the source: $($undiscovered -join ', '). Declare each as a top-level test function, or a one-line @test in Bash, that the discovery reads (ADR-AUTO-GO-ONEGOROOT, ADR-AUTO-PY-ONEPYTHONROOT, ADR-AUTO-BASH-ONEBASHROOT)."
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
