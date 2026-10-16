<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-TrackTypeFileMetaFact.ps1
    folder: private
    name: get-track-type-file-meta-fact
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
    test: automation/Catzc.Base.QualityGates/tests/Get-TrackTypeFileMetaFact.Tests.ps1
    cites:
      - ADR-DSGN-TRACKTYPE#6
  config:
    synopsis: 'The track-type meta kind''s fact: the type of the track that holds the file.'
    description: |-
      The track is the one Get-Track names for the path, and its type is the track type the `tracks` registry declares for it
      ([ADR-DSGN-TRACKTYPE#6](/docs/adr/design/track-types.md#rule-adr-dsgn-tracktype6)). A root file, which no track holds, gets an
      empty value, so the key is left out of its head.
    parameters:
      State: What Get-MarkdownMetaState read from the file.
      Path: The file's repository-relative path.
      Kind: The registry entry that subscribed this function.
    outputs: '[System.Collections.Specialized.OrderedDictionary] one entry per key of the kind.'
---
#>

function Get-TrackTypeFileMetaFact {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Every meta-kind processor is called with the same State, Path and Kind; this kind reads the track type by path alone')]
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

    $track = Get-Track -Path $Path
    $value = if ($track) {
        $track.type
    }
    else {
        ''
    }
    [ordered]@{ $Kind.keys[0] = $value }
}
