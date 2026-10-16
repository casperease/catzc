<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/private/Get-TrackFileMetaFact.ps1
    folder: private
    name: get-track-file-meta-fact
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
    test: automation/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1
    cites:
      - ADR-DSGN-TRACK#1
  config:
    synopsis: 'The track meta kind''s fact: the track whose root folder holds the file.'
    description: |-
      The track is the one Get-Track names for the path, from the `tracks` registry
      ([ADR-DSGN-TRACK#1](/docs/adr/design/tracks.md#rule-adr-dsgn-track1)). A root file, which no track holds, gets an empty value, so
      the key is left out of its head.
    parameters:
      State: What Get-MarkdownMetaState read from the file.
      Path: The file's repository-relative path.
      Kind: The registry entry that subscribed this function.
    outputs: '[System.Collections.Specialized.OrderedDictionary] one entry per key of the kind.'
---
#>

function Get-TrackFileMetaFact {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Every meta-kind processor is called with the same State, Path and Kind; this kind reads the track by path alone')]
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
    $name = if ($track) {
        $track.name
    }
    else {
        ''
    }
    [ordered]@{ $Kind.keys[0] = $name }
}
