<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Core/private/Test-ToolHomeProbe.ps1
    folder: private
    name: test-tool-home-probe
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Tooling.Core/tests/Test-ToolHomeProbe.Tests.ps1
    docs: "[Test-ToolHomeProbe.ps1.md](docs/references/pwsh/catzc-tooling-core/private/Test-ToolHomeProbe.ps1.md)"
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
