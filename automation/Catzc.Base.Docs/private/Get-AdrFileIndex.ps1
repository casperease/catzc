<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Docs/private/Get-AdrFileIndex.ps1
    folder: private
    name: get-adr-file-index
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.Docs/tests/Get-AdrFileIndex.Tests.ps1
---
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
    # An ADR sits at most three levels below docs/adr (domain, subfolder, file); the fourth level is headroom.
    foreach ($file in Get-ChildPath $AdrRoot -File -Filter '*.md' -Depth 4) {
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
