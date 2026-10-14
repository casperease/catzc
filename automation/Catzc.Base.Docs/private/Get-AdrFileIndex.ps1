<#
.SYNOPSIS
    Indexes the markdown files under docs/adr/ by "<domain folder>/<slug>", and maps each rule set to its one ADR file.
.DESCRIPTION
    Enumerates every docs/adr/**/*.md once and keys it by its first folder under docs/adr/ (the domain folder; empty for a file at
    the root) and its file name without extension, so a slug shared across domains (one in automation/, one in research/) stays
    distinct and a slug repeated within one domain's subfolders shows as two files under one key. FileOf maps a rule set's External
    code to its file when exactly one file has its key; a rule set with none or several is a finding of the registry quality gate
    (Test-AdrRegistry), so the checks that read rule files skip it.

    Private helper for Test-AdrRegistry and Test-AdrEngineNeutrality; not exported.
.PARAMETER RuleSets
    The rule sets of the ADR registry (AdrsConfig.RuleSets).
.PARAMETER AdrRoot
    The absolute docs/adr/ folder.
.OUTPUTS
    [pscustomobject] { Root; Relative; ByKey; FileOf }: Relative lists every file's path under docs/adr/ ('/'-separated), ByKey maps
    each key to its list of relative paths, and FileOf maps an External code to its one relative path.
#>
function Get-AdrFileIndex {
    [OutputType([pscustomobject])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyCollection()]
        [Catzc.Base.Docs.AdrRuleSet[]] $RuleSets,

        [Parameter(Mandatory)]
        [string] $AdrRoot
    )

    Assert-PathExist $AdrRoot

    $relativePaths = [System.Collections.Generic.List[string]]::new()
    $byKey = @{}
    foreach ($file in [System.IO.Directory]::EnumerateFiles($AdrRoot, '*.md', [System.IO.SearchOption]::AllDirectories)) {
        $relative = $file.Substring($AdrRoot.Length).TrimStart('\', '/').Replace('\', '/')
        $relativePaths.Add($relative)
        $segments = $relative.Split('/')
        $domainFolder = if ($segments.Count -gt 1) {
            $segments[0]
        }
        else {
            ''
        }
        $key = "$domainFolder/$([System.IO.Path]::GetFileNameWithoutExtension($file))"
        if (-not $byKey.ContainsKey($key)) {
            $byKey[$key] = [System.Collections.Generic.List[string]]::new()
        }
        $byKey[$key].Add($relative)
    }

    $fileOf = @{}
    foreach ($ruleSet in $RuleSets) {
        $key = "$($ruleSet.Domain)/$($ruleSet.Slug)"
        if ($byKey.ContainsKey($key) -and $byKey[$key].Count -eq 1) {
            $fileOf[$ruleSet.External] = $byKey[$key][0]
        }
    }

    [pscustomobject]@{
        Root     = $AdrRoot
        Relative = [string[]] @($relativePaths)
        ByKey    = $byKey
        FileOf   = $fileOf
    }
}
