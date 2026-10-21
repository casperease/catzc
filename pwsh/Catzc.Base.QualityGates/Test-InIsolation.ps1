<#
---
catzc:
  immutable:
    with_body_sha: "6e719409c781"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Test-InIsolation.Tests.ps1
    docs: "[Test-InIsolation.ps1.md](docs/references/pwsh/catzc-base-qualitygates/Test-InIsolation.ps1.md)"
---
#>

function Test-InIsolation {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-NoEnvRepositoryRoot', '', Justification = 'The InProcess mode swaps $env:RepositoryRoot for the sandbox and restores it: the variable itself is the subject, so it saves the hand-off value, not the root through the accessor')]
    [CmdletBinding(DefaultParameterSetName = 'ModuleProfile')]
    [OutputType([Catzc.Base.Reports.IsolationRunResult])]
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
        Copy-CatzcModule -ModuleNames $set -Destination $sandbox -EmptyDestination | Out-Null

        # 4) The sandbox test folders (named modules only — never .vendor/.compiled).
        $testPaths = foreach ($module in $set) {
            if ($module -in '.vendor', '.compiled') {
                continue
            }
            $candidate = Join-Path $sandbox "$(Get-CatzcModulesFolder)/$module/tests"
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
Import-Module '$sandbox/$(Get-CatzcModulesFolder)/.vendor/Pester' -Force
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

        $profileName = if ($PSCmdlet.ParameterSetName -eq 'ModuleProfile') {
            $ModuleProfile
        }
        else {
            $null
        }
        $keptResults = if ($KeepSandbox) {
            $resultsPath
        }
        else {
            $null
        }
        $ret = [Catzc.Base.Reports.IsolationRunResult]::new($Isolation, $sandbox, [string[]] @($set), $total, $failed, $profileName, $keptResults)

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
