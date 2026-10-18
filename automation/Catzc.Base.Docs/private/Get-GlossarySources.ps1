<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1
    folder: private
    name: get-glossary-sources
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
    test: automation/Catzc.Base.Docs/tests/Get-GlossarySources.Tests.ps1
    cites:
      - ADR-CONF-LOADING#1
      - ADR-REPO-VOCAB#{2,3}
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
