<#
---
catzc:
  immutable:
    with_body_sha: "6c44e87d3ac1"
  edges:
    test: pwsh/Catzc.Base.Globs/tests/Get-GlobSet.Tests.ps1
    docs: "[Get-GlobSet.ps1.md](../../docs/references/pwsh/catzc-base-globs/Get-GlobSet.ps1.md)"
    cites:
      - FDR-CD-GLOBS-NAMEDGLOBSETS
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
