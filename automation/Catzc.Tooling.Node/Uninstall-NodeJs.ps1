<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Node/Uninstall-NodeJs.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Tooling.Node
    visibility: public
    relatives:
      page: docs/references/automation/catzc-tooling-node/Uninstall-NodeJs.ps1.md
      test: automation/Catzc.Tooling.Node/tests/Uninstall-NodeJs.Tests.ps1
    adrs:
      - ADR-AUTO-ONEJOB#5
      - ADR-AUTO-REMOVE#{4,5}
  config:
    synopsis: Uninstalls Node.js via the platform package manager.
    description: |-
      Removes Node.js (and its bundled npm) through the configured manager — the managed uninstall. Idempotent —
      skips if not installed. For a Node.js installed OUTSIDE the tooling system (a stray binary, a foreign
      package), escalate with -Remove -Force: the managed uninstall runs best-effort and then falls through to
      Remove-NodeJs, which destructively evicts whatever the configured manager did not own
      ([ADR-AUTO-REMOVE#5](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove5)).
    parameters:
      Version: Node.js version to uninstall. Defaults to the locked version in Get-ToolConfig.
      Remove: |-
        After the managed uninstall, escalate to Remove-NodeJs to evict an off-config install the managed path
        cannot touch. Pair with -Force to actually remove; -Remove alone reports the plan
        ([ADR-AUTO-REMOVE#4](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove4)).
      Force: Confirm the destructive Remove-NodeJs step of the escalation. Ignored without -Remove.
    examples:
      - Uninstall-NodeJs
      - Uninstall-NodeJs -Remove -Force
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
