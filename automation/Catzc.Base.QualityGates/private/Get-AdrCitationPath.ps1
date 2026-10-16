<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/private/Get-AdrCitationPath.ps1
    folder: private
    name: get-adr-citation-path
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  config:
    synopsis: Maps every ADR citation code to its ADR's repository-relative path.
    description: |-
      A flat view of the citation map (Get-AdrCitationMap) for the Markdown heading normal form, which writes a moved
      citation as a link to its ADR.
    parameters:
      RepositoryRoot: The repository root whose ADR index is read.
    outputs: '[hashtable] citation code -> repository-relative ADR path.'
---
#>

function Get-AdrCitationPath {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $map = Get-AdrCitationMap -RepositoryRoot $RepositoryRoot
    $paths = @{}
    foreach ($code in $map.Codes) {
        $paths[$code] = $map.PathOf($code)
    }
    $paths
}
