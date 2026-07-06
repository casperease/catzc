<#
.SYNOPSIS
    Installs the .NET SDK via official Microsoft install scripts (user-space).
.DESCRIPTION
    Uses vendored dotnet-install scripts instead of package managers.
    Install directory resolved by Get-ScriptInstallDir (LOCALAPPDATA on
    Windows, HOME on Unix — overridable in tools.yml).
    No admin required. Persists DOTNET_ROOT and PATH for future sessions.
    Idempotent — converges to the desired state on every run: when our
    install dir already holds the locked version the download is skipped,
    but the environment (session + persistent PATH, DOTNET_ROOT) is still
    converged, so a machine whose PATH persistence was lost is repaired by
    re-running. Only a right-version dotnet from elsewhere on PATH (a
    system-wide install we do not manage) is a true no-op.

    NOT for CI pipelines. In Azure DevOps, use the native UseDotNet task
    which activates pre-cached versions instantly:

        - task: UseDotNet@2
          inputs:
            version: '10.x'
.PARAMETER Version
    .NET SDK version to install. Defaults to the locked version in Get-ToolConfig.
.PARAMETER Force
    Replace an existing installation at the wrong version.
.EXAMPLE
    Install-Dotnet
.EXAMPLE
    Install-Dotnet -Version '10.0'
#>
function Install-Dotnet {
    [CmdletBinding()]
    param(
        [string] $Version,
        [switch] $Force
    )

    Assert-False (Test-IsRunningInPipeline) -ErrorText (
        'Install-Dotnet is for developer workstations, not CI. ' +
        "In ADO pipelines, use the native task: - task: UseDotNet@2 inputs: version: '10.x'"
    )

    $config = Get-ToolConfig -Tool 'dotnet'
    if (-not $Version) {
        $Version = $config.version
    }

    $installDir = Get-ScriptInstallDir -Config $config
    $ourBinary = if ($IsWindows) {
        Join-Path $installDir 'dotnet.exe'
    }
    else {
        Join-Path $installDir 'dotnet'
    }

    # Decide whether to run the install script. Our own install dir wins the check: when it already holds
    # the locked version the download is skipped, but the environment is STILL converged below — re-running
    # repairs a lost PATH/DOTNET_ROOT persistence instead of returning past it (ADR-IDEM:1). Without this,
    # a session where dotnet resolves through the session janitor's PATH hints masks a broken persistent
    # PATH forever, and every non-repo process (an editor's language server) fails to find dotnet.
    $needsInstall = $true
    if (Test-Path $ourBinary) {
        # Check the specific binary (not PATH) — can't use Get-ToolVersion here
        $result = Invoke-Executable "$ourBinary --version" -PassThru -NoAssert -Silent
        $ourInstalled = if ($result.Full -match $config.version_pattern) {
            $Matches['ver']
        }
        else {
            $null
        }

        if ($ourInstalled -and $ourInstalled.StartsWith($Version)) {
            Write-Message "Dotnet $Version is already installed at '$installDir'"
            $needsInstall = $false
        }
        elseif ($Force) {
            Write-Verbose "Dotnet $ourInstalled found at '$installDir' — reinstalling $Version"
        }
        else {
            throw "Dotnet version mismatch: expected $Version.x, found $ourInstalled at '$installDir'. Run Install-Dotnet -Force to replace."
        }
    }
    elseif (Test-Command $config.command) {
        # Nothing in our install dir, but a dotnet is on PATH. At the right version that install —
        # wherever it lives — satisfies the tool contract and is not ours to manage: skip without touching
        # PATH or DOTNET_ROOT. A wrong version elsewhere doesn't block us since we install side-by-side
        # and prepend our dir to PATH.
        $installed = Get-ToolVersion -Config $config
        if ($installed -and $installed.StartsWith($Version)) {
            Write-Message "Dotnet $Version is already installed"
            return
        }
    }

    if ($needsInstall) {
        # Resolve vendored install script
        if ($IsWindows) {
            $scriptPath = Join-Path -Path $PSScriptRoot -ChildPath 'assets' -AdditionalChildPath 'scripts', 'dotnet-install.ps1'
            Assert-PathExist $scriptPath
            Write-Message "Installing .NET SDK $Version to '$installDir'"
            & $scriptPath -Channel $Version -InstallDir $installDir -Quality ga
        }
        else {
            $scriptPath = Join-Path -Path $PSScriptRoot -ChildPath 'assets' -AdditionalChildPath 'scripts', 'dotnet-install.sh'
            Assert-PathExist $scriptPath
            Write-Message "Installing .NET SDK $Version to '$installDir'"
            Invoke-Executable "bash '$scriptPath' --channel $Version --install-dir $installDir --quality ga"
        }
    }

    # Converge the environment on every run that owns the install — session + persistent, both idempotent.
    # This is the PATH non-repo processes resolve dotnet through.
    $env:DOTNET_ROOT = $installDir
    Add-PermanentPath $installDir -Prepend -Label 'Install-Dotnet'

    # Persist DOTNET_ROOT separately (not PATH — handled above)
    if ($IsWindows) {
        [Environment]::SetEnvironmentVariable('DOTNET_ROOT', $installDir, 'User')
    }
    else {
        $startMarker = '>>> catzc DOTNET_ROOT >>>'
        $profilePath = $PROFILE.CurrentUserCurrentHost
        $profileExists = Test-Path $profilePath
        $alreadyPatched = $profileExists -and (Get-Content $profilePath -Raw) -match [regex]::Escape($startMarker)

        if (-not $alreadyPatched) {
            $block = @"

# $startMarker
`$env:DOTNET_ROOT = "$installDir"
# <<< catzc DOTNET_ROOT <<<
"@
            Add-Content -Path $profilePath -Value $block
        }
    }

    Assert-Command dotnet -ErrorText ".NET SDK was installed but 'dotnet' is not on PATH. You may need to restart your shell."
    if ($needsInstall) {
        Write-Message "Dotnet $Version installed successfully to '$installDir'"
    }
}
