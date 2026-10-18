<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-FileLanguageFileMetaFact.ps1
    folder: private
    name: get-file-language-file-meta-fact
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
    test: automation/Catzc.Base.QualityGates/tests/Get-FileLanguageFileMetaFact.Tests.ps1
    cites:
      - ADR-PRIN-CONFIG#1
      - ADR-REPO-FILEMETA#3
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
