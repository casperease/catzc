<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-FileKindFileMetaFact.ps1
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
      test: automation/Catzc.Base.QualityGates/tests/Get-FileKindFileMetaFact.Tests.ps1
    adrs:
      - ADR-PRIN-CONFIG#1
      - ADR-REPO-FILEMETA#3
  config:
    synopsis: 'The file-kind meta kind''s fact: the kind of the file, and its subkind when it has one, from the file-kinds registry.'
    description: |-
      The kind is the one Get-FileKind names for the path: the first kind of the registry whose globs match wins, and a file no kind
      matches is `other`. The kind's first key holds the kind and its second, when the registry entry lists one, the subkind, which is
      left out of the head for a file with none. The kinds are data in the file-kinds registry, never a list in this function
      ([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)).
    parameters:
      State: What Get-MarkdownMetaState read from the file.
      Path: The file's repository-relative path.
      Kind: The registry entry that subscribed this function.
    outputs: '[System.Collections.Specialized.OrderedDictionary] one entry per key of the kind.'
---
#>

function Get-FileKindFileMetaFact {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Every meta-kind processor is called with the same State, Path and Kind; this kind classifies by path alone')]
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

    $match = Get-FileKind $Path
    $fact = [ordered]@{ $Kind.keys[0] = $match.kind }
    if ($Kind.keys.Count -gt 1) {
        $fact[$Kind.keys[1]] = $(if ($match.subkind) {
                $match.subkind
            }
            else {
                ''
            })
    }
    $fact
}
