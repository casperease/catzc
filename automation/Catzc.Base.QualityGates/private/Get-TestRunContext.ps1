<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-TestRunContext.ps1
    kind: private-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Collects the facts that say what a test run is and where it runs: its context block.
.DESCRIPTION
    Console block and run.json share this one record, so a reader of either sees what ran without inferring it.
.PARAMETER EntryPoint
    The entry point's command name.
.PARAMETER EntryScript
    The script the workers dot-source; empty is the source importer.
.PARAMETER Location
    The location Enter-TestRunLocation returned.
.PARAMETER MinLevel
    The run's lowest tier.
.PARAMETER RequestedMaxLevel
    The highest tier the caller asked for.
.PARAMETER MaxLevel
    The highest tier the run executes (after Resolve-TestRunMaxLevel).
.PARAMETER Category
    The category filter.
.PARAMETER Modules
    The modules in scope; empty is every module.
.PARAMETER Suite
    A test suite's name, when the modules were resolved from one; otherwise empty.
.PARAMETER Rule
    The -Rule filter.
.OUTPUTS
    [System.Collections.Specialized.OrderedDictionary] the context, keyed as run.json records it.
.EXAMPLE
    Get-TestRunContext -EntryPoint Test-Automation -Location $location -RequestedMaxLevel 3 -MaxLevel 2
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
