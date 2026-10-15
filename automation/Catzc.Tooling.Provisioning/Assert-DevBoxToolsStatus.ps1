<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Provisioning/Assert-DevBoxToolsStatus.ps1
    kind: assert-function
    module: Catzc.Tooling.Provisioning
    visibility: public
    relatives:
      test: automation/Catzc.Tooling.Provisioning/tests/Assert-DevBoxToolsStatus.Tests.ps1
  config:
    synopsis: Asserts all tools are available at the correct version.
    description: |-
      Calls Get-ToolsStatus and throws if any tool is Missing or WrongVersion.
      Tools with status OK or Usable pass — the tool works regardless of how
      it was installed. Chocolatey status is ignored.
    examples:
      - Assert-DevBoxToolsStatus
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
