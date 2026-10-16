<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-FileKindFileMetaFact.ps1
    kind: fact-function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Get-FileKindFileMetaFact.Tests.ps1
    adrs:
      - ADR-PRIN-CONFIG#1
      - ADR-REPO-FILEMETA#3
  config:
    synopsis: 'The file-kind meta kind''s fact: the class of the file, from the registry''s ordered classes.'
    description: |-
      The first class whose globs match the path wins; a file no class matches is `other`. The classes are data in the
      registry (its top-level `classes`), never a list in this function ([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)).
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

    $registry = if ($Kind.registry) {
        $Kind.registry
    }
    else {
        Get-Config -Config file-meta
    }
    [ordered]@{ $Kind.keys[0] = $registry.ClassOf($Path) }
}
