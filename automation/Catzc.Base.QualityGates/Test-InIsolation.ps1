<#
.SYNOPSIS
    Copies a module profile into a tmp sandbox and runs its tests in isolation — a clean child pwsh (true
    isolation) or the current session (fast) — so a subset of the toolset is verified deterministically.
.DESCRIPTION
    Integrity tests need the whole real repo, so a subset sandbox defaults to Logic and the L0 and L1 unit tiers.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Test-InIsolation.ps1.md#comment1)
.PARAMETER ModuleProfile
    A profile from configs/profiles.yml (minimal, base, azure, tooling, full). Default: minimal.
.PARAMETER Modules
    An explicit seed list instead of a named profile — resolved through the same closure logic.
.PARAMETER Isolation
    Process (child pwsh, true isolation — default) or InProcess (current session, fast).
.PARAMETER Category
    Logic (default), Integrity, or Both. Integrity assumes the full real repo — use only with the full profile.
.PARAMETER MaxLevel
    Highest tier to run (0-4). Default 1 (L0+L1 — the hermetic unit tiers). Alias -Level.
.PARAMETER MinLevel
    Lowest tier to run (0-4). Default 0.
.PARAMETER Destination
    A given Destination is never auto-removed; only the fresh temporary directory is, unless -KeepSandbox.
    [comment:2](/docs/references/automation/catzc-base-qualitygates/Test-InIsolation.ps1.md#comment2)
.PARAMETER KeepSandbox
    Keep the sandbox (and its results.xml) after the run instead of deleting it.
.PARAMETER PassThru
    Return the run summary object instead of throwing on failure.
.OUTPUTS
    [pscustomobject] with Isolation, Sandbox, Modules, Total, Failed, Success, ResultsPath (under -PassThru).
.EXAMPLE
    Test-InIsolation -ModuleProfile azure
.EXAMPLE
    Test-InIsolation -Modules Catzc.Base.Config -Isolation InProcess -PassThru
#>
function Test-InIsolation {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-NoEnvRepositoryRoot', '', Justification = 'The InProcess mode swaps $env:RepositoryRoot for the sandbox and restores it: the variable itself is the subject, so it saves the hand-off value, not the root through the accessor')]
    [CmdletBinding(DefaultParameterSetName = 'ModuleProfile')]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Position = 0, ParameterSetName = 'ModuleProfile')]
        [ArgumentCompleter({ (Get-Config -Config profiles).profiles.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config profiles).profiles.Keys })]
        [string] $ModuleProfile = 'minimal',

        [Parameter(Mandatory, ParameterSetName = 'Modules')]
        [string[]] $Modules,

        [ValidateSet('Process', 'InProcess')]
        [string] $Isolation = 'Process',

        [ValidateSet('Logic', 'Integrity', 'Both')]
        [string] $Category = 'Logic',

        [ValidateSet(0, 1, 2, 3, 4)]
        [Alias('Level')]
        [int] $MaxLevel = 1,

        [ValidateSet(0, 1, 2, 3, 4)]
        [int] $MinLevel = 0,

        [string] $Destination,

        [switch] $KeepSandbox,

        [switch] $PassThru
    )

    Import-VendoredPester

    # 1) Resolve the module set (closure + infrastructure).
    $set = if ($PSCmdlet.ParameterSetName -eq 'Modules') {
        Get-ModuleProfile -Modules $Modules
    }
    else {
        Get-ModuleProfile -Name $ModuleProfile
    }

    # 2) Sandbox destination — a caller-supplied dir, or a fresh tmp we own (and remove).
    $ownsSandbox = -not $Destination
    $sandbox = if ($Destination) {
        [System.IO.Path]::GetFullPath($Destination)
    }
    else {
        Join-Path ([System.IO.Path]::GetTempPath()) ('catzc-isolation-' + [guid]::NewGuid().ToString('N'))
    }
    $resultsPath = Join-Path $sandbox '.isolation-results.xml'

    try {
        # 3) Copy the subset into the sandbox.
        Copy-Automation -ModuleNames $set -Destination $sandbox -EmptyDestination | Out-Null

        # 4) The sandbox test folders (named modules only — never .vendor/.compiled).
        $testPaths = foreach ($module in $set) {
            if ($module -in '.vendor', '.compiled') {
                continue
            }
            $candidate = Join-Path $sandbox "automation/$module/tests"
            if (Test-Path $candidate) {
                $candidate
            }
        }
        $testPaths = @($testPaths)
        $excludeTags = Get-TestExcludeTag -MinLevel $MinLevel -MaxLevel $MaxLevel -Category $Category

        $total = 0
        $failed = 0
        if ($testPaths.Count -eq 0) {
            Write-Message "Test-InIsolation: no test folders in the '$(if ($ModuleProfile) { $ModuleProfile } else { 'custom' })' sandbox — nothing to run."
        }
        elseif ($Isolation -eq 'Process') {
            # Going through Invoke-Executable keeps the child mockable and under the unit-test tripwire.
            # [comment:3](/docs/references/automation/catzc-base-qualitygates/Test-InIsolation.ps1.md#comment3)
            $pathLiteral = ($testPaths | ForEach-Object { "'$_'" }) -join ', '
            $tagLiteral = ($excludeTags | ForEach-Object { "'$_'" }) -join ', '
            $runner = Join-Path $sandbox '.isolation-run.ps1'
            $runnerContent = @"
`$ErrorActionPreference = 'Stop'
. '$sandbox/importer.ps1' -SkipJanitors
Import-Module '$sandbox/automation/.vendor/Pester' -Force
`$config = New-PesterConfiguration
`$config.Run.Path = @($pathLiteral)
`$config.Run.PassThru = `$true
`$config.Output.Verbosity = 'Detailed'
`$config.Filter.ExcludeTag = @($tagLiteral)
`$config.TestResult.Enabled = `$true
`$config.TestResult.OutputFormat = 'NUnitXml'
`$config.TestResult.OutputPath = '$resultsPath'
`$r = Invoke-Pester -Configuration `$config
exit `$r.FailedCount
"@
            Set-Content -LiteralPath $runner -Value $runnerContent -Encoding utf8
            $run = Invoke-Executable "pwsh -NoProfile -File `"$runner`"" -PassThru -NoAssert
            $failed = $run.ExitCode
            if (Test-Path $resultsPath) {
                $doc = [xml] (Get-Content -LiteralPath $resultsPath -Raw)
                if ($doc.'test-results') {
                    $total = [int] $doc.'test-results'.total
                    $failed = [int] $doc.'test-results'.failures + [int] $doc.'test-results'.errors
                }
            }
        }
        else {
            # The session's loaded modules run the tests: fast, but not a clean session; the root is restored after.
            # [comment:4](/docs/references/automation/catzc-base-qualitygates/Test-InIsolation.ps1.md#comment4)
            $savedRoot = $env:RepositoryRoot
            try {
                $env:RepositoryRoot = $sandbox
                $config = New-PesterConfiguration
                $config.Run.Path = $testPaths
                $config.Run.PassThru = $true
                $config.Output.Verbosity = 'Detailed'
                if ($excludeTags.Count -gt 0) {
                    $config.Filter.ExcludeTag = $excludeTags
                }
                $config.TestResult.Enabled = $true
                $config.TestResult.OutputFormat = 'NUnitXml'
                $config.TestResult.OutputPath = $resultsPath
                $result = Invoke-Pester -Configuration $config
                $total = [int] $result.TotalCount
                $failed = [int] $result.FailedCount
            }
            finally {
                $env:RepositoryRoot = $savedRoot
            }
        }

        $ret = [pscustomobject]@{
            Isolation     = $Isolation
            ModuleProfile = if ($PSCmdlet.ParameterSetName -eq 'ModuleProfile') {
                $ModuleProfile
            }
            else {
                $null
            }
            Sandbox       = $sandbox
            Modules       = $set
            Total         = $total
            Failed        = $failed
            Success       = ($failed -eq 0)
            ResultsPath   = if ($KeepSandbox) {
                $resultsPath
            }
            else {
                $null
            }
        }

        Write-Message "Test-InIsolation ($Isolation): $($ret.Total) test(s), $($ret.Failed) failed — sandbox $sandbox"

        if ($PassThru) {
            $ret
        }
        elseif ($failed -gt 0) {
            throw "Test-InIsolation failed: $failed test(s) failed (sandbox: $sandbox)."
        }
    }
    finally {
        if ($ownsSandbox -and -not $KeepSandbox -and (Test-Path $sandbox)) {
            Remove-Item $sandbox -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}
