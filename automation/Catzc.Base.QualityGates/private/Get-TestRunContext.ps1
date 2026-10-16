<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-TestRunContext.ps1
    folder: private
    name: get-test-run-context
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Get-TestRunContext.Tests.ps1
  config:
    synopsis: 'Collects the facts that say what a test run is and where it runs: its context block.'
    description: |-
      One record of the run's context, for the console block under the banner (Write-TestRunContext) and for
      run.json, so a reader of either knows what ran without inferring it:

      - entryPoint, run (source | build), and codeRoot — the modules the workers load (the build's own automation/
        folder for a build run, Get-CatzcModulesRoot otherwise);
      - location (in-place | snapshot, the location's Mode) and locationReason — who held the working folder, or
        -Isolated;
      - tiersRequested, tiersRunning, and tierCap — why the top tier is lower than asked (Resolve-TestRunMaxLevel);
      - actor — Pipeline, Agent, or Person (Get-SessionActor);
      - tools — whether git, az, and dotnet are on the PATH (found with Get-Command; no process is started);
      - selection — all tests, a test suite, the modules, the category, and the -Rule filter.
    parameters:
      EntryPoint: The entry point's command name.
      EntryScript: The script the workers dot-source; empty is the source importer.
      Location: The location Enter-TestRunLocation returned.
      MinLevel: The run's lowest tier.
      RequestedMaxLevel: The highest tier the caller asked for.
      MaxLevel: The highest tier the run executes (after Resolve-TestRunMaxLevel).
      Category: The category filter.
      Modules: The modules in scope; empty is every module.
      Suite: A test suite's name, when the modules were resolved from one; otherwise empty.
      Rule: The -Rule filter.
    outputs: '[System.Collections.Specialized.OrderedDictionary] the context, keyed as run.json records it.'
    examples:
      - Get-TestRunContext -EntryPoint Test-Automation -Location $location -RequestedMaxLevel 3 -MaxLevel 2
---
#>

function Get-TestRunContext {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [string] $EntryPoint,

        [string] $EntryScript,

        [Parameter(Mandatory)]
        [pscustomobject] $Location,

        [int] $MinLevel = 0,

        [int] $RequestedMaxLevel = 3,

        [int] $MaxLevel = 3,

        [string] $Category = 'Both',

        [AllowEmptyCollection()]
        [string[]] $Modules = @(),

        [string] $Suite,

        [AllowEmptyCollection()]
        [string[]] $Rule = @()
    )

    $codeRoot = if ($EntryScript) {
        Join-Path ([System.IO.Path]::GetDirectoryName($EntryScript)) 'automation'
    }
    else {
        Get-CatzcModulesRoot
    }

    $locationReason = if ($Location.Mode -ne 'snapshot') {
        ''
    }
    elseif ($Location.Holder) {
        "working folder held by $($Location.Holder.Description)"
    }
    else {
        '-Isolated'
    }

    $tierCap = if ($MaxLevel -ge $RequestedMaxLevel) {
        ''
    }
    elseif ($Location.Mode -eq 'snapshot') {
        'L3 skipped: snapshot location'
    }
    elseif ($Location.SystemTestHolder) {
        "L3 skipped: system-test lock held by $($Location.SystemTestHolder.Description)"
    }
    else {
        'L3 skipped: system-test lock held by another test run'
    }

    $tools = [ordered]@{}
    foreach ($tool in 'git', 'az', 'dotnet') {
        $tools[$tool] = [bool] (Get-Command $tool -CommandType Application -ErrorAction Ignore)
    }

    $selection = [System.Collections.Generic.List[string]]::new()
    if ($Suite) {
        $selection.Add("suite $Suite")
    }
    if ($Modules.Count -gt 0) {
        $selection.Add("modules: $($Modules -join ', ')")
    }
    if ($Category -ne 'Both') {
        $selection.Add("category $Category")
    }
    if ($Rule.Count -gt 0) {
        $selection.Add("rules: $($Rule -join ', ')")
    }
    if ($selection.Count -eq 0) {
        $selection.Add('all tests')
    }

    [ordered]@{
        entryPoint     = $EntryPoint
        run            = if ($EntryScript) {
            'build'
        }
        else {
            'source'
        }
        codeRoot       = $codeRoot
        location       = $Location.Mode
        locationReason = $locationReason
        tiersRequested = Format-TierRange -MinLevel $MinLevel -MaxLevel $RequestedMaxLevel
        tiersRunning   = Format-TierRange -MinLevel $MinLevel -MaxLevel $MaxLevel
        tierCap        = $tierCap
        actor          = Get-SessionActor
        tools          = $tools
        selection      = $selection -join '; '
    }
}
