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
