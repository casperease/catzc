function Build-SnapshotReadme {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $SnapshotRoot
    )

    $pwshEngine = [Catzc.Base.Engines.ExecutionEngines]::Pwsh
    $start = $pwshEngine.NonInteractiveArguments -join ' '
    $importer = Join-Path $SnapshotRoot $pwshEngine.ImporterEntry
    $build = Invoke-Executable "pwsh $start -Command `". '$importer' -SkipJanitors; Build-Readme -Silent | Out-Null`"" `
        -WorkingDirectory $SnapshotRoot -PassThru -Silent -NoAssert
    if ($build.ExitCode -ne 0) {
        $tail = @("$($build.Full)".TrimEnd() -split '\r?\n' | Select-Object -Last 10) -join "`n"
        throw "Building the snapshot's README files failed (exit $($build.ExitCode)). Last lines:`n$tail"
    }
}
