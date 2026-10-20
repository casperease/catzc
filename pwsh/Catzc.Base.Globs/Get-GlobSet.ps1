<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Globs/Get-GlobSet.ps1
    name: get-glob-set
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Globs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Globs/tests/Get-GlobSet.Tests.ps1
    docs: "[Get-GlobSet.ps1.md](docs/references/pwsh/catzc-base-globs/Get-GlobSet.ps1.md)"
    cites:
      - ADR-FLOW-CD-GLOBS-NAMEDGLOBSETS
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
