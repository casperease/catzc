<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-FileLanguageFileMetaFact.ps1
    folder: private
    name: get-file-language-file-meta-fact
    filetype: ps1
    role: function
    subkind: fact
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-FileLanguageFileMetaFact.Tests.ps1
    docs: "[Get-FileLanguageFileMetaFact.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-FileLanguageFileMetaFact.ps1.md)"
    cites:
      - ADR-PRIN-CONFIG-VARYINGBEHAVIOURISCONFIG
      - ADR-REPO-FILEMETA-IMPRINTEDPARTS
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
