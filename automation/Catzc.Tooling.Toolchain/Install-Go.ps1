<#
.SYNOPSIS
    Installs the Go toolchain from the official go.dev archive into a user-space home.
.DESCRIPTION
    A Go at the locked version found elsewhere, such as a pipeline tool cache, satisfies the contract and is left alone.
    [comment:1](/docs/references/automation/catzc-tooling-toolchain/Install-Go.ps1.md#comment1)
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
        # A wrong version elsewhere does not block the install, because the managed home goes first on PATH.
        # [comment:2](/docs/references/automation/catzc-tooling-toolchain/Install-Go.ps1.md#comment2)
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

        # Staging beside the home, on the same volume, means a failed download never leaves a half-written home.
        # [comment:3](/docs/references/automation/catzc-tooling-toolchain/Install-Go.ps1.md#comment3)
        $staging = "$installDir.staging"
        if (Test-Path -LiteralPath $staging) {
            Remove-Item -LiteralPath $staging -Recurse -Force
        }
        New-Item -Path $staging -ItemType Directory -Force | Out-Null
        $archive = Join-Path $staging $release.filename
        Save-VerifiedDownload -Uri "https://go.dev/dl/$($release.filename)" -OutFile $archive -Sha256 $release.sha256 | Out-Null

        Write-Message "Extracting $($release.version) to '$installDir'"
        # Zip is extracted in-process because Git's GNU tar, often first on PATH, reads no zip and takes C: for a host.
        # [comment:4](/docs/references/automation/catzc-tooling-toolchain/Install-Go.ps1.md#comment4)
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
