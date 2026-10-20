<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-LinksFileMetaFact.ps1
    folder: private
    name: get-links-file-meta-fact
    filetype: ps1
    role: function
    subkind: fact
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-LinksFileMetaFact.Tests.ps1
    docs: "[Get-LinksFileMetaFact.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-LinksFileMetaFact.ps1.md)"
    cites:
      - ADR-REPO-FILEMETA-IMPRINTEDPARTS
---
#>

function Get-LinksFileMetaFact {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [pscustomobject] $State,

        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [Catzc.Base.QualityGates.FileMetaKind] $Kind
    )

    $page = (Get-Config -Config comments).PageFor($Path)
    [ordered]@{ $Kind.keys[0] = [string[]] @([Catzc.Base.QualityGates.DocumentLinks]::Of($State.Body, $Path, $page)) }
}
