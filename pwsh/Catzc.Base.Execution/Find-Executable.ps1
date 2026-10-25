<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-execution/Find-Executable.ps1.md"
  header: "generated"
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
