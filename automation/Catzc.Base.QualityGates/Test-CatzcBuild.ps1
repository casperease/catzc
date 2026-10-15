# catzc:
#   path: automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1
#   module: Catzc.Base.QualityGates
#   visibility: public

<#
.SYNOPSIS
    Runs a build run: the same tests as Test-Automation, against a fresh build of the selected modules.
.DESCRIPTION
    The one seam: workers import the build, not the repository, so tests run against the built modules.
    [ADR-AUTO-TEST#30](/docs/adr/automation/test-automation.md#rule-adr-auto-test30),
    [ADR-AUTO-TEST#31](/docs/adr/automation/test-automation.md#rule-adr-auto-test31),
    [ADR-DSGN-RUNMODE#6](/docs/adr/design/run-modes.md#rule-adr-dsgn-runmode6)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Test-CatzcBuild.ps1.md#comment1)
.PARAMETER Module
    Giving neither -Module nor -ModuleProfile selects the default bundle's profile.
    [comment:2](/docs/references/automation/catzc-base-qualitygates/Test-CatzcBuild.ps1.md#comment2)
.PARAMETER ModuleProfile
    A module profile (profiles.yml) to build and test.
.PARAMETER MinLevel
    Minimum test tier. Defaults to 0.
.PARAMETER MaxLevel
    A snapshot run skips L3 and says so; 4 adds the opt-in L4 tier.
    [ADR-AUTO-TEST#33](/docs/adr/automation/test-automation.md#rule-adr-auto-test33)
    [comment:3](/docs/references/automation/catzc-base-qualitygates/Test-CatzcBuild.ps1.md#comment3)
.PARAMETER Category
    Logic, Integrity, or Both (the default) — as in Test-Automation.
.PARAMETER Workers
    Worker pool size; 0 (the default) sizes it automatically — as in Test-Automation.
.PARAMETER Output
    Pester output verbosity inside each worker. Defaults to 'Detailed'.
.PARAMETER PassThru
    ExcludedTests lists the source-only rows that were left out, and Build holds the Build-Modules result.
    [comment:4](/docs/references/automation/catzc-base-qualitygates/Test-CatzcBuild.ps1.md#comment4)
.EXAMPLE
    Test-CatzcBuild
.EXAMPLE
    Test-CatzcBuild -Module Catzc.Base.Config -Level 1
.EXAMPLE
    Test-CatzcBuild -ModuleProfile base -Category Logic -PassThru
#>
function Test-CatzcBuild {
    [CmdletBinding()]
    [Catzc.Base.Timeouts.TimeLimit(360, Pipeline = 3600)]
    param(
        [ArgumentCompleter({ Get-AutomationModules })]
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

    # Workers reach the harness module's scope, so it is built even when its own tests are not selected.
    # [comment:5](/docs/references/automation/catzc-base-qualitygates/Test-CatzcBuild.ps1.md#comment5)
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
