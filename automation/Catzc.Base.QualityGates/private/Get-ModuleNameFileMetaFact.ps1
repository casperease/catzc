<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/private/Get-ModuleNameFileMetaFact.ps1
    folder: private
    name: get-module-name-file-meta-fact
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
    test: automation/Catzc.Base.QualityGates/tests/Get-ModuleNameFileMetaFact.Tests.ps1
    cites:
      - ADR-REPO-CODEMETA#2
  config:
    synopsis: 'The module-name meta kind''s fact: the name of the module a file is placed in, from the module-types registry.'
    description: |-
      The module is the one Get-PathModule names for the path, by the places the module types of the module-types registry give. A file
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
    $value = if ($module) {
        $module.name
    }
    else {
        ''
    }
    [ordered]@{ $Kind.keys[0] = $value }
}
