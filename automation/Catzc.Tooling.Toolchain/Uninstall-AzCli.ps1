<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/Uninstall-AzCli.ps1
    name: uninstall-az-cli
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
    relatives:
      page: docs/references/automation/catzc-tooling-toolchain/Uninstall-AzCli.ps1.md
      test: automation/Catzc.Tooling.Toolchain/tests/Uninstall-AzCli.Tests.ps1
    adrs:
      - ADR-AUTO-ONEJOB#5
      - ADR-AUTO-REMOVE#{4,5}
  config:
    synopsis: Uninstalls the Azure CLI.
    description: |-
      Removes az's dedicated uv venv via Uninstall-UvVenvTool — the managed uninstall (idempotent, skips if not
      installed). For an Azure CLI installed OUTSIDE the tooling system (a lingering machine-scope MSI, an apt
      'azure-cli', a pip install), escalate with -Remove -Force: the managed uninstall runs best-effort and then
      falls through to Remove-AzCli, which destructively evicts whatever the configured manager did not own
      ([ADR-AUTO-REMOVE#5](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove5)).
    parameters:
      Remove: |-
        After the managed uninstall, escalate to Remove-AzCli to evict an off-config install the managed path
        cannot touch. Pair with -Force to actually remove; -Remove alone reports the plan
        ([ADR-AUTO-REMOVE#4](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove4)).
      Force: Confirm the destructive Remove-AzCli step of the escalation. Ignored without -Remove.
    examples:
      - Uninstall-AzCli
      - Uninstall-AzCli -Remove -Force
---
#>

function Uninstall-AzCli {
    [CmdletBinding()]
    param(
        [switch] $Remove,
        [switch] $Force
    )

    try {
        Uninstall-UvVenvTool -Tool 'az_cli'
    }
    catch {
        if (-not $Remove) {
            throw
        }
        Write-Message "Managed uninstall did not apply ($($_.Exception.Message.Trim())); escalating to Remove-AzCli."
    }

    if ($Remove) {
        Remove-AzCli -Force:$Force
    }
}
