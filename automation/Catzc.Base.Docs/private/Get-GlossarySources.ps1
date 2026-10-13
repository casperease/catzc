<#
.SYNOPSIS
    Lists every glossary source — each opting-in module's configs/glossary.yml — with its validated config.
.DESCRIPTION
    A module opts into the controlled vocabulary by shipping configs/glossary.yml
    ([ADR-REPO-VOCAB#2](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab2)), so the
    sources are discovered, not declared: Get-Config -Config glossary -ListOwners lists every owner, and each
    source is read through Get-Config -Config glossary -Module <owner>, so the GlossaryConfig type validates its
    shape on load ([ADR-CONF-LOADING#1](/docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading1)/2). One
    git query then records whether each source file is tracked: a
    source lives in the repository
    ([ADR-REPO-VOCAB#3](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab3)), and
    Get-GlossarySourceViolations reports one that is not.

    Reads the source tree's configs and git, so it runs in source mode only (Assert-SourceTree). Private helper
    for Get-Glossary and the glossary checks; not exported.
.OUTPUTS
    [pscustomobject] One { Owner; Path; Config; Tracked } per source, sorted by owner (ordinal): Path is
    repo-relative, Config the source's Catzc.Base.Docs.GlossaryConfig, Tracked whether git tracks Path.
    Nothing when no module ships a glossary.
.EXAMPLE
    Get-GlossarySources | Format-Table Owner, Path, Tracked
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
