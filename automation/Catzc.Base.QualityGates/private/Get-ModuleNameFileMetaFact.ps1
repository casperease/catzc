<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-ModuleNameFileMetaFact.ps1
    kind: fact
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Get-ModuleNameFileMetaFact.Tests.ps1
    adrs:
      - ADR-REPO-CODEMETA#2
  config:
    synopsis: 'The module-name meta kind''s fact: the module a file is placed in, the folder under the automation track''s root.'
    description: |-
      The module is the one Get-PathModule names for the path, from the root of the `automation` track in the `tracks` registry. A file
      placed in no module gets an empty value, so the key is left out of its head.
    parameters:
      State: What the file's carrier reader returned.
      Path: The file's repository-relative path.
      Kind: The registry entry that subscribed this function.
    outputs: '[System.Collections.Specialized.OrderedDictionary] one entry per key of the kind.'
---
#>

function Get-ModuleNameFileMetaFact {
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

    $module = Get-PathModule $Path
    [ordered]@{ $Kind.keys[0] = $(if ($module) { $module } else { '' }) }
}
