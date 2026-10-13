<#
.SYNOPSIS
    Collects the facts that say what a test run is and where it runs: its context block.
.DESCRIPTION
    One record of the run's context, for the console block under the banner (Write-TestRunContext) and for
    run.json, so a reader of either knows what ran without inferring it:

    - entryPoint, run (source | build), and codeRoot — the modules the workers load (the build's own automation/
      folder for a build run, Get-CatzcModulesRoot otherwise);
    - slot (in-place | snapshot) and slotReason — who held the working folder, or -Isolated;
    - tiersRequested, tiersRunning, and tierCap — why the top tier is lower than asked (Resolve-TestRunMaxLevel);
    - actor — Pipeline, Agent, or Person (Get-SessionActor);
    - tools — whether git, az, and dotnet are on the PATH (found with Get-Command; no process is started);
    - selection — all tests, a test suite, the modules, the category, and the -Rule filter.
.PARAMETER EntryPoint
    The entry point's command name.
.PARAMETER EntryScript
    The script the workers dot-source; empty is the source importer.
.PARAMETER Slot
    The slot Enter-TestRunSlot returned.
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
    The test suite the modules were resolved from, or empty.
.PARAMETER Rule
    The -Rule filter.
.OUTPUTS
    [System.Collections.Specialized.OrderedDictionary] the context, keyed as run.json records it.
.EXAMPLE
    Get-TestRunContext -EntryPoint Test-Automation -Slot $slot -RequestedMaxLevel 3 -MaxLevel 2
#>
function Get-TestRunContext {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [string] $EntryPoint,

        [string] $EntryScript,

        [Parameter(Mandatory)]
        [pscustomobject] $Slot,

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

    $slotReason = if ($Slot.Mode -ne 'Snapshot') {
        ''
    }
    elseif ($Slot.Holder) {
        "working folder held by $($Slot.Holder.Description)"
    }
    else {
        '-Isolated'
    }

    $tierCap = if ($MaxLevel -ge $RequestedMaxLevel) {
        ''
    }
    elseif ($Slot.Mode -eq 'Snapshot') {
        'L3 skipped: snapshot slot'
    }
    elseif ($Slot.SystemTestHolder) {
        "L3 skipped: system-test lock held by $($Slot.SystemTestHolder.Description)"
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
        slot           = if ($Slot.Mode -eq 'Snapshot') {
            'snapshot'
        }
        else {
            'in-place'
        }
        slotReason     = $slotReason
        tiersRequested = Format-TierRange -MinLevel $MinLevel -MaxLevel $RequestedMaxLevel
        tiersRunning   = Format-TierRange -MinLevel $MinLevel -MaxLevel $MaxLevel
        tierCap        = $tierCap
        actor          = Get-SessionActor
        tools          = $tools
        selection      = $selection -join '; '
    }
}
