<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-RelativesFileMetaFact.ps1
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
      test: automation/Catzc.Base.QualityGates/tests/Get-RelativesFileMetaFact.Tests.ps1
    adrs:
      - ADR-PRIN-CONFIG#1
      - ADR-REPO-FILEMETA#10
  config:
    synopsis: 'The relatives meta kind''s fact: the few files a file points at, under fixed names, each only when it exists.'
    description: |-
      The kind's `relations` setting lists at most eight relations, each a name and rules; a rule applies to the
      files whose class its `classes` names (to every file when it names none) and names candidate `paths`, and the
      first candidate that exists on disk becomes the relation's value. A path takes the tokens `{module}` (the module the
      path is placed in, as Get-PathModule reads it), `{name}` (the file name without its last extension), `{stem}`
      (the name without a trailing `.Tests`) and `{page}` (the file's comment page from comments.yml). A relation no
      rule fills is left out, so a file with no relatives carries no key.
    parameters:
      State: What the file's carrier reader returned.
      Path: The file's repository-relative path.
      Kind: The registry entry that subscribed this function.
    outputs: '[System.Collections.Specialized.OrderedDictionary] one entry per key of the kind, an ordered map of relation name to path.'
---
#>

function Get-RelativesFileMetaFact {
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
            $relatives["$($relation['name'])"] = $found
        }
    }
    [ordered]@{ $Kind.keys[0] = $relatives }
}
