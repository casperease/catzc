<#
.SYNOPSIS
    Runs all Pester tests found across automation modules.
.PARAMETER MaxLevel
    Maximum test level to run (alias: -Level). Defaults to 2 (L0 + L1 + L2) — the L2 tier drives the
    locally-installed CLI tools and self-skips a test when its tool is absent, so the default stays green
    on a machine that is missing one.
    Tiers are defined by what a test integrates with (not by speed):
    L0/L1 = unit tests — pure logic with every external boundary mocked. L2 = integrates with a local CLI
    tool for real (e.g. `az bicep build`, python, dotnet);
    runs on a devbox and in fast CI where the tools are installed, and self-skips a test when its tool
    is absent. L3 = integrates with the cloud API layer (real cloud, maybe via a CLI tool such as
    `az deployment create`); opt-in, needs cloud access, self-skips when unavailable.
    Level 1 runs L0 + L1. Level 2 runs L0 + L1 + L2. Level 3 runs all.
    Every test must carry exactly one tier tag (L0-L3) and one category tag (logic|integrity); tests
    missing a tag are reported before the run (see Get-TestTagViolations).
.PARAMETER MinLevel
    Minimum test level to run. Defaults to 0 (no lower bound). Tiers below MinLevel are excluded, so
    -MinLevel 2 -MaxLevel 2 runs only L2 tests. Must not exceed MaxLevel.
.PARAMETER Modules
    One or more automation module names to test (tab-completes from Get-AutomationModules). Only the named
    modules' tests/ folders run; dot-prefixed infrastructure (.internal, .scriptanalyzer) is excluded.
    Empty (the default) runs every module plus that infrastructure. Composes with -Level and -Category.
.PARAMETER Category
    Which category of test to run: `Logic` (function-logic tests on mocks/fixtures), `Integrity`
    (tests that read the real repository contents — shipped configs, real templates, the module graph,
    checked-in binaries, conventions), or `Both` (the default). Composes with -Level — e.g.
    `-Level 1 -Category Logic` runs the L0/L1 logic tests only. Implemented by excluding the other
    category's tag.
.PARAMETER Output
    Pester output verbosity level. Defaults to 'Detailed' (one line per test with its own duration);
    use 'Normal' for one line per file, or 'Minimal' for just the final tally.
.PARAMETER PassThru
    Returns the Pester result object. By default, no object is returned.
.PARAMETER EnforceTimings
    Fail the run when a test exceeds its level's time limit. Off by default — timings are
    machine-dependent, so the run only *reports* over-limit tests (with their durations) and stays
    green. Pass this (e.g. in a controlled CI lane) to turn the report into a failure.
.PARAMETER OutputFolder
    Base directory for the run report. Every run writes a timestamped subfolder
    (<OutputFolder>/yyyyMMdd-HHmmss/) holding results.xml (Pester NUnit), summary.md, and tests.csv.
    Defaults to <out>/test-automation (out/ locally, the artifact staging directory in a pipeline).
.EXAMPLE
    Test-Automation
.EXAMPLE
    Test-Automation -Level 2
.EXAMPLE
    Test-Automation -MinLevel 2 -MaxLevel 2   # run only the L2 tier (skip L0/L1)
.EXAMPLE
    Test-Automation -Modules Catzc.Base.ModuleSystem   # run only one module's tests
.EXAMPLE
    Test-Automation -Modules Catzc.Azure, Catzc.Azure.Cli -Level 2   # several modules, through L2
.EXAMPLE
    Test-Automation -Category Integrity   # run only integrity tests (real configs/templates/repo checks)
.EXAMPLE
    Test-Automation -Category Logic       # run only the hermetic logic tests
.EXAMPLE
    Test-Automation -Output Detailed -PassThru
.EXAMPLE
    Test-Automation -EnforceTimings   # fail if any test is over its level's limit
.EXAMPLE
    Test-Automation -OutputFolder C:\reports\catzc   # write the run report under a custom base
#>
function Test-Automation {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = '$global:__PesterRunning is set here so the writers'' chokepoint (Write-InformationColored) and Invoke-ExecutableStreamed suppress output during the run; a flag is required because Pester captures the information stream regardless of $InformationPreference, and global is required to cross module session-state boundaries')]
    [CmdletBinding()]
    param(
        [ValidateSet(0, 1, 2, 3)]
        [int] $MinLevel = 0,

        [ValidateSet(0, 1, 2, 3)]
        [Alias('Level')]
        [int] $MaxLevel = 2,

        [ArgumentCompleter({ Get-AutomationModules })]
        [ValidateScript({ $_ -in (Get-AutomationModules) })]
        [string[]] $Modules = @(),

        [ValidateSet('Logic', 'Integrity', 'Both')]
        [string] $Category = 'Both',

        [ValidateSet('Minimal', 'Normal', 'Detailed', 'Diagnostic')]
        [string] $Output = 'Detailed',

        [switch] $PassThru,

        [switch] $EnforceTimings,

        [string] $OutputFolder
    )

    if ($MinLevel -gt $MaxLevel) {
        throw "MinLevel ($MinLevel) cannot exceed MaxLevel ($MaxLevel)."
    }

    # Lazy-load Pester — deferred at import time for speed
    if (-not (Get-Module Pester)) {
        $pesterPath = Join-Path $env:RepositoryRoot 'automation/.vendor/Pester'
        Write-Verbose "Lazy-loading Pester from: $pesterPath"
        Import-Module $pesterPath -Scope Global -Force
    }

    $automationRoot = Join-Path $env:RepositoryRoot 'automation'

    # Discover every automation/<dir>/tests folder in a single .NET directory scan — one enumeration
    # instead of two Get-ChildItem passes, with no pipeline/object overhead (and fewer filesystem round
    # trips on network-backed repos, see effective-in-enterprises). Module tests run FOUNDATION-FIRST
    # (Get-ModuleTestOrder — a topological sort of the declared dependency graph), so a broken base
    # module's failures surface before the dependents that cascade from it; dot-prefixed infrastructure
    # (.internal, .scriptanalyzer) runs after, ordinally.
    $allDirs = [System.IO.Directory]::GetDirectories($automationRoot)
    [Array]::Sort($allDirs)

    $moduleTestsByName = [ordered]@{}
    $infraTestPaths = [System.Collections.Generic.List[string]]::new()
    foreach ($dir in $allDirs) {
        $dirName = [System.IO.Path]::GetFileName($dir)
        $isInfra = $dirName.StartsWith('.')

        # -Modules narrows the run to the named automation modules. Dot-prefixed infrastructure
        # (.internal, .scriptanalyzer) is never a named module, so it only runs in the unfiltered case.
        if ($Modules -and ($isInfra -or $dirName -notin $Modules)) {
            continue
        }

        $testsPath = [System.IO.Path]::Combine($dir, 'tests')
        if (-not [System.IO.Directory]::Exists($testsPath)) {
            continue
        }

        if ($isInfra) {
            $infraTestPaths.Add($testsPath)
        }
        else {
            $moduleTestsByName[$dirName] = $testsPath
        }
    }

    # Foundation-first module order from the dependency graph — best-effort: if the graph cannot be
    # ordered (a malformed or cyclic dependencies.yml, which its OWN tests then report), fall back to the
    # ordinal order so the suite still runs rather than the runner crashing on the config it is testing.
    $moduleOrder = try {
        Get-ModuleTestOrder
    }
    catch {
        Write-Verbose "Get-ModuleTestOrder failed ($_); falling back to ordinal module order."
        @($moduleTestsByName.Keys)
    }

    $moduleTestPaths = [System.Collections.Generic.List[string]]::new()
    foreach ($name in $moduleOrder) {
        if ($moduleTestsByName.Contains($name)) {
            $moduleTestPaths.Add($moduleTestsByName[$name])
            $moduleTestsByName.Remove($name)
        }
    }
    # Any discovered module the order did not name (safety) — append in the ordinal order already scanned.
    foreach ($name in @($moduleTestsByName.Keys)) {
        $moduleTestPaths.Add($moduleTestsByName[$name])
    }

    $testPaths = @($moduleTestPaths) + @($infraTestPaths)

    if (-not $testPaths) {
        if ($Modules) {
            throw "No test folders found for the requested module(s): $($Modules -join ', '). A module has tests only if it has a tests/ folder."
        }
        throw 'No test folders found'
    }

    # Enforce the two mandatory tag axes (tier L0-L3 + category logic|integrity) on every test. A discovery-
    # only pass sees all tests regardless of -Level, so a missing/ambiguous tag fails the run even when its
    # tier would be excluded (see docs/adr/automation/test-automation.md).
    $tagViolations = Get-TestTagViolations -TestPath $testPaths
    if ($tagViolations.Count -gt 0) {
        Write-Message "$($tagViolations.Count) test(s) missing a required tag (each needs exactly one tier L0-L3 + one category logic|integrity):" -ForegroundColor Red -NoHeader
        foreach ($violation in $tagViolations) {
            Write-Message "  [$($violation.Reason)] $($violation.Test)" -ForegroundColor Red -NoHeader
        }
        throw "$($tagViolations.Count) test(s) are missing a required tier/category tag — see the list above."
    }

    # Build tag filter — exclude tiers outside [MinLevel, MaxLevel] and (when -Category is given) the other
    # category, so only the requested category's tests run. ExcludeTag matches an item's own tag, so a mixed
    # file's per-Context category tags filter correctly. Shared with Test-InIsolation via Get-TestExcludeTag.
    $excludeTags = Get-TestExcludeTag -MinLevel $MinLevel -MaxLevel $MaxLevel -Category $Category

    # Resolve the run directory — a timestamped subfolder under the report base so each run's artifacts are
    # preserved (and cleared with the rest of out/). Pester writes results.xml here; summary.md/tests.csv follow.
    if (-not $OutputFolder) {
        $OutputFolder = Join-Path (Get-OutputRoot -EnsureExists) 'test-automation'
    }
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $runDir = Join-Path $OutputFolder $stamp
    $i = 2
    while (Test-Path $runDir) {
        $runDir = Join-Path $OutputFolder "$stamp-$i"
        $i++
    }
    New-Item -ItemType Directory -Path $runDir -Force | Out-Null

    $config = New-PesterConfiguration
    $config.Run.Path = $testPaths
    $config.Run.PassThru = $true
    $config.Output.Verbosity = $Output
    if ($excludeTags.Count -gt 0) {
        $config.Filter.ExcludeTag = $excludeTags
    }

    # Canonical machine artifact — Pester writes this during the run, so it survives a failing run.
    $config.TestResult.Enabled = $true
    $config.TestResult.OutputFormat = 'NUnitXml'
    $config.TestResult.OutputPath = Join-Path $runDir 'results.xml'
    $config.TestResult.OutputEncoding = 'UTF8'
    $config.TestResult.TestSuiteName = 'Catzc'

    # Arm the unit-test tripwire for tool-free levels (L0/L1). If a test then launches a real process, a
    # Mock failed to intercept it — almost always a -ModuleName pointing at the wrong module — so the test
    # was silently hitting the live tool; Invoke-Executable throws instead of leaking. L2+ legitimately
    # drive real CLIs, so it stays off there. See docs/adr/automation/test-automation.md.
    # Silence human-facing output during the run. This must be a flag the writers check, not a stream
    # preference: Pester captures the information stream around each test and replays it at Normal+
    # verbosity, so $InformationPreference = 'SilentlyContinue' does not stop it — only not writing does.
    # Write-InformationColored (the writers' chokepoint) returns early on this flag. It also silences the
    # raw Console output a child process streams through Invoke-ExecutableStreamed.
    $armTripwire = $MaxLevel -lt 2

    # Announce the run before Pester's own output — the writers' suppression flag is still unset, so the
    # header renders and the run's output (Pester's lines, then the sections below) sits under it.
    Write-TestAutomationHeader -MinLevel $MinLevel -MaxLevel $MaxLevel -Category $Category -Modules $Modules

    $global:__PesterRunning = $true
    if ($armTripwire) {
        $env:CATZC_BLOCK_REAL_PROCESS = '1'
    }
    try {
        $ret = Invoke-Pester -Configuration $config
    }
    finally {
        $global:__PesterRunning = $false
        if ($armTripwire) {
            Remove-Item Env:\CATZC_BLOCK_REAL_PROCESS -ErrorAction Ignore
        }
    }

    # Validate test durations against level limits
    # L0 < 400ms, L1 < 2s (default for untagged), L2 < 120s, L3 < 30s
    $limits = @{ 'L0' = 400; 'L1' = 2000; 'L2' = 120000; 'L3' = 30000 }
    $violations = @()

    foreach ($test in $ret.Tests) {
        if ($test.Result -ne 'Passed') {
            continue
        }

        $tag = Get-TestLevelTag -Test $test
        if (-not $tag) {
            continue
        }   # untagged/ambiguous tier — already reported by the tag check
        $limitMs = $limits[$tag]
        $ms = [int]$test.Duration.TotalMilliseconds

        if ($ms -gt $limitMs) {
            $violations += "[$tag > ${limitMs}ms] $($test.ExpandedName) took ${ms}ms"
        }
    }

    if ($violations.Count -gt 0) {
        # Timings are machine-dependent, so report them by default and only FAIL the run when the
        # caller opts in with -EnforceTimings. Either way the durations are written out below.
        $color = if ($EnforceTimings) {
            'Red'
        }
        else {
            'Yellow'
        }
        $header = if ($EnforceTimings) {
            'Tests exceeding level time limits'
        }
        else {
            'Tests exceeding level time limits (report-only — pass -EnforceTimings to fail)'
        }
        Write-Message '' -NoHeader
        Write-Header $header -ForegroundColor $color
        foreach ($v in $violations) {
            Write-Message "  $v" -ForegroundColor $color -NoHeader
        }
        Write-Message 'Tag slow tests with a higher level or optimize them.' -NoHeader
        Write-Footer -ForegroundColor $color
        if ($EnforceTimings) {
            $result.Result = 'Failed'
        }
    }

    # Persist the run report (summary.md + tests.csv) beside Pester's results.xml — written here, before any
    # throw, so a failing run still produces it. Best-effort: a rendering error must never mask the outcome.
    try {
        Write-TestAutomationReport -Result $ret -OutputFolder $runDir -Level $MaxLevel -Limits $limits -TimingsEnforced:$EnforceTimings
        Set-Content -Path (Join-Path $OutputFolder 'latest.txt') -Value (Split-Path $runDir -Leaf) -Encoding utf8
        Write-Message '' -NoHeader
        Write-Message "Test report: $runDir" -ForegroundColor Cyan -NoHeader
    }
    catch {
        Write-Message "Could not write test report to ${runDir}: $_" -ForegroundColor Yellow -NoHeader
    }

    # Final section: what was skipped (a self-skip, with its reason) or not run (excluded by this run's
    # tier/category scope). Best-effort — a rendering error here must never mask the run outcome below.
    try {
        Write-TestAutomationSkipReport -Result $ret -MinLevel $MinLevel -MaxLevel $MaxLevel -Category $Category
    }
    catch {
        Write-Message "Could not render the skip report: $_" -ForegroundColor Yellow -NoHeader
    }

    if ($PassThru) {
        $ret
    }
    elseif ($ret.Result -ne 'Passed') {
        # The failure gets its own red banner (a self-contained box) before the throw, so the outcome reads at
        # a glance above the raw error.
        Write-Header "Test Automation FAILED — $($ret.FailedCount) test(s) failed" -ForegroundColor Red
        throw "Test-Automation failed: $($ret.FailedCount) test(s) failed"
    }
}
