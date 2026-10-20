<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-AdrDefinesFileMetaFact.ps1
    folder: private
    name: get-adr-defines-file-meta-fact
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
    test: pwsh/Catzc.Base.QualityGates/tests/Get-AdrDefinesFileMetaFact.Tests.ps1
    docs: "[Get-AdrDefinesFileMetaFact.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-AdrDefinesFileMetaFact.ps1.md)"
    cites:
      - ADR-REPO-FILEMETA-IMPRINTEDPARTS
---
#>

function Get-AdrDefinesFileMetaFact {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Every meta-kind processor is called with the same State, Path and Kind; this kind needs no path')]
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

    # The file is the one place its own rules are declared, so its headings in document order are the list.
    [ordered]@{ $Kind.keys[0] = [string[]] @(Get-AdrDefinedRule -Text $State.Body) }
}
