<#
---
catzc:
  immutable:
    with_body_sha: "5d8dd1f20bb9"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-RelativeEdgesFileMetaFact.Tests.ps1
    docs: "[Get-RelativeEdgesFileMetaFact.ps1.md](../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-RelativeEdgesFileMetaFact.ps1.md)"
    cites:
      - ADR-REPO-FILEMETA-FEWLINKS
      - PDR-CONFIG-VARYINGBEHAVIOURISCONFIG
---
#>

function Get-RelativeEdgesFileMetaFact {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Every meta-kind processor is called with the same State, Path and Kind; this kind resolves by path and disk alone')]
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

    $root = Get-RepositoryRoot
    $relatives = [ordered]@{}
    foreach ($key in $Kind.keys) {
        $relatives[$key] = ''
    }
    # A relation's candidates come in rule order: the first one on disk is the relation's file.
    foreach ($entry in @(Get-RelativeEdgeCandidate -Path $Path -Kind $Kind)) {
        $relation = $entry.Relation
        $found = $null
        foreach ($candidate in $entry.Paths) {
            if ([System.IO.File]::Exists((Join-Path $root $candidate))) {
                $found = $candidate
                break
            }
        }
        if ($found) {
            Assert-True $relatives.Contains("$($relation['name'])") `
                -ErrorText "file-meta config: kind '$($Kind.id)' relation '$($relation['name'])' is not one of its keys [$($Kind.keys -join ', ')]."
            # A relation with a link template shows its file as a link: {path} is its repository-relative path, {relative_path} its path from the head's own folder.
            if ($relation.Contains('link')) {
                $from = [System.IO.Path]::GetDirectoryName((Join-Path $root $Path))
                $relativePath = [System.IO.Path]::GetRelativePath($from, (Join-Path $root $found)).Replace('\', '/')
                $found = "$($relation['link'])".Replace('{leaf}', [System.IO.Path]::GetFileName($found)).Replace('{relative_path}', $relativePath).Replace('{path}', $found)
            }
            $relatives["$($relation['name'])"] = $found
        }
    }
    $relatives
}
