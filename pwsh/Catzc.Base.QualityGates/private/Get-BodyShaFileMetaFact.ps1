<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-BodyShaFileMetaFact.ps1
    folder: private
    name: get-body-sha-file-meta-fact
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
    test: pwsh/Catzc.Base.QualityGates/tests/Get-BodyShaFileMetaFact.Tests.ps1
    docs: "[Get-BodyShaFileMetaFact.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-BodyShaFileMetaFact.ps1.md)"
    cites:
      - ADR-REPO-FILEMETA-IMPRINTEDPARTS
---
#>

function Get-BodyShaFileMetaFact {
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

    [ordered]@{ $Kind.keys[0] = $State.BodyHash }
}
