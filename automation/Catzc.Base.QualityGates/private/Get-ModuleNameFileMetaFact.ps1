<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-ModuleNameFileMetaFact.ps1
    kind: fact-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-REPO-CODEMETA#2
  config:
    synopsis: 'The module-name meta kind''s fact: the module a file belongs to, the folder under the modules root.'
    description: |-
      The modules root is the kind's `root` setting, `automation` unless the registry says otherwise. A file outside any module is an error,
      since the kind's globs should never select one.
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

    $root = if ($Kind.settings.ContainsKey('root')) {
        "$($Kind.settings['root'])"
    }
    else {
        'automation'
    }
    $match = [regex]::Match($Path, '^' + [regex]::Escape($root) + '/(?<module>[^/]+)/')
    Assert-True $match.Success -ErrorText "file-meta config: kind '$($Kind.id)' applies to files under $root/<module>/, but selected '$Path'."
    [ordered]@{ $Kind.keys[0] = $match.Groups['module'].Value }
}
