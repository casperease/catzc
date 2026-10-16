<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-FileLanguageFileMetaFact.ps1
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
      test: automation/Catzc.Base.QualityGates/tests/Get-FileLanguageFileMetaFact.Tests.ps1
    adrs:
      - ADR-PRIN-CONFIG#1
      - ADR-REPO-FILEMETA#3
  config:
    synopsis: 'The file-language meta kind''s fact: the file language of the file, from the languages registry.'
    description: |-
      The language is the one whose extensions list the file's own, as Get-FileLanguage reads it; the languages are data in the registry,
      never a list in this function ([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)). A file no
      language lists, such as a dotfile, gets an empty value, so the key is left out of its head.
    parameters:
      State: What Get-MarkdownMetaState read from the file.
      Path: The file's repository-relative path.
      Kind: The registry entry that subscribed this function.
    outputs: '[System.Collections.Specialized.OrderedDictionary] one entry per key of the kind.'
---
#>

function Get-FileLanguageFileMetaFact {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Every meta-kind processor is called with the same State, Path and Kind; this kind reads the language by path alone')]
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

    $language = (Get-Config -Config languages).ForPath($Path)
    $name = if ($language) {
        $language.name
    }
    else {
        ''
    }
    [ordered]@{ $Kind.keys[0] = $name }
}
