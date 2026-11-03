function Export-PythonModule {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Module,

        [Parameter(Mandatory)]
        [string] $Destination,

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

    $files = [System.Collections.Generic.List[string]]::new()
    $files.AddRange([string[]]@(Get-ModuleShippedFile $moduleRelative))
    $files.Sort([System.StringComparer]::Ordinal)
    $moduleFolder = [System.IO.Path]::Combine($repositoryRoot, $moduleRelative)
    $null = [System.IO.Directory]::CreateDirectory($Destination)
    foreach ($file in $files) {
        $target = [System.IO.Path]::Combine($Destination, $file)
        $null = [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($target))
        [System.IO.File]::Copy([System.IO.Path]::Combine($moduleFolder, $file), $target, $true)
    }

    $wheelCount = 0
    if ($files.Contains('uv.lock')) {
        # The managed uv by its path; never a bare uv off PATH.
        $uv = Resolve-ToolExecutable -Tool uv
        if (-not $uv.Found) {
            throw "Export-PythonModule: uv is not installed (no managed uv found), and '$moduleRelative' holds a uv.lock. Run Install-Uv."
        }
        if (-not $uv.VersionOk) {
            throw "Export-PythonModule: uv at $($uv.Path) reports version '$($uv.Version)', but tools.yml pins '$($uv.Required)'. Run Install-Uv."
        }
        $uvCommand = "`"$($uv.Path)`""
        $wheelFolder = [System.IO.Path]::Combine($Destination, 'wheels')
        if ([System.IO.Directory]::Exists($wheelFolder)) {
            [System.IO.Directory]::Delete($wheelFolder, $true)
        }
        $null = [System.IO.Directory]::CreateDirectory($wheelFolder)
        $requirements = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "catzc-wheels-$([guid]::NewGuid().ToString('N')).txt")

        $saved = [System.Environment]::GetEnvironmentVariable('UV_OFFLINE')
        [System.Environment]::SetEnvironmentVariable('UV_OFFLINE', '1')
        try {
            $export = Invoke-Executable ("$uvCommand export --frozen --offline --no-hashes --no-emit-project --no-header --no-annotate " +
                "--project `"$moduleFolder`" --output-file `"$requirements`"") -WorkingDirectory $moduleFolder -PassThru -NoAssert
            if ($export.ExitCode -ne 0) {
                throw "Export-PythonModule: uv export failed for '$moduleRelative' (exit $($export.ExitCode)):`n$($export.Full)"
            }
            $cache = Invoke-Executable "$uvCommand cache dir" -WorkingDirectory $moduleFolder -PassThru -NoAssert
            $cacheFolder = "$($cache.Output)".Trim()
            $download = Invoke-Executable ("$uvCommand run --offline --no-sync --project `"$moduleFolder`" python -m pip download --no-index " +
                "--no-deps --find-links `"$cacheFolder`" --requirement `"$requirements`" --dest `"$wheelFolder`"") -WorkingDirectory $moduleFolder -PassThru -NoAssert
            if ($download.ExitCode -ne 0) {
                throw ("Export-PythonModule: a locked wheel of '$moduleRelative' is not in the managed cache (exit $($download.ExitCode)); " +
                    "warm the cache once with: Install-PythonWorkspace`n$($download.Full)")
            }
        }
        finally {
            if ($null -eq $saved) {
                Remove-Item -LiteralPath 'Env:UV_OFFLINE' -ErrorAction Ignore
            }
            else {
                [System.Environment]::SetEnvironmentVariable('UV_OFFLINE', $saved)
            }
            Remove-Item -LiteralPath $requirements -Force -ErrorAction Ignore
        }

        $wheels = [System.Collections.Generic.List[string]]::new()
        foreach ($wheel in @(Get-ChildPath $wheelFolder -File -Filter '*.whl' -Depth 1 -Exclude @() -PruneVendor $false)) {
            $wheels.Add([System.IO.Path]::GetFileName($wheel))
        }
        $wheels.Sort([System.StringComparer]::Ordinal)
        $lines = foreach ($wheel in $wheels) {
            $bytes = [System.IO.File]::ReadAllBytes([System.IO.Path]::Combine($wheelFolder, $wheel))
            $hash = [System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData($bytes)).ToLowerInvariant()
            '  ' + (ConvertTo-Json -InputObject ([ordered]@{ name = $wheel; sha256 = $hash }) -Compress)
        }
        $manifest = if ($wheels.Count) {
            "[`n" + ($lines -join ",`n") + "`n]`n"
        }
        else {
            "[]`n"
        }
        [System.IO.File]::WriteAllText([System.IO.Path]::Combine($Destination, 'wheels.json'), $manifest,
            [System.Text.UTF8Encoding]::new($false))
        $wheelCount = $wheels.Count
    }

    if (-not $Silent) {
        Write-Message "Packaged python module $moduleRelative -> $Destination ($($files.Count) files, $wheelCount wheels)"
    }
    [pscustomobject]@{
        Module      = $moduleRelative
        Destination = $Destination
        Files       = $files.Count
        Wheels      = $wheelCount
    }
}
