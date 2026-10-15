<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Python/Uninstall-Poetry.ps1
    kind: automation-function
    module: Catzc.Tooling.Python
    visibility: public
  config:
    synopsis: Uninstalls Poetry.
    description: |-
      Removes the uv-managed install (`uv tool uninstall poetry`) via Uninstall-UvTool. Idempotent — skips if
      Poetry is not installed.
    examples:
      - Uninstall-Poetry
---
#>

function Uninstall-Poetry {
    [CmdletBinding()]
    param()

    Uninstall-UvTool -Tool 'poetry'
}
