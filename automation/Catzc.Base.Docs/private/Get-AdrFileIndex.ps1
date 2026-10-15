<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/private/Get-AdrFileIndex.ps1
    kind: function
    module: Catzc.Base.Docs
    visibility: private
---
#>

<#
.SYNOPSIS
    Indexes the markdown files under docs/adr/ by "<domain folder>/<slug>", and maps each rule set to its one ADR file.
.DESCRIPTION
    Keyed by domain folder plus slug, so a slug shared across domains stays distinct and a repeat shows as two files.
    [comment:1](/docs/references/automation/catzc-base-docs/private/Get-AdrFileIndex.ps1.md#comment1)
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
