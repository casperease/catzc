<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Node/Uninstall-NodeJs.ps1
    name: uninstall-node-js
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Node
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Tooling.Node/tests/Uninstall-NodeJs.Tests.ps1
    docs: "[Uninstall-NodeJs.ps1.md](docs/references/pwsh/catzc-tooling-node/Uninstall-NodeJs.ps1.md)"
    cites:
      - ADR-AUTO-ONEJOB-CALLERHANDLESERRORS
      - ADR-AUTO-REMOVE-DOUBLYGUARDED
      - ADR-AUTO-REMOVE-ONECALLESCALATION
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
