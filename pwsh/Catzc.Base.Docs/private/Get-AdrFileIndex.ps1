<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Docs/private/Get-AdrFileIndex.ps1
    folder: private
    name: get-adr-file-index
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.Docs/tests/Get-AdrFileIndex.Tests.ps1
    docs: "[Get-AdrFileIndex.ps1.md](docs/references/pwsh/catzc-base-docs/private/Get-AdrFileIndex.ps1.md)"
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

    # A page belongs to the domain with the longest folder that holds it, so a domain folder nested in another domain's folder keeps its own pages.
    $folders = @($RuleSets.Folder | Sort-Object -Unique | Sort-Object -Property Length -Descending)
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
        foreach ($folder in $folders) {
            if ($relative.StartsWith("$folder/", [System.StringComparison]::Ordinal)) {
                $domainFolder = $folder
                break
            }
        }
        $key = "$domainFolder/$([System.IO.Path]::GetFileNameWithoutExtension($file))"
        if (-not $byKey.ContainsKey($key)) {
            $byKey[$key] = [System.Collections.Generic.List[string]]::new()
        }
        $byKey[$key].Add($relative)
    }

    $fileOf = @{}
    foreach ($ruleSet in $RuleSets) {
        $key = "$($ruleSet.Folder)/$($ruleSet.Slug)"
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
