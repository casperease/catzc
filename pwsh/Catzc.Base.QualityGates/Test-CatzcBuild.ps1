<#
---
catzc:
  immutable:
    with_body_sha: f81bacbe0d66
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Tests.ps1
    docs: "[Test-CatzcBuild.ps1.md](docs/references/pwsh/catzc-base-quality-gates/Test-CatzcBuild.ps1.md)"
    cites:
      - ADR-AUTO-TEST-SAMETESTSBOTHRUNS
      - ADR-AUTO-TEST-SOURCEONLYTAG
      - ADR-AUTO-TEST-SYSTEMTESTSATLTHREE
      - DDR-RUNMODE-SAMETESTSBOTHMODES
---
#>

function Test-CatzcBuild {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.TestRunResult])]
    [Catzc.Base.Timeouts.TimeLimit(360, Pipeline = 3600)]
    param(
        [ArgumentCompleter({ (Get-CatzcModule -EngineTrack).name })]
        [string[]] $Module = @(),

        [string] $ModuleProfile,

        [ValidateSet(0, 1, 2, 3, 4)]
        [int] $MinLevel = 0,

        [ValidateSet(0, 1, 2, 3, 4)]
        [Alias('Level')]
        [int] $MaxLevel = 3,

        [ValidateSet('Logic', 'Integrity', 'Both')]
        [string] $Category = 'Both',

        [ValidateRange(0, 64)]
        [int] $Workers = 0,

        [ValidateSet('Minimal', 'Normal', 'Detailed', 'Diagnostic')]
        [string] $Output = 'Detailed',

        [switch] $PassThru
    )

    Assert-SourceTree

    if ($MinLevel -gt $MaxLevel) {
        throw "MinLevel ($MinLevel) cannot exceed MaxLevel ($MaxLevel)."
    }

    $selection = @{}
    if ($Module.Count -gt 0) {
        $selection['Module'] = $Module
    }
    if ($ModuleProfile) {
        $selection['ModuleProfile'] = $ModuleProfile
    }

    # The modules under test: the selection's closure, resolved without writing anything (-DryRun).
    $plan = Build-Modules @selection -VendorPolicy full -DryRun -Silent
    $testedModules = @($plan.Modules)
    if ($testedModules.Count -eq 0) {
        throw 'Build-Modules resolved the selection to no modules — nothing to build or test.'
    }

    $harnessModule = $MyInvocation.MyCommand.Module.Name
    $buildSelection = $selection
    if ($harnessModule -notin $testedModules) {
        $buildSelection = @{ Module = @($testedModules) + @($harnessModule) }
    }

    $destination = Join-Path ([System.IO.Path]::GetTempPath()) ('catzc-build-run-' + [guid]::NewGuid().ToString('N'))
    Write-Message "Building $($testedModules.Count) module(s) for the build run into '$destination'..."
    try {
        $build = Build-Modules @buildSelection -VendorPolicy full -Destination $destination -Silent
        $entryScript = Join-Path $build.BuildRoot 'Import-Catzc.ps1'
        Assert-PathExist $entryScript -PathType Leaf
        Write-Message "Built Catzc $($build.Version) ($(@($build.Modules).Count) module(s)) at '$($build.BuildRoot)'"

        $summary = Invoke-TestRun -EntryPoint 'Test-CatzcBuild' -Title 'Catzc Build Run' `
            -MinLevel $MinLevel -MaxLevel $MaxLevel -Modules $testedModules -Category $Category -Workers $Workers `
            -Output $Output -PassThru:$PassThru -OptOutTag 'source-only' -TimeoutSeconds (Get-TimeoutSeconds -Command 'Test-CatzcBuild') `
            -EntryScript $entryScript -EntryParameter @{ RepositoryRoot = (Get-RepositoryRoot) }

        if ($PassThru) {
            $summary | Add-Member -NotePropertyName Build -NotePropertyValue $build -PassThru
        }
    }
    finally {
        # The build is a disposable test fixture: the workers have exited, so nothing holds its files.
        if ([System.IO.Directory]::Exists($destination)) {
            try {
                [System.IO.Directory]::Delete($destination, $true)
            }
            catch {
                Write-Message "Could not remove the build run's build '$destination': $($_.Exception.Message)" -ForegroundColor Yellow
            }
        }
    }
}
