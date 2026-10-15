<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1
    kind: function
    module: Catzc.Base.Execution
    visibility: public
    adrs:
      - ADR-CONF-LOADING#6
---
#>

<#
.SYNOPSIS
    Locates a managed tool's executable from its tools.yml entry and returns the probe record.
.DESCRIPTION
    Run the tool by this path, never by a bare name that PATH could resolve to some other file.
.PARAMETER Tool
    The snake_case tool key as defined in tools.yml.
.OUTPUTS
    [Catzc.Base.Execution.ExecutableProbe]
.EXAMPLE
    (Resolve-ToolExecutable -Tool bash).Path
.EXAMPLE
    Resolve-ToolExecutable -Tool go | Select-Object Found, Version, VersionOk
#>
function Resolve-ToolExecutable {
    [OutputType([Catzc.Base.Execution.ExecutableProbe])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Tool
    )

    $entry = (Get-Config -Config tools)[$Tool]
    if ($null -eq $entry) {
        throw "Tool '$Tool' is not declared in tools.yml"
    }

    $pipeline = (Get-RunEnvironment) -eq 'Pipeline'
    $platform = if ($IsWindows) {
        'windows'
    }
    else {
        'unix'
    }
    $listKey = if ($pipeline) {
        "${platform}_pipeline_probes"
    }
    else {
        "${platform}_probes"
    }
    $accept = if ($entry['devbox_version'] -and -not $pipeline) {
        @($entry['devbox_version'])
    }
    else {
        @()
    }

    # The version command's arguments, without its executable token (e.g. 'widget --version' -> '--version').
    $versionArguments = ([string]$entry['version_command'] -split '\s+', 2 | Select-Object -Skip 1) -join ' '

    $probe = @{
        Name             = $Tool
        Command          = [string]$entry['command']
        Candidate        = [string[]]@($entry[$listKey] | Where-Object { $_ })
        Exclude          = [string[]]@($entry['probe_excludes'] | Where-Object { $_ })
        VersionArguments = $versionArguments
        VersionPattern   = [string]$entry['version_pattern']
        RequiredVersion  = [string]$entry['version']
        AcceptVersion    = [string[]]$accept
    }
    Find-Executable @probe
}
