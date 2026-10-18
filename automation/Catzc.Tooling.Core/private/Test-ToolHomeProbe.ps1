<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Core/private/Test-ToolHomeProbe.ps1
    folder: private
    name: test-tool-home-probe
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Tooling.Core/tests/Test-ToolHomeProbe.Tests.ps1
---
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
