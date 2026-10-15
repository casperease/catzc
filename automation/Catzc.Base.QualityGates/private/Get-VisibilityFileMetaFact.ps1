# catzc:
#   path: automation/Catzc.Base.QualityGates/private/Get-VisibilityFileMetaFact.ps1
#   module: Catzc.Base.QualityGates
#   visibility: private

<#
.SYNOPSIS
    The visibility meta kind's fact: whether a module's function file is public or private, from its folder
    ([ADR-REPO-CODEMETA#2](/docs/adr/repository/code-file-meta.md#rule-adr-repo-codemeta2)).
.DESCRIPTION
    A file in the module's private folder is private, and any other file of the module is public.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-VisibilityFileMetaFact.ps1.md#comment1)
.PARAMETER State
    What the file's carrier reader returned.
.PARAMETER Path
    The file's repository-relative path.
.PARAMETER Kind
    The registry entry that subscribed this function.
.OUTPUTS
    [System.Collections.Specialized.OrderedDictionary] one entry per key of the kind.
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
