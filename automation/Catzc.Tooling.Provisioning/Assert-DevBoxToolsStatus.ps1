<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Provisioning/Assert-DevBoxToolsStatus.ps1
    kind: function
    module: Catzc.Tooling.Provisioning
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Asserts all tools are available at the correct version.
.DESCRIPTION
    Usable passes like OK and Chocolatey status is ignored: a tool counts if it works, however it was installed.
    [comment:1](/docs/references/automation/catzc-tooling-provisioning/Assert-DevBoxToolsStatus.ps1.md#comment1)
.EXAMPLE
    Assert-DevBoxToolsStatus
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
