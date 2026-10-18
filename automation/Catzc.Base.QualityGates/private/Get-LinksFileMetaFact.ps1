<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-LinksFileMetaFact.ps1
    folder: private
    name: get-links-file-meta-fact
    filetype: ps1
    kind: function
    subkind: fact
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Get-LinksFileMetaFact.Tests.ps1
    cites:
      - ADR-REPO-FILEMETA#3
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
