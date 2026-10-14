<#
.SYNOPSIS
    Installs the Go toolchain from the official go.dev archive into a user-space home.
.DESCRIPTION
    Resolves the newest stable release of the locked version from the go.dev release feed (Get-GoRelease),
    downloads its archive for this platform and verifies it against the SHA-256 the feed publishes
    (Save-VerifiedDownload), and extracts it into the script-install home (Get-ScriptInstallDir: Windows
    %LOCALAPPDATA%\go, Unix ~/.go). No package manager and no admin on any platform, so Windows, Linux and macOS
    take the same path. The home's bin folder is put on the session and persistent PATH.

    Idempotent — converges to the desired state on every run: when the home already holds the locked version the
    download is skipped, but PATH is still converged, so a lost PATH entry is repaired by re-running. A Go at the
    locked version found elsewhere (a pipeline's hosted tool cache, activated by the native Go task) satisfies the
    contract and is left untouched.
.PARAMETER Version
    Go version to install. Defaults to the locked version in Get-ToolConfig.
.PARAMETER Force
    Replace an installation in the managed home at the wrong version.
.EXAMPLE
    Install-Go
.EXAMPLE
    Install-Go -Version '1.27' -Force
#>
function Install-Go {
    [CmdletBinding()]
    param(
        [string] $Version = (Get-ToolConfig -Tool 'go').version,
        [switch] $Force
    )

    $config = Get-ToolConfig -Tool 'go'
    $installDir = Get-ScriptInstallDir -Config $config
    $binDir = Join-Path $installDir 'bin'
    $ourBinary = Join-Path $binDir ($IsWindows ? 'go.exe' : 'go')

    $needsInstall = $true
    if (Test-Path -LiteralPath $ourBinary) {
        # Check the managed home's binary itself, not whatever `go` resolves to on PATH.
        $result = Invoke-Executable "`"$ourBinary`" version" -PassThru -NoAssert -Silent
        $ourInstalled = if ($result.Full -match $config.version_pattern) {
            $Matches['ver']
        }
        else {
            $null
        }

        if ($ourInstalled -and $ourInstalled.StartsWith($Version)) {
            Write-Message "Go $Version is already installed at '$installDir'"
            $needsInstall = $false
        }
        elseif (-not $Force) {
            throw "Go version mismatch: expected $Version.x, found $($ourInstalled ?? 'an unreadable version') at '$installDir'. Run Install-Go -Force to replace."
        }
    }
    else {
        # Nothing in the managed home: a Go at the right version elsewhere satisfies the contract and is not ours to
        # manage. A wrong version elsewhere does not block the install — the managed home goes first on PATH.
        $probe = Test-Tool 'go' -PassThru
        if ($probe.Version -and $probe.Version.StartsWith($Version)) {
            Write-Message "Go $Version is already installed at '$($probe.Path)'"
            return
        }
    }

    if ($needsInstall) {
        $release = Get-GoRelease -Version $Version
        $isZip = $release.filename.EndsWith('.zip', [System.StringComparison]::OrdinalIgnoreCase)
        if (-not $isZip) {
            Assert-Command tar -ErrorText 'Install-Go extracts the Go archive with tar, which is not on PATH.'
        }

        # Download and extract beside the home (same volume), then swap the extracted go/ folder in, so a failed
        # download or extraction never leaves a half-written home.
        $staging = "$installDir.staging"
        if (Test-Path -LiteralPath $staging) {
            Remove-Item -LiteralPath $staging -Recurse -Force
        }
        New-Item -Path $staging -ItemType Directory -Force | Out-Null
        $archive = Join-Path $staging $release.filename
        Save-VerifiedDownload -Uri "https://go.dev/dl/$($release.filename)" -OutFile $archive -Sha256 $release.sha256 | Out-Null

        Write-Message "Extracting $($release.version) to '$installDir'"
        # The Windows archive is a .zip, extracted in-process: the tar first on PATH there is often Git's GNU tar,
        # which reads no zip and takes a drive letter's colon for a remote host. The Unix .tar.gz goes to tar, run
        # inside the staging folder with a relative name so no path carries a colon.
        if ($isZip) {
            [System.IO.Compression.ZipFile]::ExtractToDirectory($archive, $staging)
        }
        else {
            Invoke-Executable "tar -xzf `"$($release.filename)`"" -WorkingDirectory $staging -Silent
        }
        $extracted = Join-Path $staging 'go'
        Assert-PathExist $extracted

        if (Test-Path -LiteralPath $installDir) {
            Remove-Item -LiteralPath $installDir -Recurse -Force
        }
        Move-Item -LiteralPath $extracted -Destination $installDir
        Remove-Item -LiteralPath $staging -Recurse -Force
    }

    # Converge PATH on every run that owns the install — session + persistent, both idempotent and announced.
    Add-PermanentPath $binDir -Prepend -Label 'Install-Go'

    $probe = Test-Tool 'go' -PassThru
    if (-not ($probe.Version -and $probe.Version.StartsWith($Version))) {
        throw "Go was installed to '$installDir' but the check found $($probe.Version ?? 'no version') at '$($probe.Path ?? 'no path')'. Restart your shell, then run Test-Tool go -PassThru | Write-ToolProbeReport."
    }
    if ($needsInstall) {
        Write-Message "Go $($probe.Version) installed successfully to '$installDir'"
    }
}
