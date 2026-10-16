<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/Test-InIsolation.ps1
    name: test-in-isolation
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-qualitygates/Test-InIsolation.ps1.md
    test: automation/Catzc.Base.QualityGates/tests/Test-InIsolation.Tests.ps1
  config:
    synopsis: |-
      Copies a module profile into a tmp sandbox and runs its tests in isolation — a clean child pwsh (true
      isolation) or the current session (fast) — so a subset of the toolset is verified deterministically.
    description: |-
      Front half (both modes): resolve the module set with Get-ModuleProfile (a named profile from
      configs/profiles.yml, or an explicit -Modules seed → dependency closure + infrastructure), then
      Copy-Automation it into a fresh sandbox (-EmptyDestination). Back half depends on -Isolation:

        Process   (default, TRUE isolation) — run Pester in a child `pwsh -NoProfile`:
                  `. <sandbox>/importer.ps1 -SkipJanitors` (the optimized initializer — janitors skipped, the
                  committed .compiled reused) then Invoke-Pester over the sandbox's tests. A clean session, so
                  Get-BaseModule -Kind residue inside it is empty by construction. Launched via Invoke-Executable.

        InProcess (fast) — point $env:RepositoryRoot at the sandbox and Invoke-Pester the sandbox's test files in
                  THIS session, using the already-loaded modules (no re-import, no process spin-up). The dev
                  session's loaded code is what runs (residue), and $env:RepositoryRoot is restored afterwards.

      Integrity tests bind to the whole real repo and are meaningless in a subset sandbox, so -Category defaults
      to Logic (hermetic). Tiers default to L0+L1 (the unit tiers). Excluded tags are computed by Get-TestExcludeTag.
    parameters:
      ModuleProfile: 'A profile from configs/profiles.yml (minimal, base, azure, tooling, full). Default: minimal.'
      Modules: An explicit seed list instead of a named profile — resolved through the same closure logic.
      Isolation: Process (child pwsh, true isolation — default) or InProcess (current session, fast).
      Category: Logic (default), Integrity, or Both. Integrity assumes the full real repo — use only with the full profile.
      MaxLevel: Highest tier to run (0-4). Default 1 (L0+L1 — the hermetic unit tiers). Alias -Level.
      MinLevel: Lowest tier to run (0-4). Default 0.
      Destination: |-
        Sandbox directory. Default: a fresh tmp dir (removed after, unless -KeepSandbox). A given -Destination is
        never auto-removed.
      KeepSandbox: Keep the sandbox (and its results.xml) after the run instead of deleting it.
      PassThru: Return the run summary object instead of throwing on failure.
    outputs: '[pscustomobject] with Isolation, Sandbox, Modules, Total, Failed, Success, ResultsPath (under -PassThru).'
    examples:
      - Test-InIsolation -ModuleProfile azure
      - Test-InIsolation -Modules Catzc.Base.Config -Isolation InProcess -PassThru
---
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
