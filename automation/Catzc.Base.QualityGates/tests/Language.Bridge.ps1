# The language bridge: one shared Pester file the harness runs once per test folder of a test language beside
# PowerShell (Go, Python, Bash), as a Pester container whose data names the language, the folder, the engine entry, and the
# tool the run's source session located (ConvertTo-PesterRunTarget). It is not a *.Tests.ps1 file, so no path scan
# runs it without that data.
#
# Discovery reads the folder's tests from its source files (Get-GoTestCases, Get-PythonTestCases, Get-BashTestCases),
# so every test becomes one Pester test per engine it runs under (every engine; Bash tests the bash engine only), tagged
# L2 (a real tool and a real engine, [ADR-AUTO-TEST#9](/docs/adr/automation/test-automation.md#rule-adr-auto-test9))
# plus its category from its name (TestIntegrity*, test_integrity* or "integrity: …" is integrity, everything else
# logic). The run calls the language's runner once
# for the module (Get-LanguageTestOutcomes): each test then passes, fails with the test output, or skips as the test
# did; when the source session handed down no managed tool at the pinned version, every test skips with
# tool_go_missing, tool_uv_missing or tool_bash_missing ([ADR-AUTO-TEST#8](/docs/adr/automation/test-automation.md#rule-adr-auto-test8)).
# The tests start the engine in processes of their own, so the file runs in the greedy phase
# ([ADR-AUTO-TEST#26](/docs/adr/automation/test-automation.md#rule-adr-auto-test26)).
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'TestFolder', Justification = 'Read in the BeforeDiscovery block, which the analyzer does not follow.')]
param(
    # go, python or bash.
    [Parameter(Mandatory)]
    [string] $Language,

    [Parameter(Mandatory)]
    [string] $TestFolder,

    # The engine entry of a build run (the build's Import-Catzc.ps1); empty for the source run.
    [string] $EntryScript,

    # The managed tool the run's source session located (Get-LanguageTestExecutable); empty when there is none.
    [string] $Executable,

    # The executables of the engines other than pwsh, by engine name, as the run's source session located them; an empty
    # or missing entry means that engine's run of the tests skips.
    [hashtable] $EngineExecutable = @{}
)

BeforeDiscovery {
    $script:languageSuite = & (Get-Module Catzc.Base.QualityGates) {
        param($language, $folder)
        $mapped = @(Get-LanguageTestFolders | Where-Object { $_.Language -eq $language -and $_.Folder -eq $folder })
        if ($mapped.Count -ne 1) {
            throw "$folder is not a $language test folder of a catzc module (Get-LanguageTestFolders)."
        }
        $cases = if ($language -eq 'go') {
            @(Get-GoTestCases -Folder $folder)
        }
        elseif ($language -eq 'python') {
            @(Get-PythonTestCases -Folder $folder)
        }
        else {
            @(Get-BashTestCases -Folder $folder)
        }
        @{ Module = $mapped[0].Module; Cases = $cases }
    } $Language $TestFolder
}

Describe "$Language tests of $($script:languageSuite.Module)" -Tag 'L2', 'greedy' -ForEach @(@{
        Language = $Language; Module = $script:languageSuite.Module; Cases = $script:languageSuite.Cases; Entry = $EntryScript; Tool = $Executable
        # A Bash test is Bash, so it runs under the bash engine only; every other language's test runs under each.
        Engines = if ($Language -eq 'bash') { @([Catzc.Base.Engines.ExecutionEngines]::Bash.Name) } else { @([Catzc.Base.Engines.ExecutionEngines]::Names) }
        EngineTools = $EngineExecutable
    }) {
    BeforeAll {
        # Every test runs once per execution engine (ADR-AUTO-ENGINE#4): the same test, a different contract.
        $script:languageOutcomes = @{}
        foreach ($engineName in $Engines) {
            $script:languageOutcomes[$engineName] = & (Get-Module Catzc.Base.QualityGates) {
                param($language, $module, $cases, $entry, $tool, $engine, $engineTool)
                Get-LanguageTestOutcomes -Language $language -Module $module -Case $cases -EntryScript $entry -Executable $tool `
                    -Engine $engine -EngineExecutable $engineTool
            } $Language $Module $Cases $Entry $Tool $engineName "$($EngineTools[$engineName])"
        }
    }

    foreach ($engineName in $Engines) {
        foreach ($languageCase in $Cases) {
            It "$($languageCase.Title) [$engineName]" -Tag $languageCase.Category -ForEach @(@{ Key = $languageCase.Key; EngineName = $engineName }) {
                $outcome = $script:languageOutcomes[$EngineName][$Key]
                if ($outcome.Outcome -eq 'skip') {
                    Set-ItResult -Skipped -Because $outcome.Reason
                    return
                }
                if ($outcome.Outcome -eq 'fail') {
                    throw $outcome.Message
                }
            }
        }
    }
}
