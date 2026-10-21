<#
---
catzc:
  immutable:
    with_body_sha: "4313800179f1"
  edges:
    docs: "[Get-RelativeEdgeCandidate.ps1.md](docs/references/pwsh/catzc-base-quality-gates/private/Get-RelativeEdgeCandidate.ps1.md)"
---
#>

function Get-RelativeEdgeCandidate {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Path,

        [Parameter(Mandatory)]
        [Catzc.Base.QualityGates.FileMetaKind] $Kind
    )

    $maxRelations = 8
    [object[]] $relations = @()
    if ($Kind.settings.ContainsKey('relations')) {
        $relations = @($Kind.settings['relations'])
    }
    Assert-True ($relations.Count -le $maxRelations) `
        -ErrorText "file-meta config: kind '$($Kind.id)' lists $($relations.Count) relations, at most $maxRelations are allowed."
    foreach ($relation in $relations) {
        Assert-True ($relation -is [System.Collections.IDictionary] -and $relation.Contains('name') -and $relation.Contains('rules')) `
            -ErrorText "file-meta config: kind '$($Kind.id)' settings.relations entries need 'name' and 'rules'."
        foreach ($rule in @($relation['rules'])) {
            Assert-True ($rule -is [System.Collections.IDictionary] -and $rule.Contains('paths')) `
                -ErrorText "file-meta config: kind '$($Kind.id)' relation '$($relation['name'])' rules need 'paths', and 'classes' unless the rule applies to every class."
        }
    }
    $commentPages = Get-Config -Config comment-pages

    foreach ($file in $Path) {
        $name = [System.IO.Path]::GetFileNameWithoutExtension($file)
        $tokens = @{
            '{name}' = $name
            '{stem}' = $name -replace '\.Tests$', ''
        }
        $fileClass = (Get-FileKind $file).Class
        foreach ($relation in $relations) {
            $paths = [System.Collections.Generic.List[string]]::new()
            foreach ($rule in @($relation['rules'])) {
                # A rule without classes applies to every file the kind selects.
                if ($rule.Contains('classes') -and -not [Catzc.Base.QualityGates.FileMetaKind]::InClasses([string[]] @($rule['classes']), $fileClass)) {
                    continue
                }
                foreach ($template in @($rule['paths'])) {
                    $candidate = "$template"
                    # The module is looked up only for a template that names it: most files match no rule that does.
                    if ($candidate.Contains('{module}') -and -not $tokens.ContainsKey('{module}')) {
                        $module = Get-PathModule $file
                        $tokens['{module}'] = $module ? $module.name : ''
                    }
                    foreach ($token in $tokens.Keys) {
                        $candidate = $candidate.Replace($token, $tokens[$token])
                    }
                    if ($candidate.Contains('{page}')) {
                        $page = Get-CommentPage -Path $file -Config $commentPages
                        if (-not $page) {
                            continue
                        }
                        $candidate = $candidate.Replace('{page}', $page)
                    }
                    $paths.Add($candidate)
                }
            }
            [pscustomobject]@{ Path = $file; Relation = $relation; Paths = [string[]] $paths.ToArray() }
        }
    }
}
