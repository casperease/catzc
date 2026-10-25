<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-globs/Get-GlobSet.ps1.md"
  warning: "Generated Header"
---
#>

function Get-GlobSet {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Globs.GlobSet])]
    param(
        [ArgumentCompleter({ (Get-Config -Config globs).Names })]
        [string[]] $Name
    )

    $config = Get-Config -Config globs
    if (-not $PSBoundParameters.ContainsKey('Name')) {
        return $config.globsets
    }
    foreach ($setName in $Name) {
        $config.Get($setName)
    }
}
