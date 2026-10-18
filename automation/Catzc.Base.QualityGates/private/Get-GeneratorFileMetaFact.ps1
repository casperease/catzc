<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-GeneratorFileMetaFact.ps1
    folder: private
    name: get-generator-file-meta-fact
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
    test: automation/Catzc.Base.QualityGates/tests/Get-GeneratorFileMetaFact.Tests.ps1
    cites:
      - ADR-PRIN-CONFIG#1
      - ADR-REPO-FILEMETA#7
---
#>

function Get-GeneratorFileMetaFact {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Every meta-kind processor is called with the same State, Path and Kind; this kind names one writer for every file it selects')]
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

    if (-not $Kind.settings.ContainsKey('generator') -or [string]::IsNullOrWhiteSpace("$($Kind.settings['generator'])")) {
        throw "Get-GeneratorFileMetaFact: the kind '$($Kind.id)' needs a 'generator' setting, the path of the file that writes its files."
    }
    $normalized = "$($Kind.settings['generator'])" -replace '\\', '/'
    Assert-PathExist (Join-Path (Get-RepositoryRoot) $normalized) -PathType Leaf
    [ordered]@{ $Kind.keys[0] = $normalized }
}
