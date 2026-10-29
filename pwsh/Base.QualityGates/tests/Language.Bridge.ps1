[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'TestFolder',
    Justification = 'Read in the BeforeDiscovery block, which the analyzer does not follow.')]
param(
    # go, python, bash or javascript.
    [Parameter(Mandatory)]
    [string] $Language,

    [Parameter(Mandatory)]
    [string] $TestFolder,

    # The engine entry of a build run (the build's Import-Catzc.ps1); empty for the source run.
    [string] $EntryScript,

    # The managed tool the run's source session located (Get-LanguageTestExecutable); empty when there is none.
    [string] $Executable,

    # An empty or missing entry means that engine's run of the tests skips.
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
            elseif ($language -eq 'javascript') {
                @(Get-JavaScriptTestCases -Folder $folder)
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
        # A Bash test is Bash, so it runs under the bash engine only.
        Engines     = if ($Language -eq 'bash') {
            @([Catzc.Base.Engines.ExecutionEngines]::Bash.Name)
        }
        elseif ($Language -eq 'javascript') {
            @([Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name)
        }
        else {
            @([Catzc.Base.Engines.ExecutionEngines]::Names)
        }
        EngineTools = $EngineExecutable
    }) {
    BeforeAll {
        $runs = & (Get-Module Catzc.Base.QualityGates) {
            param($language, $module, $cases, $engines, $entry, $tool, $engineTools, $folder)
            Get-LanguageEngineOutcomes -Language $language -Module $module -Case $cases -Engine $engines -EntryScript $entry `
                -Executable $tool -EngineExecutable $engineTools -Folder $folder
        } $Language $Module $Cases $Engines $Entry $Tool $EngineTools $Folder
        $script:languageOutcomes = @{}
        # A run that throws fails each of its cases with its message, so one BeforeAll failure hides nothing.
        $script:languageErrors = @{}
        foreach ($engineName in $Engines) {
            if ($runs[$engineName].Error) {
                $script:languageErrors[$engineName] = $runs[$engineName].Error
            }
            else {
                $script:languageOutcomes[$engineName] = $runs[$engineName].Outcomes
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
