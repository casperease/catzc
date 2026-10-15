<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Execution/Find-Executable.ps1
    kind: automation-function
    module: Catzc.Base.Execution
    visibility: public
    relatives:
      test: automation/Catzc.Base.Execution/tests/Find-Executable.Tests.ps1
    adrs:
      - ADR-PWSH-CACHE
  config:
    synopsis: Locates an executable without starting a process, then confirms its version once per session.
    description: |-
      The generic existence check, in two timed steps, from plain inputs:

      1. Locate, with no process start: the first of -Candidate that exists wins (Method 'probe'); else the first
         application named -Command on PATH (Method 'path'); else Method 'none'. A path in -Exclude never counts, as
         a candidate or on PATH (for bash on Windows, the WSL launcher). %VAR% environment variables in candidates
         and exclusions are expanded.
      2. Confirm: only for a located executable, run it once with -VersionArguments (Get-ExecutableVersion) and
         match its output against -VersionPattern. VersionOk is true when the version starts with -RequiredVersion
         or one of -AcceptVersion (any parsed version, when no version is required).

      The version is a lazy session cache entry keyed by the executable's path, its last write time and the
      arguments ([ADR-PWSH-CACHE](/docs/adr/pwsh/script-scope-caching.md)), so a process starts at
      most once per executable per session, while a reinstall, an upgrade or a removal is seen on the next call. The
      locate step runs on every call: it is file checks only.

      The caller chooses the candidates for its platform and run environment; Resolve-ToolExecutable does that for a
      tools.yml entry. The record carries the session actor (Get-SessionActor), for the report.
    parameters:
      Name: The name the record carries (a tools.yml key, for a tool).
      Command: The command name looked up on PATH when no candidate exists. Defaults to -Name.
      Candidate: The candidate executable paths, in order. Empty for a PATH-only lookup.
      Exclude: Executable paths that never count, as a candidate or on PATH.
      VersionArguments: The arguments that make the executable print its version (e.g. '--version').
      VersionPattern: The regex that captures the version as the named group (?<ver>...).
      RequiredVersion: The version prefix the reported version must start with. Empty accepts any parsed version.
      AcceptVersion: Further version prefixes that also satisfy the check (for a tool, the devbox_version lever outside a pipeline).
    outputs: '[Catzc.Base.Execution.ExecutableProbe]'
    examples:
      - Find-Executable -Name 'widget' -Candidate '%LOCALAPPDATA%\Widget\widget.exe' -VersionArguments '--version' -VersionPattern 'widget (?<ver>[\d.]+)' -RequiredVersion '5'
      - (Find-Executable -Name 'gadget' -VersionArguments 'version' -VersionPattern 'v(?<ver>[\d.]+)').Path
---
#>

function Find-Executable {
    [OutputType([Catzc.Base.Execution.ExecutableProbe])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Name,

        [string] $Command = $Name,

        [string[]] $Candidate = @(),

        [string[]] $Exclude = @(),

        [AllowEmptyString()]
        [string] $VersionArguments = '',

        [Parameter(Mandatory)]
        [string] $VersionPattern,

        [AllowEmptyString()]
        [string] $RequiredVersion = '',

        [string[]] $AcceptVersion = @()
    )

    $comparer = [System.StringComparer]::OrdinalIgnoreCase
    $excluded = [System.Collections.Generic.HashSet[string]]::new($comparer)
    foreach ($entry in $Exclude) {
        $excluded.Add([System.IO.Path]::GetFullPath([System.Environment]::ExpandEnvironmentVariables($entry))) | Out-Null
    }

    # 1. Locate — file checks and the PATH lookup only, timed.
    $probeWatch = [System.Diagnostics.Stopwatch]::StartNew()
    $path = $null
    $method = 'none'
    foreach ($entry in $Candidate) {
        $expanded = [System.IO.Path]::GetFullPath([System.Environment]::ExpandEnvironmentVariables($entry))
        if (-not $excluded.Contains($expanded) -and (Test-Path -LiteralPath $expanded -PathType Leaf)) {
            $path = $expanded
            $method = 'probe'
            break
        }
    }
    if (-not $path) {
        $onPath = Get-Command $Command -CommandType Application -All -ErrorAction Ignore |
            Where-Object { -not $excluded.Contains($_.Source) } |
            Select-Object -First 1
        if ($onPath) {
            $path = $onPath.Source
            $method = 'path'
        }
    }
    $probeWatch.Stop()

    # 2. Confirm — the version, from the session cache when this exact file was already run.
    $version = $null
    $versionMs = 0
    if ($path) {
        if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:executableVersionCache')) {
            $script:executableVersionCache = @{}
        }
        $key = "$path|$((Get-Item -LiteralPath $path).LastWriteTimeUtc.Ticks)|$VersionArguments"
        if ($script:executableVersionCache.ContainsKey($key)) {
            $version = $script:executableVersionCache[$key]
        }
        else {
            $versionWatch = [System.Diagnostics.Stopwatch]::StartNew()
            $version = Get-ExecutableVersion -Path $path -Arguments $VersionArguments -Pattern $VersionPattern
            $versionWatch.Stop()
            $versionMs = $versionWatch.ElapsedMilliseconds
            $script:executableVersionCache[$key] = $version
        }
    }

    $versionOk = $false
    if ($version) {
        $versionOk = -not $RequiredVersion -or $version.StartsWith($RequiredVersion)
        foreach ($accepted in $AcceptVersion) {
            if ($accepted -and $version.StartsWith($accepted)) {
                $versionOk = $true
            }
        }
    }

    [Catzc.Base.Execution.ExecutableProbe]::new($Name, $path, $method, $version, $RequiredVersion, $versionOk,
        $probeWatch.ElapsedMilliseconds, $versionMs, (Get-SessionActor))
}
