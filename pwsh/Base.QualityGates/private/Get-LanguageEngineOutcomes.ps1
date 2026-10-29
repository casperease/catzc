function Get-LanguageEngineOutcomes {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '',
        Justification = 'The import runs inside each background Start-Job engine process, never in this session')]
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

        [Parameter(Mandatory)]
        [string[]] $Engine,

        [string] $EntryScript,

        [string] $Executable,

        [hashtable] $EngineExecutable = @{},

        [string] $Folder
    )

    $pwsh = [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name
    $importer = Join-Path (Get-RepositoryRoot) ([Catzc.Base.Engines.ExecutionEngines]::Pwsh.ImporterEntry)
    # The cases cross the process boundary as their key and name, the two things the outcomes read.
    $slim = @($Case | ForEach-Object { [pscustomobject]@{ Key = $_.Key; Name = $_.Name } })

    # Every value reaches the engine process through its argument list, never by scope.
    $worker = {
        param($importer, $entryScript, $language, $module, $cases, $tool, $engine, $engineTool, $folder)
        $ErrorActionPreference = 'Stop'
        if ($entryScript) {
            . $entryScript
        }
        else {
            . $importer -SkipJanitors
        }
        & (Get-Module Catzc.Base.QualityGates) {
            param($language, $module, $cases, $entry, $tool, $engine, $engineTool, $folder)
            Get-LanguageTestOutcomes -Language $language -Module $module -Case $cases -EntryScript $entry -Executable $tool `
                -Engine $engine -EngineExecutable $engineTool -Folder $folder
        } $language $module $cases $entryScript $tool $engine $engineTool $folder
    }

    $jobs = @{}
    $inProcess = [System.Collections.Generic.List[string]]::new()
    foreach ($engineName in $Engine) {
        if ($engineName -ne $pwsh -and $Executable -and "$($EngineExecutable[$engineName])" -and @($Engine).Count -gt 1) {
            $jobs[$engineName] = Start-Job -ScriptBlock $worker -ArgumentList @($importer, $EntryScript, $Language, $Module, $slim,
                $Executable, $engineName, "$($EngineExecutable[$engineName])", $Folder)
        }
        else {
            $inProcess.Add($engineName)
        }
    }

    # A run that throws fails each of its cases with its message, so one engine's failure hides nothing.
    $runs = @{}
    foreach ($engineName in $inProcess) {
        try {
            $runs[$engineName] = [pscustomobject]@{
                Outcomes = Get-LanguageTestOutcomes -Language $Language -Module $Module -Case $Case -EntryScript $EntryScript `
                    -Executable $Executable -Engine $engineName -EngineExecutable "$($EngineExecutable[$engineName])" -Folder $Folder
                Error    = ''
            }
        }
        catch {
            $runs[$engineName] = [pscustomobject]@{ Outcomes = @{}; Error = $_.Exception.Message }
        }
    }

    $limit = (Get-Config -Config timeouts).tests.run_list_seconds
    try {
        foreach ($engineName in $jobs.Keys) {
            $job = $jobs[$engineName]
            $finished = $null -ne (Wait-Job -Job $job -Timeout $limit)
            try {
                if (-not $finished) {
                    throw "The $engineName run did not finish within $limit seconds."
                }
                $received = @(Receive-Job -Job $job -ErrorAction Stop)
                $runs[$engineName] = [pscustomobject]@{ Outcomes = [hashtable] $received[-1]; Error = '' }
            }
            catch {
                $runs[$engineName] = [pscustomobject]@{ Outcomes = @{}; Error = $_.Exception.Message }
            }
        }
    }
    finally {
        $jobs.Values | Remove-Job -Force
    }
    $runs
}
