<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-provisioning/Install-Zsh.ps1.md"
  warning: "Generated Header"
---
#>

function Install-Zsh {
    [CmdletBinding()]
    param(
        [switch] $Force
    )

    if ($IsLinux) {
        Install-Tool -Tool zsh -Force:$Force
        Assert-Tool zsh
        return
    }

    if (-not $IsWindows) {
        Assert-Tool zsh
        Write-Message 'zsh is provided by the system — nothing to install'
        return
    }

    $config = Get-ToolConfig -Tool zsh
    $layout = Get-ZshInstallLayout
    Assert-PathExist $layout.Runtime -PathType Leaf -ErrorText (
        "Install-Zsh installs zsh into the Git for Windows that Install-Git provides at '$($layout.GitHome)', and it is " +
        'not there. Run Install-Git first.'
    )
    Assert-NotNullOrWhitespace $config.msys2_url -ErrorText 'tools.yml declares no msys2_url for zsh.'
    Assert-NotNullOrWhitespace $config.msys2_sha256 -ErrorText 'tools.yml declares no msys2_sha256 for zsh.'
    $package = [System.IO.Path]::GetFileName(([uri] $config.msys2_url).AbsolutePath)

    $installed = if ([System.IO.File]::Exists($layout.Manifest)) {
        ([System.IO.File]::ReadAllText($layout.Manifest) | ConvertFrom-Json).Package
    }
    else {
        $null
    }

    if ([System.IO.File]::Exists($layout.Executable) -and -not $Force) {
        if ($installed -eq $package) {
            Write-Message "zsh ($package) is already installed at '$($layout.Executable)'"
            return
        }
        throw "zsh at '$($layout.Executable)' is not the pinned package '$package' (installed: $($installed ?? 'not by Install-Zsh')). Run Install-Zsh -Force to replace it."
    }

    if ($installed) {
        Write-Verbose "Removing the installed zsh ($installed) before installing $package"
        Uninstall-Zsh
    }
    Assert-False ([System.IO.File]::Exists($layout.Executable)) -ErrorText (
        "zsh at '$($layout.Executable)' was not installed by Install-Zsh (no manifest), so Install-Zsh will not overwrite " +
        'it. Remove it, then run Install-Zsh again.'
    )

    $tar = Join-Path $env:SystemRoot 'System32\tar.exe'
    Assert-PathExist $tar -PathType Leaf -ErrorText "Install-Zsh extracts the zstd package with Windows' own tar, which is not at '$tar'."

    $work = Join-Path ([System.IO.Path]::GetTempPath()) "catzc-zsh-$([guid]::NewGuid().ToString('N'))"
    $staging = Join-Path $work 'package'
    [void][System.IO.Directory]::CreateDirectory($staging)
    try {
        $null = Save-VerifiedDownload -Uri $config.msys2_url -OutFile (Join-Path $work $package) -Sha256 $config.msys2_sha256
        # Relative names from the work folder, so the command line carries no drive-letter path.
        Invoke-Executable "`"$tar`" -xf `"$package`" -C package" -WorkingDirectory $work -Silent

        foreach ($metadata in [System.IO.Directory]::GetFiles($staging)) {
            [System.IO.File]::Delete($metadata)
        }
        Assert-PathExist (Join-Path $staging 'usr\bin\zsh.exe') -PathType Leaf -ErrorText "Package '$package' holds no usr/bin/zsh.exe."

        $plan = Get-PackageTreePlan -Source $staging -Destination $layout.GitHome
        foreach ($kept in $plan.Kept) {
            Write-Verbose "Keeping '$kept': Git's tree already has it"
        }

        # The manifest is written before the copy, so an interrupted copy is still covered by Uninstall-Zsh.
        $manifestFolder = [System.IO.Path]::GetDirectoryName($layout.Manifest)
        $directories = [System.Collections.Generic.List[string]]::new([string[]] $plan.Directories)
        if (-not [System.IO.Directory]::Exists($manifestFolder)) {
            [void][System.IO.Directory]::CreateDirectory($manifestFolder)
            $directories.Add([System.IO.Path]::GetRelativePath($layout.GitHome, $manifestFolder).Replace('\', '/'))
        }
        $manifest = [ordered]@{
            Package     = $package
            Files       = [string[]] $plan.Files
            Directories = $directories.ToArray()
        }
        [System.IO.File]::WriteAllText($layout.Manifest, ($manifest | ConvertTo-Json -Depth 3))

        Write-Message "Installing zsh ($package) into '$($layout.GitHome)'"
        foreach ($directory in $plan.Directories) {
            [void][System.IO.Directory]::CreateDirectory((Join-Path $layout.GitHome $directory))
        }
        foreach ($file in $plan.Files) {
            [System.IO.File]::Copy((Join-Path $staging $file), (Join-Path $layout.GitHome $file))
        }
    }
    finally {
        Remove-Item -LiteralPath $work -Recurse -Force -ErrorAction Ignore
    }

    Assert-PathExist $layout.Executable -PathType Leaf
    Write-Message "zsh ($package) installed at '$($layout.Executable)'"
}
