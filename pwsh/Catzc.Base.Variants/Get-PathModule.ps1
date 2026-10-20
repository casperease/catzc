<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Variants/Get-PathModule.ps1
    name: get-path-module
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1
    docs: "[Get-PathModule.ps1.md](docs/references/pwsh/catzc-base-variants/Get-PathModule.ps1.md)"
    cites:
      - ADR-DSGN-TRACK-ONETECHSTACK
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
