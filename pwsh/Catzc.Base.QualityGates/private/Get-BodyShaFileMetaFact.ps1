<#
---
catzc:
  immutable:
    with_body_sha: c66f82b6c521
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

    $hash = if ($State.PSObject.Properties['BodyHash']) {
        $State.BodyHash
    }
    else {
        [Catzc.Base.MarkdownMeta.MarkdownDocument]::HashOf($State.Body)
    }
    [ordered]@{ $Kind.keys[0] = $hash }
}
