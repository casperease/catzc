<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/private/Get-FilePathFileMetaFact.ps1
    folder: private
    name: get-file-path-file-meta-fact
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
    test: automation/Catzc.Base.QualityGates/tests/Get-FilePathFileMetaFact.Tests.ps1
    cites:
      - ADR-REPO-FILEMETA#3
      - ADR-REPO-FORMAT#6
  config:
    synopsis: 'The file-path meta kind''s fact: the file''s repository-relative path.'
    description: |-
      The path is a derived fact, so a moved file drifts and the formatter rewrites it; the H1 is the file's title, never its path
      ([ADR-REPO-FORMAT#6](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format6)).
    parameters:
      State: What Get-MarkdownMetaState read from the file.
      Path: The file's repository-relative path.
      Kind: The registry entry that subscribed this function.
    outputs: '[System.Collections.Specialized.OrderedDictionary] one entry per key of the kind.'
---
#>

function Get-FilePathFileMetaFact {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Every meta-kind processor is called with the same State, Path and Kind; this kind needs no state')]
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

    [ordered]@{ $Kind.keys[0] = $Path }
}
