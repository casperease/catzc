function Export-GoModule {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Module,

        [Parameter(Mandatory)]
        [string] $Destination,

        [ValidatePattern('^[a-z0-9]+/[a-z0-9]+$', Options = 'None')]
        [string[]] $Platform,

        [switch] $Silent
    )

    $repositoryRoot = Get-RepositoryRoot
    $moduleRelative = if ([System.IO.Path]::IsPathRooted($Module)) {
        [System.IO.Path]::GetRelativePath($repositoryRoot, $Module)
    }
    else {
        $Module
    }
    $moduleRelative = $moduleRelative.Replace('\', '/').TrimEnd('/')
    $moduleFolder = [System.IO.Path]::Combine($repositoryRoot, $moduleRelative)
    $name = $moduleRelative.Substring($moduleRelative.LastIndexOf('/') + 1)

    # Without a list from the builder, the host's own platform is the one target.
    $targets = if ($Platform) {
        $Platform
    }
    else {
        Get-HostPlatform
    }
    $targets = @($targets)

    # The managed go by its path, never a bare go off PATH (ADR-AUTO-GO-MANAGEDTOOLCHAIN).
    $go = Resolve-ToolExecutable -Tool go
    if (-not $go.Found) {
        throw 'go is not installed (no managed go found). Run Install-Go.'
    }
    if (-not $go.VersionOk) {
        throw "go at $($go.Path) reports version '$($go.Version)', but tools.yml pins '$($go.Required)'. Run Install-Go."
    }
    $goCommand = "`"$($go.Path)`""

    # A vendored module builds from its vendor/ folder; any other resolves from the local cache with the proxy off, so no feed is contacted.
    $hasVendor = [System.IO.Directory]::Exists([System.IO.Path]::Combine($moduleFolder, 'vendor'))
    $modFlag = if ($hasVendor) {
        '-mod=vendor'
    }
    else {
        '-mod=mod'
    }

    $null = [System.IO.Directory]::CreateDirectory($Destination)
    $records = [System.Collections.Generic.List[object]]::new()
    foreach ($target in $targets) {
        $os, $arch = $target.Split('/')
        $leaf = if ($os -ceq 'windows') {
            "$name.exe"
        }
        else {
            $name
        }
        $relative = "$os-$arch/$leaf"
        $output = [System.IO.Path]::Combine($Destination, "$os-$arch", $leaf)
        $null = [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($output))

        # The go environment with the proxy off: a build compiles from the cache and never fetches.
        $environment = Get-GoEnvironment -Offline
        $environment['GOOS'] = $os
        $environment['GOARCH'] = $arch
        $environment['CGO_ENABLED'] = '0'
        $environment['GOFLAGS'] = $modFlag
        $environment['GOTOOLCHAIN'] = 'local'
        $environment['GOWORK'] = 'off'
        $saved = @{}
        foreach ($variable in $environment.Keys) {
            $saved[$variable] = [System.Environment]::GetEnvironmentVariable($variable)
            [System.Environment]::SetEnvironmentVariable($variable, $environment[$variable])
        }
        try {
            $build = Invoke-Executable "$goCommand build -trimpath -ldflags `"-s -w -buildid=`" -o `"$output`" ." -WorkingDirectory $moduleFolder -PassThru -NoAssert -Silent:$Silent
        }
        finally {
            foreach ($variable in $environment.Keys) {
                if ($null -eq $saved[$variable]) {
                    Remove-Item -LiteralPath "Env:$variable" -ErrorAction Ignore
                }
                else {
                    [System.Environment]::SetEnvironmentVariable($variable, $saved[$variable])
                }
            }
        }
        if ($build.ExitCode -ne 0) {
            throw "go build failed for $target in $moduleRelative/ (exit $($build.ExitCode)):`n$($build.Full)"
        }
        $hash = [System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([System.IO.File]::ReadAllBytes($output))).ToLowerInvariant()
        $records.Add([pscustomobject]@{ path = $relative; sha256 = $hash })
    }

    # Sorted ordinally, so a rebuild compares byte for byte (ADR-AUTO-BUNDLE-IMMUTABLEBUILD).
    $sorted = @($records | Sort-Object -Property { $_.path } -CaseSensitive)
    $lines = foreach ($record in $sorted) {
        '  ' + (ConvertTo-Json -InputObject ([ordered]@{ path = $record.path; sha256 = $record.sha256 }) -Compress)
    }
    $manifest = "[`n" + ($lines -join ",`n") + "`n]`n"
    [System.IO.File]::WriteAllText([System.IO.Path]::Combine($Destination, 'binaries.json'), $manifest,
        [System.Text.UTF8Encoding]::new($false))

    if (-not $Silent) {
        Write-Message "Packaged go module $moduleRelative -> $Destination ($($sorted.Count) binaries)"
    }
    [pscustomobject]@{
        Module      = $moduleRelative
        Destination = $Destination
        Platforms   = $targets.Count
        Binaries    = @($sorted | ForEach-Object { $_.path })
    }
}
