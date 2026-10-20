<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-VisibilityFileMetaFact.ps1
    folder: private
    name: get-visibility-file-meta-fact
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
    test: pwsh/Catzc.Base.QualityGates/tests/Get-VisibilityFileMetaFact.Tests.ps1
    docs: "[Get-VisibilityFileMetaFact.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-VisibilityFileMetaFact.ps1.md)"
    cites:
      - ADR-REPO-CODEMETA-COMPUTABLEFACTSONLY
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
        Get-CatzcModulesFolder
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
