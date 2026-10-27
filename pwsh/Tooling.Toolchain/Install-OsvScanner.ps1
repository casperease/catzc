function Install-OsvScanner {
    [CmdletBinding()]
    param(
        [string] $Version = (Get-ToolConfig -Tool 'osv_scanner').version,

        [switch] $Force
    )

    if (-not $IsLinux) {
        # Windows / macOS: Install-Tool (winget / brew).
        Install-Tool -Tool 'osv_scanner' -Version $Version -Force:$Force
        return
    }

    $probe = Test-Tool 'osv_scanner' -PassThru
    if ($probe.Version -and $probe.Version.StartsWith($Version)) {
        Write-Message "osv-scanner $Version is already installed at '$($probe.Path)'"
        return
    }
    if ($probe.Version -and -not $Force) {
        throw "osv-scanner version mismatch: expected $Version.x, found $($probe.Version) at '$($probe.Path)'. Run Install-OsvScanner -Force to replace."
    }
    Install-OsvScannerStandalone -Version $Version
    Add-PermanentPath (Join-Path $env:HOME '.local/bin') -Label 'Install-OsvScanner'

    $probe = Test-Tool 'osv_scanner' -PassThru
    if (-not ($probe.Version -and $probe.Version.StartsWith($Version))) {
        throw "osv-scanner was installed to ~/.local/bin but the check found $($probe.Version ?? 'no version') at '$($probe.Path ?? 'no path')'. Restart your shell, then run Test-Tool osv_scanner -PassThru | Write-ToolProbeReport."
    }
}
