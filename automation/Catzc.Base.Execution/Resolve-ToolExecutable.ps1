<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1
    kind: public-function
    module: Catzc.Base.Execution
    visibility: public
    adrs:
      - ADR-CONF-LOADING#6
  config:
    synopsis: Locates a managed tool's executable from its tools.yml entry and returns the probe record.
    description: |-
      The one reading of a tools.yml entry for the existence check, so a caller runs the managed executable by its
      path and never by a bare name (`& (Resolve-ToolExecutable -Tool widget).Path`). Test-Tool -PassThru and
      Assert-Tool return and read the same record.

      Reads the entry through Get-Config -Config tools, as a dictionary (reading a config is global access, never
      guarded by module dependencies:[ADR-CONF-LOADING#6](/docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading6)),
      and hands Find-Executable plain inputs:

      - the candidates for this platform and run environment (Get-RunEnvironment): windows_probes or unix_probes
        on a devbox, windows_pipeline_probes or unix_pipeline_probes in a pipeline;
      - probe_excludes, never counted as the tool (for bash, the WSL launcher);
      - the command for the PATH lookup, and the version_command's arguments (its executable token dropped, so the
        version comes from the located file) with version_pattern;
      - version as the required prefix and, outside a pipeline, devbox_version as a further accepted one.
    parameters:
      Tool: The snake_case tool key as defined in tools.yml.
    outputs: '[Catzc.Base.Execution.ExecutableProbe]'
    examples:
      - (Resolve-ToolExecutable -Tool bash).Path
      - Resolve-ToolExecutable -Tool go | Select-Object Found, Version, VersionOk
---
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
