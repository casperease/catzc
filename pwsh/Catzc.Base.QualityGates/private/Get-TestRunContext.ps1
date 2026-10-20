<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-TestRunContext.ps1
    folder: private
    name: get-test-run-context
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-TestRunContext.Tests.ps1
    docs: "[Get-TestRunContext.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-TestRunContext.ps1.md)"
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
        Join-Path ([System.IO.Path]::GetDirectoryName($EntryScript)) (Get-CatzcModulesFolder)
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
