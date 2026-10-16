<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-ModuleTypeFileMetaFact.ps1
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
      test: automation/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1
    adrs:
      - ADR-DSGN-TRACK#3
  config:
    synopsis: 'The module-type meta kind''s fact: the type of the module a file is placed in, from the module-types registry.'
    description: |-
      The module type is the one Get-PathModule names for the path ([ADR-DSGN-TRACK#3](/docs/adr/design/tracks.md#rule-adr-dsgn-track3)):
      a pwsh-folder, a settings, a pipeline and so on, as the module-types registry declares them. A file placed in no
      module gets an empty value, so the key is left out of its head.
    parameters:
      State: What Get-MarkdownMetaState read from the file.
      Path: The file's repository-relative path.
      Kind: The registry entry that subscribed this function.
    outputs: '[System.Collections.Specialized.OrderedDictionary] one entry per key of the kind.'
---
#>

function Get-ModuleTypeFileMetaFact {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Every meta-kind processor is called with the same State, Path and Kind; this kind reads the module type by path alone')]
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

    $module = Get-PathModule $Path
    $value = if ($module) {
        $module.type
    }
    else {
        ''
    }
    [ordered]@{ $Kind.keys[0] = $value }
}
