<#
---
catzc:
  immutable:
    path: automation/Catzc.Tooling.Python/Uninstall-Poetry.ps1
    name: uninstall-poetry
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Python
    moduletype: pwsh-folder
    catzc_bundle: azure
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
