<#
---
catzc:
  immutable:
    with_body_sha: "0564aecb10ea"
  edges:
    test: pwsh/Catzc.Base.Docs/tests/Get-GlossarySources.Tests.ps1
    docs: "[Get-GlossarySources.ps1.md](../../../docs/references/pwsh/catzc-base-docs/private/Get-GlossarySources.ps1.md)"
    cites:
      - ADR-CONF-LOADING-ONEREADER
      - ADR-REPO-VOCAB-GLOSSARYSOURCE
      - ADR-REPO-VOCAB-SOURCESINREPOSITORY
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
