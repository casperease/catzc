<#
---
catzc:
  immutable:
    with_body_sha: "8d7ec02a0643"
  edges:
    test: pwsh/Catzc.Tooling.Provisioning/tests/Assert-DevBoxToolsStatus.Tests.ps1
    docs: "[Assert-DevBoxToolsStatus.ps1.md](../../docs/references/pwsh/catzc-tooling-provisioning/Assert-DevBoxToolsStatus.ps1.md)"
---
#>

function Assert-DevBoxToolsStatus {
    [CmdletBinding()]
    param()

    $status = Get-ToolsStatus
    $failures = @($status | Where-Object { $_.Status -in 'Missing', 'WrongVersion' })

    if ($failures) {
        $details = ($failures | ForEach-Object {
                "  $($_.Tool): expected $($_.Locked), found $(if ($_.Installed) { $_.Installed } else { 'not installed' }) — $($_.Action)"
            }) -join "`n"
        throw "Tools not ready. Run Install-DevBoxTools to fix.`n`n$details"
    }
}
