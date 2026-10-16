<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-AdrDefinesFileMetaFact.ps1
    folder: private
    name: get-adr-defines-file-meta-fact
    filetype: ps1
    kind: function
    subkind: fact
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Get-AdrDefinesFileMetaFact.Tests.ps1
    adrs:
      - ADR-REPO-FILEMETA#3
  config:
    synopsis: 'The adr-defines meta kind''s fact: the rules an ADR defines itself, spelled as citations.'
    description: |-
      The rules come from the file's own rule headings, so the list is what the file declares and not what it cites. They are written in
      the minimal form, `ADR-<CODE>#{1,3-5}` (Catzc.Base.Docs.AdrCodeForm), without globs.
    parameters:
      State: What Get-MarkdownMetaState read from the file.
      Path: The file's repository-relative path.
      Kind: The registry entry that subscribed this function.
    outputs: '[System.Collections.Specialized.OrderedDictionary] one entry per key of the kind.'
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

    # No registry: the file is the one place its own rules are declared, so a glob over the registry would say nothing the headings do not.
    [ordered]@{ $Kind.keys[0] = [string[]] @([Catzc.Base.Docs.AdrCodeForm]::Minimize([string[]] @(Get-AdrDefinedRule -Text $State.Body))) }
}
