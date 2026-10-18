<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Node/Uninstall-NodeJs.ps1
    name: uninstall-node-js
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Node
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-tooling-node/Uninstall-NodeJs.ps1.md
    test: automation/Catzc.Tooling.Node/tests/Uninstall-NodeJs.Tests.ps1
    cites:
      - ADR-AUTO-ONEJOB#5
      - ADR-AUTO-REMOVE#{4,5}
---
#>

function Uninstall-NodeJs {
    [CmdletBinding()]
    param(
        [string] $Version,
        [switch] $Remove,
        [switch] $Force
    )

    try {
        Uninstall-Tool -Tool 'node_js' -Version $Version
    }
    catch {
        if (-not $Remove) {
            throw
        }
        Write-Message "Managed uninstall did not apply ($($_.Exception.Message.Trim())); escalating to Remove-NodeJs."
    }

    if ($Remove) {
        Remove-NodeJs -Force:$Force
    }
}
