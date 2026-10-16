<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-FileTypeFileMetaFact.ps1
    kind: function
    subkind: fact
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1
    adrs:
      - ADR-DSGN-TRACK#6
  config:
    synopsis: 'The file-type meta kind''s fact: the file type of the file, the extension of its name.'
    description: |-
      The file type is the one Get-PathFileType names for the path ([ADR-DSGN-TRACK#6](/docs/adr/design/tracks.md#rule-adr-dsgn-track6)); the
      kind's `keys` name the head key it is written under. A file with no extension gets an empty value, so the key is left out of its head.
    parameters:
      State: What Get-MarkdownMetaState read from the file.
      Path: The file's repository-relative path.
      Kind: The registry entry that subscribed this function.
    outputs: '[System.Collections.Specialized.OrderedDictionary] one entry per key of the kind.'
---
#>

function Get-FileTypeFileMetaFact {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Every meta-kind processor is called with the same State, Path and Kind; this kind reads the file type by path alone')]
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

    $fileType = Get-PathFileType $Path
    $value = if ($fileType) {
        $fileType
    }
    else {
        ''
    }
    [ordered]@{ $Kind.keys[0] = $value }
}
