<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-BodyShaFileMetaFact.ps1
    kind: fact-function
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Get-BodyShaFileMetaFact.Tests.ps1
    adrs:
      - ADR-REPO-FILEMETA#3
  config:
    synopsis: 'The body-sha meta kind''s fact: the hash of the file''s body below its front matter.'
    description: The hash changes exactly when the body does; front matter and line endings never move it.
    parameters:
      State: What Get-MarkdownMetaState read from the file.
      Path: The file's repository-relative path.
      Kind: The registry entry that subscribed this function.
    outputs: '[System.Collections.Specialized.OrderedDictionary] one entry per key of the kind.'
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
