<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Provisioning/Install-Zsh.ps1
    name: install-zsh
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Provisioning
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-tooling-provisioning/Install-Zsh.ps1.md
    test: automation/Catzc.Tooling.Provisioning/tests/Install-Zsh.Tests.ps1
    cites:
      - ADR-AUTO-ENTERP
      - ADR-AUTO-IDEM#1
      - ADR-AUTO-PKGMGR#{5,6}
      - ADR-AUTO-REMOVE#2
      - ADR-PRIN-CONFIG#1
  config:
    synopsis: Installs zsh (user-space on Windows, into Git Bash's tree; apt-get on Linux; the system's on macOS).
    description: |-
      Windows: installs the MSYS2 zsh package that tools.yml pins (`zsh`: msys2_url and msys2_sha256) into the Git for
      Windows tree Install-Git provides (the entry's windows_install_dir), so zsh runs on Git Bash's own MSYS2 runtime.
      No admin required ([ADR-AUTO-ENTERP#4](/docs/adr/automation/effective-in-enterprises.md#rule-adr-auto-enterp4)). The package
      is downloaded through Save-VerifiedDownload and its SHA-256 checked before anything is extracted
      ([ADR-AUTO-PKGMGR#6](/docs/adr/automation/use-proper-package-managers.md#rule-adr-auto-pkgmgr6)); Windows' own tar
      reads the zstd archive. Only the files Git's tree lacks are copied, and their list is recorded in a manifest inside
      the tree before the copy starts, so Uninstall-Zsh removes exactly those
      ([ADR-AUTO-REMOVE#2](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove2)). PATH is left alone: zsh
      is located by its tools.yml candidates.

      Install-Git is a prerequisite, asserted and never run from here: without Git's tree the install stops and names
      Install-Git. Install-Git -Force replaces Git's whole tree, zsh included, so run Install-Zsh again after it
      (Install-DevBoxTools runs them in that order).

      Linux: installs the distribution's package that the entry's apt_package names, through Install-Tool (apt-get), when
      zsh is missing ([ADR-AUTO-PKGMGR#5](/docs/adr/automation/use-proper-package-managers.md#rule-adr-auto-pkgmgr5);
      [ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)). That needs root or
      passwordless sudo (Test-IsAdministrator), so tools.yml marks the entry linux_admin_only and a non-elevated
      Install-DevBoxTools skips it and says so. Either way it then asserts zsh at the pinned version.

      macOS: zsh ships as /bin/zsh, so Install-Zsh asserts it is present at the pinned version and installs nothing.

      Idempotent ([ADR-AUTO-IDEM#1](/docs/adr/automation/idempotent-state-functions.md#rule-adr-auto-idem1)): skips when
      the pinned package is already installed, and on Linux when zsh is already present at the pinned version, with no
      root asked for. A zsh from another package (Windows) or at another version (Linux) stops the install unless -Force
      is passed.
    parameters:
      Force: |-
        Windows: uninstall the zsh Install-Zsh placed (Uninstall-Zsh) and install the pinned package again. Linux: replace
        a zsh at another version through Install-Tool -Force. No effect on macOS.
    examples:
      - Install-Zsh
      - Install-Zsh -Force
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
