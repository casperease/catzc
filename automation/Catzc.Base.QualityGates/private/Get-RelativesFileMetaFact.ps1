<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-RelativesFileMetaFact.ps1
    kind: fact-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-PRIN-CONFIG#1
      - ADR-REPO-FILEMETA#10
  config:
    synopsis: 'The relatives meta kind''s fact: the few files a file points at, in static named slots, each only when it exists.'
    description: |-
      The kind's `slots` setting lists at most eight slots, each a name and rules; a rule applies to the files its `files` globs match and
      names candidate `paths`, and the first candidate that exists on disk becomes the slot's value. A path takes the tokens `{module}` (the
      folder under automation), `{name}` (the file name without its last extension), `{stem}` (the name without a trailing `.Tests`) and
      `{page}` (the file's comment page from comments.yml). A slot no rule fills is left out, so a file with no relatives carries no key.
    parameters:
      State: What the file's carrier reader returned.
      Path: The file's repository-relative path.
      Kind: The registry entry that subscribed this function.
    outputs: '[System.Collections.Specialized.OrderedDictionary] one entry per key of the kind, an ordered map of slot to path.'
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

    $maxSlots = 8
    $slots = if ($Kind.settings.ContainsKey('slots')) {
        @($Kind.settings['slots'])
    }
    else {
        @()
    }
    Assert-True ($slots.Count -le $maxSlots) -ErrorText "file-meta config: kind '$($Kind.id)' lists $($slots.Count) slots, at most $maxSlots are allowed."

    $root = Get-RepositoryRoot
    $name = [System.IO.Path]::GetFileNameWithoutExtension($Path)
    $tokens = @{
        '{name}' = $name
        '{stem}' = $name -replace '\.Tests$', ''
    }
    $moduleMatch = [regex]::Match($Path, '^automation/(?<module>[^/]+)/')
    $tokens['{module}'] = $moduleMatch.Groups['module'].Value

    $relatives = [ordered]@{}
    foreach ($slot in $slots) {
        Assert-True ($slot -is [System.Collections.IDictionary] -and $slot.Contains('name') -and $slot.Contains('rules')) `
            -ErrorText "file-meta config: kind '$($Kind.id)' settings.slots entries need 'name' and 'rules'."
        $found = $null
        foreach ($rule in @($slot['rules'])) {
            Assert-True ($rule -is [System.Collections.IDictionary] -and $rule.Contains('files') -and $rule.Contains('paths')) `
                -ErrorText "file-meta config: kind '$($Kind.id)' slot '$($slot['name'])' rules need 'files' and 'paths'."
            $applies = @($rule['files'] | Where-Object { [Catzc.Base.Globs.GlobPattern]::new($_).Matches($Path) })
            if ($applies.Count -eq 0) {
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
            $relatives["$($slot['name'])"] = $found
        }
    }
    [ordered]@{ $Kind.keys[0] = $relatives }
}
