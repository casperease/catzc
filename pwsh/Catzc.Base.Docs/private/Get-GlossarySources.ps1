<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-docs/private/Get-GlossarySources.ps1.md"
  warning: "Generated Header"
---
#>

function Get-GlossarySources {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param()

    Assert-SourceTree

    $owners = @(Get-Config -Config glossary -ListOwners)
    if ($owners.Count -eq 0) {
        return
    }

    $paths = [string[]] @(foreach ($owner in $owners) {
            ConvertTo-RepoRelativePath $owner.Path
        })
    $tracked = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($path in @(Get-GitTrackedPath $paths)) {
        [void] $tracked.Add($path)
    }

    for ($i = 0; $i -lt $owners.Count; $i++) {
        [pscustomobject]@{
            Owner   = $owners[$i].Module
            Path    = $paths[$i]
            Config  = Get-Config -Config glossary -Module $owners[$i].Module
            Tracked = $tracked.Contains($paths[$i])
        }
    }
}
