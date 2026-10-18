<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Variants/Get-PathModule.ps1
    name: get-path-module
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1
    cites:
      - ADR-DSGN-TRACK#3
---
#>

function Get-PathModule {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Variants.PathModule])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Path
    )

    $module = (Get-Config -Config module-types).Resolve($Path)
    if ($module) {
        $module
    }
}
