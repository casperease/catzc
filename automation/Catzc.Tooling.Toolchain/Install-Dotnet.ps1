<#
.SYNOPSIS
    Installs the .NET SDK via official Microsoft install scripts (user-space).
.DESCRIPTION
    Uses the vendored dotnet-install scripts shipped in this module's assets/scripts/ (resolved through...
    [comment:1](/docs/references/automation/catzc-tooling-toolchain/Install-Dotnet.ps1.md#comment1)
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
        [string] $Version = (Get-ToolConfig -Tool 'dotnet').version,
        [switch] $Force
    )

    Assert-False (Test-IsRunningInPipeline) -ErrorText (
        'Install-Dotnet is for developer workstations, not CI. ' +
        "In ADO pipelines, use the native task: - task: UseDotNet@2 inputs: version: '10.x'"
    )

    $config = Get-ToolConfig -Tool 'dotnet'

    $installDir = Get-ScriptInstallDir -Config $config
    $ourBinary = if ($IsWindows) {
        Join-Path $installDir 'dotnet.exe'
    }
    else {
        Join-Path $installDir 'dotnet'
    }

    # Decide whether to run the install script.
    # [ADR-AUTO-IDEM#1](/docs/adr/automation/idempotent-state-functions.md#rule-adr-auto-idem1)
    # [comment:2](/docs/references/automation/catzc-tooling-toolchain/Install-Dotnet.ps1.md#comment2)
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
        # Nothing in our install dir, but a dotnet is on PATH.
        # [comment:3](/docs/references/automation/catzc-tooling-toolchain/Install-Dotnet.ps1.md#comment3)
        $installed = Get-ToolVersion -Config $config
        if ($installed -and $installed.StartsWith($Version)) {
            Write-Message "Dotnet $Version is already installed"
            return
        }
    }

    if ($needsInstall) {
        # Resolve the vendored install script shipped in this module's assets/
        # [ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1)
        # [comment:4](/docs/references/automation/catzc-tooling-toolchain/Install-Dotnet.ps1.md#comment4)
        if ($IsWindows) {
            $scriptPath = Get-CatzcModuleRoot 'assets/scripts/dotnet-install.ps1'
            Assert-PathExist $scriptPath
            Write-Message "Installing .NET SDK $Version to '$installDir'"
            & $scriptPath -Channel $Version -InstallDir $installDir -Quality ga
        }
        else {
            $scriptPath = Get-CatzcModuleRoot 'assets/scripts/dotnet-install.sh'
            Assert-PathExist $scriptPath
            Write-Message "Installing .NET SDK $Version to '$installDir'"
            Invoke-Executable "bash '$scriptPath' --channel $Version --install-dir $installDir --quality ga"
        }
    }

    # Converge the environment on every run that owns the install — session + persistent, both idempotent.
    # [ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11)
    # [comment:5](/docs/references/automation/catzc-tooling-toolchain/Install-Dotnet.ps1.md#comment5)
    if ($env:DOTNET_ROOT -ne $installDir) {
        $env:DOTNET_ROOT = $installDir
        Write-Message "Session: DOTNET_ROOT='$installDir'"
    }
    Add-PermanentPath $installDir -Prepend -Label 'Install-Dotnet'

    # Persist DOTNET_ROOT separately (not PATH — handled above)
    if ($IsWindows) {
        # the seam announces the change, and does nothing when the value is already set
        Set-PermanentEnvironmentVariable DOTNET_ROOT $installDir
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
            Write-Message "Profile '$profilePath': added the DOTNET_ROOT block"
        }
    }

    Assert-Command dotnet -ErrorText ".NET SDK was installed but 'dotnet' is not on PATH. You may need to restart your shell."
    if ($needsInstall) {
        Write-Message "Dotnet $Version installed successfully to '$installDir'"
    }
}
