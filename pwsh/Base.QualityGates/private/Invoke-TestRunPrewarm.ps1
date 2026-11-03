function Invoke-TestRunPrewarm {
    [CmdletBinding()]
    [OutputType([double])]
    param(
        [AllowNull()]
        [pscustomobject] $Prewarm
    )

    # Nothing was started: no prewarm script, or a run that blocks every real process.
    if ($null -eq $Prewarm) {
        return 0.0
    }

    $runner = Wait-PesterRunner -Runner $Prewarm.Runner
    $Prewarm.Stopwatch.Stop()
    # A failed prewarm only costs speed: each test still builds what the cache lacks, so it is said and the run goes on.
    for ($index = 0; $index -lt $runner.Results.Count; $index++) {
        $result = $runner.Results[$index]
        if ($result.ExitCode -ne 0) {
            Write-Message "Prewarm $([System.IO.Path]::GetFileName($Prewarm.Prewarms[$index])) exited $($result.ExitCode); its tests build what it left out.$(if ("$($result.Stderr)".Trim()) { "`n$("$($result.Stderr)".Trim())" })" -ForegroundColor Yellow
        }
    }
    Write-Message "Prewarm done in $([Math]::Round($Prewarm.Stopwatch.Elapsed.TotalSeconds, 2)) s." -NoHeader
    $Prewarm.Stopwatch.Elapsed.TotalSeconds
}
