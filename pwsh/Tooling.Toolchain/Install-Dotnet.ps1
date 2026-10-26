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

    # Even a skipped download still converges the environment below, so a re-run repairs a lost PATH or DOTNET_ROOT persistence.
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
        # A foreign dotnet at the right version is not ours to manage; a wrong one does not block, since ours installs side by side.
        $installed = Get-ToolVersion -Config $config
        if ($installed -and $installed.StartsWith($Version)) {
            Write-Message "Dotnet $Version is already installed"
            return
        }
    }

    if ($needsInstall) {
        # The install script is the vendored copy shipped in this module's assets.
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

    # This PATH is how non-repo processes such as an editor's language server find dotnet; each change is announced only when it changes something.
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
