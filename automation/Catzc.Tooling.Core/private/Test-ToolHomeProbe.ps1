<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/private/Test-ToolHomeProbe.ps1
    kind: function
    module: Catzc.Tooling.Core
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Tests whether a tool's install home satisfies one session_host_probes entry at the locked version.
.DESCRIPTION
    The match is a dotted prefix: version 10.0 fits sdk/10.0.201 but not sdk/10.01 or sdk/6.0.428.
    [comment:1](/docs/references/automation/catzc-tooling-core/private/Test-ToolHomeProbe.ps1.md#comment1)
.PARAMETER ToolHome
    The install home to probe (the directory holding the tool's executable).
.PARAMETER Probe
    One session_host_probes entry, for example 'sdk/{version}'.
.PARAMETER Version
    The tool's locked version (ToolConfig.version).
#>
function Test-ToolHomeProbe {
    [OutputType([bool])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $ToolHome,

        [Parameter(Mandatory)]
        [string] $Probe,

        [Parameter(Mandatory)]
        [string] $Version
    )

    $parentRelative = $Probe.Substring(0, $Probe.Length - '{version}'.Length).TrimEnd('/', '\')
    $parent = if ($parentRelative) {
        Join-Path $ToolHome $parentRelative
    }
    else {
        $ToolHome
    }
    if (-not [System.IO.Directory]::Exists($parent)) {
        return $false
    }

    foreach ($directory in [System.IO.Directory]::EnumerateDirectories($parent)) {
        $name = [System.IO.Path]::GetFileName($directory)
        if ($name -eq $Version -or $name.StartsWith("$Version.", [System.StringComparison]::Ordinal)) {
            return $true
        }
    }
    return $false
}
