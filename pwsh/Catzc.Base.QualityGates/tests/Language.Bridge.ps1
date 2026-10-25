<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/tests/Language.Bridge.ps1.md"
  warning: "Generated Header"
---
#>

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

    [hashtable] $EngineExecutable = @{}
)

BeforeDiscovery {
    $script:languageSuite = & (Get-Module Catzc.Base.QualityGates) {
        param($language, $folder)
        $mapped = @(Get-LanguageTestFolders | Where-Object { $_.Language -eq $language -and $_.Folder -eq $folder })
        if ($mapped.Count -ne 1) {
            throw "$folder is not a $language test folder of a catzc module (Get-LanguageTestFolders)."
        }
        $cases = @(if ($language -eq 'go') {
                @(Get-GoTestCases -Folder $folder)
            }
            elseif ($language -eq 'python') {
                @(Get-PythonTestCases -Folder $folder)
            }
            else {
                @(Get-BashTestCases -Folder $folder)
            })
        @{ Module = $mapped[0].Module; Cases = $cases }
    } $Language $TestFolder
}

Describe "$Language tests of $($script:languageSuite.Module)" -Tag 'L2', 'greedy' -ForEach @(@{
        Language = $Language; Module = $script:languageSuite.Module; Cases = $script:languageSuite.Cases; Entry = $EntryScript; Tool = $Executable
        Folder      = $TestFolder
        # A Bash test is Bash, so it runs under the bash engine only; every other language's test runs under each.
        Engines     = if ($Language -eq 'bash') {
            @([Catzc.Base.Engines.ExecutionEngines]::Bash.Name)
        }
        else {
            @([Catzc.Base.Engines.ExecutionEngines]::Names)
        }
        EngineTools = $EngineExecutable
    }) {
    BeforeAll {
        $script:languageOutcomes = @{}
        $script:languageErrors = @{}
        foreach ($engineName in $Engines) {
            try {
                $script:languageOutcomes[$engineName] = & (Get-Module Catzc.Base.QualityGates) {
                    param($language, $module, $cases, $entry, $tool, $engine, $engineTool, $folder)
                    Get-LanguageTestOutcomes -Language $language -Module $module -Case $cases -EntryScript $entry -Executable $tool `
                        -Engine $engine -EngineExecutable $engineTool -Folder $folder
                } $Language $Module $Cases $Entry $Tool $engineName "$($EngineTools[$engineName])" $Folder
            }
            catch {
                $script:languageErrors[$engineName] = $_.Exception.Message
            }
        }
    }

    foreach ($engineName in $Engines) {
        foreach ($languageCase in $Cases) {
            It "$($languageCase.Title) [$engineName]" -Tag $languageCase.Category -ForEach @(@{ Key = $languageCase.Key; EngineName = $engineName }) {
                if ($script:languageErrors.ContainsKey($EngineName)) {
                    throw "The $EngineName run failed before its cases ran: $($script:languageErrors[$EngineName])"
                }
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
