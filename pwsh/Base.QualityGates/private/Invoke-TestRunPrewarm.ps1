function Invoke-TestRunPrewarm {
    [CmdletBinding()]
    [OutputType([double])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $TestFile,

        [Parameter(Mandatory)]
        [string] $RunDirectory,

        [Parameter(Mandatory)]
        [hashtable] $WorkerEnvironment,

        [Parameter(Mandatory)]
        [ValidateRange(60, 86400)]
        [int] $TimeoutSeconds,

        [string] $EntryScript,

        [hashtable] $EntryParameter = @{}
    )

    # A run that blocks every real process runs no test a prewarm could feed.
    if ($WorkerEnvironment['CATZC_BLOCK_REAL_PROCESS'] -eq [Catzc.Base.Timeouts.TestTiers]::BlockEveryLaunch) {
        return 0.0
    }
    # Each tests folder holding a selected file brings its *.Prewarm.ps1 scripts, run once before the pool.
    $folders = @($TestFile | ForEach-Object { [System.IO.Path]::GetDirectoryName($_) } | Sort-Object -Unique)
    $prewarms = @(foreach ($folder in $folders) {
            if ([System.IO.Directory]::Exists($folder)) {
                [System.IO.Directory]::GetFiles($folder, '*.Prewarm.ps1') | Sort-Object
            }
        })
    if ($prewarms.Count -eq 0) {
        return 0.0
    }

    $entryLine = Get-TestRunEntryLine -EntryScript $EntryScript -EntryParameter $EntryParameter
    $scripts = [System.Collections.Generic.List[string]]::new()
    $labels = [System.Collections.Generic.List[string]]::new()
    for ($index = 0; $index -lt $prewarms.Count; $index++) {
        $scriptPath = Join-Path $RunDirectory "prewarm-$index.ps1"
        $content = @"
`$ErrorActionPreference = 'Stop'
$entryLine
[void] [Catzc.Base.QualityGates.WorkerParentWatch]::Start(2000)
Set-StrictMode -Version Latest
& '$($prewarms[$index] -replace "'", "''")'
"@
        Set-Content -LiteralPath $scriptPath -Value $content -Encoding utf8
        $scripts.Add($scriptPath)
        $labels.Add("prewarm-$index")
    }

    Write-Message "Prewarming $($prewarms.Count) script(s) before the pool: $(($prewarms | ForEach-Object { [System.IO.Path]::GetFileName($_) }) -join ', ')..." -NoHeader
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $runner = [Catzc.Base.QualityGates.PesterRunner]::Run([string[]] $scripts, [string[]] $labels,
        [Math]::Max(1, [Environment]::ProcessorCount), $WorkerEnvironment, $TimeoutSeconds, $false)
    $stopwatch.Stop()
    # A failed prewarm only costs speed: each test still builds what the cache lacks, so it is said and the run goes on.
    for ($index = 0; $index -lt $runner.Results.Count; $index++) {
        $result = $runner.Results[$index]
        if ($result.ExitCode -ne 0) {
            Write-Message "Prewarm $([System.IO.Path]::GetFileName($prewarms[$index])) exited $($result.ExitCode); its tests build what it left out.$(if ("$($result.Stderr)".Trim()) { "`n$("$($result.Stderr)".Trim())" })" -ForegroundColor Yellow
        }
    }
    Write-Message "Prewarm done in $([Math]::Round($stopwatch.Elapsed.TotalSeconds, 2)) s." -NoHeader
    $stopwatch.Elapsed.TotalSeconds
}
