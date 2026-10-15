<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/Install-Dotnet.ps1
    kind: automation-function
    module: Catzc.Tooling.Toolchain
    visibility: public
    relatives:
      page: docs/references/automation/catzc-tooling-toolchain/Install-Dotnet.ps1.md
      test: automation/Catzc.Tooling.Toolchain/tests/Install-Dotnet.Tests.ps1
    adrs:
      - ADR-AUTO-ASSETDEP#1
      - ADR-AUTO-CONSOLE#11
      - ADR-AUTO-IDEM#1
  config:
    synopsis: Installs the .NET SDK via official Microsoft install scripts (user-space).
    description: |-
      Uses the vendored dotnet-install scripts shipped in this module's assets/scripts/ (resolved
      through Get-CatzcModuleRoot, so the same in source and build mode) instead of package managers.
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
    parameters:
      Version: '.NET SDK version to install. Defaults to the locked version in Get-ToolConfig.'
      Force: Replace an existing installation at the wrong version.
    examples:
      - Install-Dotnet
      - Install-Dotnet -Version '10.0'
---
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
        $installed = Get-ToolVersion -Config $config
        if ($installed -and $installed.StartsWith($Version)) {
            Write-Message "Dotnet $Version is already installed"
            return
        }
    }

    if ($needsInstall) {
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
