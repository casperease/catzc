<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-VisibilityFileMetaFact.ps1
    folder: private
    name: get-visibility-file-meta-fact
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
    test: automation/Catzc.Base.QualityGates/tests/Get-VisibilityFileMetaFact.Tests.ps1
    cites:
      - ADR-REPO-CODEMETA#2
  config:
    synopsis: 'The visibility meta kind''s fact: whether a module''s function file is public or private, from its folder.'
    description: |-
      A file in the module's private folder is private, and any other file of the module is public. The modules root and the folder name
      are the kind's `root` and `private_folder` settings, `automation` and `private` unless the registry says otherwise.
    parameters:
      State: What the file's carrier reader returned.
      Path: The file's repository-relative path.
      Kind: The registry entry that subscribed this function.
    outputs: '[System.Collections.Specialized.OrderedDictionary] one entry per key of the kind.'
---
#>

function Get-VisibilityFileMetaFact {
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
    $folder = if ($Kind.settings.ContainsKey('private_folder')) {
        "$($Kind.settings['private_folder'])"
    }
    else {
        'private'
    }
    $inModule = [regex]::IsMatch($Path, '^' + [regex]::Escape($root) + '/[^/]+/')
    Assert-True $inModule -ErrorText "file-meta config: kind '$($Kind.id)' applies to files under $root/<module>/, but selected '$Path'."
    $isPrivate = [regex]::IsMatch($Path, '^' + [regex]::Escape($root) + '/[^/]+/' + [regex]::Escape($folder) + '/')
    $visibility = if ($isPrivate) {
        'private'
    }
    else {
        'public'
    }
    [ordered]@{ $Kind.keys[0] = $visibility }
}
