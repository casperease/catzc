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
  config:
    synopsis: Tests whether a tool's install home satisfies one session_host_probes entry at the locked version.
    description: |-
      A probe is a home-relative path whose last segment is `{version}` (validated by ToolConfig). The home
      satisfies it when the probe's parent folder holds a directory named exactly the version, or starting with
      "<version>." — so `sdk/{version}` at version 10.0 matches sdk/10.0.201 but not sdk/10.01 or sdk/6.0.428.
      A pure filesystem check: no process is started, so it is safe on the importer's hot path.
    parameters:
      ToolHome: The install home to probe (the directory holding the tool's executable).
      Probe: One session_host_probes entry, for example 'sdk/{version}'.
      Version: The tool's locked version (ToolConfig.version).
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
