<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-RepoStatusFileMetaFact.ps1
    folder: private
    name: get-repo-status-file-meta-fact
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
    test: automation/Catzc.Base.QualityGates/tests/Get-RepoStatusFileMetaFact.Tests.ps1
  config:
    synopsis: 'The repo-status meta kind''s fact: whether the file is locked (generated, edit its source) or clean (authored).'
    description: |-
      The stored status is the part of a file's repository status that the file itself decides: `locked` for a file of a class the kind's
      `locked_classes` setting lists, a generated file whose source is the truth, and `clean` for every other file. The states that only git
      knows (edited, staged, committed, pushed) are never written into the file, since the write would change them.
    parameters:
      State: What Get-MarkdownMetaState read from the file.
      Path: The file's repository-relative path.
      Kind: The registry entry that subscribed this function.
    outputs: '[System.Collections.Specialized.OrderedDictionary] one entry per key of the kind.'
---
#>

function Get-RepoStatusFileMetaFact {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Every meta-kind processor is called with the same State, Path and Kind; this kind reads the file class by path alone')]
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

    $lockedClasses = if ($Kind.settings.ContainsKey('locked_classes')) {
        @($Kind.settings['locked_classes'])
    }
    else {
        @()
    }
    $fileClass = (Get-FileKind $Path).Class
    $value = if ($fileClass -in $lockedClasses) {
        'locked'
    }
    else {
        'clean'
    }
    [ordered]@{ $Kind.keys[0] = $value }
}
