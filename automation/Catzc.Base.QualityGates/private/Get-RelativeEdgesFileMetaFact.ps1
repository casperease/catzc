<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-RelativeEdgesFileMetaFact.ps1
    folder: private
    name: get-relative-edges-file-meta-fact
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
    test: automation/Catzc.Base.QualityGates/tests/Get-RelativeEdgesFileMetaFact.Tests.ps1
    cites:
      - ADR-PRIN-CONFIG#1
      - ADR-REPO-FILEMETA#10
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

    $maxRelations = 8
    $relations = if ($Kind.settings.ContainsKey('relations')) {
        @($Kind.settings['relations'])
    }
    else {
        @()
    }
    Assert-True ($relations.Count -le $maxRelations) `
        -ErrorText "file-meta config: kind '$($Kind.id)' lists $($relations.Count) relations, at most $maxRelations are allowed."

    $root = Get-RepositoryRoot
    $name = [System.IO.Path]::GetFileNameWithoutExtension($Path)
    $tokens = @{
        '{name}' = $name
        '{stem}' = $name -replace '\.Tests$', ''
    }
    $module = Get-PathModule $Path
    $tokens['{module}'] = $(if ($module) {
            $module.name
        }
        else {
            ''
        })

    $fileClass = (Get-FileKind $Path).Class
    $relatives = [ordered]@{}
    foreach ($key in $Kind.keys) {
        $relatives[$key] = ''
    }
    foreach ($relation in $relations) {
        Assert-True ($relation -is [System.Collections.IDictionary] -and $relation.Contains('name') -and $relation.Contains('rules')) `
            -ErrorText "file-meta config: kind '$($Kind.id)' settings.relations entries need 'name' and 'rules'."
        $found = $null
        foreach ($rule in @($relation['rules'])) {
            Assert-True ($rule -is [System.Collections.IDictionary] -and $rule.Contains('paths')) `
                -ErrorText "file-meta config: kind '$($Kind.id)' relation '$($relation['name'])' rules need 'paths', and 'classes' unless the rule applies to every class."
            # A rule without classes applies to every file the kind selects.
            if ($rule.Contains('classes') -and -not [Catzc.Base.QualityGates.FileMetaKind]::InClasses([string[]] @($rule['classes']), $fileClass)) {
                continue
            }
            foreach ($template in @($rule['paths'])) {
                $candidate = "$template"
                foreach ($token in $tokens.Keys) {
                    $candidate = $candidate.Replace($token, $tokens[$token])
                }
                if ($candidate.Contains('{page}')) {
                    $page = (Get-Config -Config comments).PageFor($Path)
                    if (-not $page) {
                        continue
                    }
                    $candidate = $candidate.Replace('{page}', $page)
                }
                if ([System.IO.File]::Exists((Join-Path $root $candidate))) {
                    $found = $candidate
                    break
                }
            }
            if ($found) {
                break
            }
        }
        if ($found) {
            Assert-True $relatives.Contains("$($relation['name'])") `
                -ErrorText "file-meta config: kind '$($Kind.id)' relation '$($relation['name'])' is not one of its keys [$($Kind.keys -join ', ')]."
            $relatives["$($relation['name'])"] = $found
        }
    }
    $relatives
}
