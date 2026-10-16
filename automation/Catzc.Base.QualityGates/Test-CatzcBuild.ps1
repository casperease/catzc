<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1
    kind: gate-function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/Test-CatzcBuild.ps1.md
      test: automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Tests.ps1
    adrs:
      - ADR-AUTO-TEST#{30,31,33}
      - ADR-DSGN-RUNMODE#6
  config:
    synopsis: 'Runs a build run: the same tests as Test-Automation, against a fresh build of the selected modules.'
    description: |-
      The second of the two test runs over one body of tests
      ([ADR-AUTO-TEST#30](/docs/adr/automation/test-automation.md#rule-adr-auto-test30),
      [ADR-DSGN-RUNMODE#6](/docs/adr/design/run-modes.md#rule-adr-dsgn-runmode6)). It builds the
      selected modules with Build-Modules (vendor policy 'full', so Pester and PSScriptAnalyzer ship with the build)
      into a fresh temporary destination, then runs the Test-Automation harness unchanged in shape — discovery,
      the tier/category tag checks, sharding, rows, reports — with one seam swapped: each shard worker dot-sources
      the build's Import-Catzc.ps1 -RepositoryRoot <repo> instead of the repository importer, so every test runs
      against the merged, built modules while out/ and the test fixtures keep resolving in the repository.

      Test files come from the source tree, limited to the tests/ folders of the modules the selection resolves to
      (the dependency closure Build-Modules computes). Tests tagged 'source-only'
      ([ADR-AUTO-TEST#31](/docs/adr/automation/test-automation.md#rule-adr-auto-test31)) are excluded
      and counted and listed — on the console and in excluded-tests.csv in the run directory — never silently.
      Reports go to <out>/test-catzc-build/, so the two test runs' reports never overwrite each other. The build is
      deleted when the run ends.

      The harness's own module is always built too (each worker reaches its configuration builder and row reducer
      through that module's scope), but its tests run only when the selection includes it.

      Test-CatzcBuild operates on the source tree — it builds from it and reads its tests — so it runs in source
      mode only (Assert-SourceTree).
    parameters:
      Module: |-
        Modules to build and test (combinable with -ModuleProfile; closure-expanded by Build-Modules). Neither ->
        the default bundle's profile (exporter.yml default_bundle).
      ModuleProfile: A module profile (profiles.yml) to build and test.
      MinLevel: Minimum test tier. Defaults to 0.
      MaxLevel: |-
        Maximum test tier (alias: -Level). Defaults to 3, as in Test-Automation: L0-L3 when the run owns the
        working folder, L0-L2 in a snapshot, which skips L3 and says so
        ([ADR-AUTO-TEST#33](/docs/adr/automation/test-automation.md#rule-adr-auto-test33)). 4 adds the opt-in L4 tier.
      Category: Logic, Integrity, or Both (the default) — as in Test-Automation.
      Workers: Worker pool size; 0 (the default) sizes it automatically — as in Test-Automation.
      Output: Pester output verbosity inside each worker. Defaults to 'Detailed'.
      PassThru: |-
        Returns the run summary object (as Test-Automation's, plus ExcludedTests — the 'source-only' rows — and
        Build — the Build-Modules result).
    examples:
      - Test-CatzcBuild
      - Test-CatzcBuild -Module Catzc.Base.Config -Level 1
      - Test-CatzcBuild -ModuleProfile base -Category Logic -PassThru
---
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
