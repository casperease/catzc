<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-FileNameFileMetaFact.ps1
    kind: function
    subkind: fact
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Get-FileNameFileMetaFact.Tests.ps1
    adrs:
      - ADR-REPO-FILEMETA#11
  config:
    synopsis: 'The file-name meta kind''s facts: the folder of the file under its module, and its name in kebab case.'
    description: |-
      The path under the module (the whole path for a file placed in no module) is split into an optional folder, a kebab-case name and the
      file type, which the file-type kind writes
      ([ADR-REPO-FILEMETA#11](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta11)). The split asserts that the three build the path
      back, so a path that is not made of them stops the run. A file directly in its module has no folder, so that key is left out of its
      head.
    parameters:
      State: What Get-MarkdownMetaState read from the file.
      Path: The file's repository-relative path.
      Kind: The registry entry that subscribed this function.
    outputs: '[System.Collections.Specialized.OrderedDictionary] one entry per key of the kind.'
---
#>

function Get-FileNameFileMetaFact {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Every meta-kind processor is called with the same State, Path and Kind; this kind reads the file name by path alone')]
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
    $tail = if ($module -and $module.tail) {
        $module.tail
    }
    else {
        $Path
    }
    $parts = [Catzc.Base.Languages.PathParts]::Of($tail)
    $facts = [ordered]@{}
    $facts[$Kind.keys[0]] = $parts.folder
    $facts[$Kind.keys[1]] = $parts.name
    $facts
}
