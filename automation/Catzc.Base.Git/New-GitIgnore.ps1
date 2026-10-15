<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Git/New-GitIgnore.ps1
    kind: function
    module: Catzc.Base.Git
    visibility: public
---
#>

<#
.SYNOPSIS
    Renders the repository-root .gitignore content from the gitignore registry — the pretty-printer behind
    "what git ignores is declared, explained, and generated".
.DESCRIPTION
    Never reads rootconfig.yml: the ignored-copies list arrives through -Inject, so .gitignore cannot drift from it.
    [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)
    [comment:1](/docs/references/automation/catzc-base-git/New-GitIgnore.ps1.md#comment1)
.PARAMETER Inject
    A provider the registry names but -Inject omits throws; an empty list gives a titled, empty section.
    [comment:2](/docs/references/automation/catzc-base-git/New-GitIgnore.ps1.md#comment2)
.OUTPUTS
    [string] The rendered .gitignore content (LF-joined; the writer canonicalises).
.EXAMPLE
    New-GitIgnore -Inject @{ 'rootconfig-committed-false' = @('/PSScriptAnalyzerSettings.psd1') }
#>
function New-GitIgnore {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [hashtable] $Inject = @{}
    )

    $config = Get-Config -Config gitignore

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('# GENERATED FILE — do not edit. Single source of truth:')
    $lines.Add('#   automation/Catzc.Base.Git/configs/gitignore.yml (sections; rendered by New-GitIgnore)')
    $lines.Add('#   automation/Catzc.Base.RootConfig/configs/rootconfig.yml (the injected managed-copies section)')
    $lines.Add('# Regenerated on import by Build-RootConfig; committed, so a fresh clone ignores correctly from checkout.')

    foreach ($section in $config.sections) {
        # A missing inject provider is a wiring defect, so it throws rather than render an incomplete .gitignore.
        # [comment:3](/docs/references/automation/catzc-base-git/New-GitIgnore.ps1.md#comment3)
        $patterns = if ($section.inject) {
            if (-not $Inject.ContainsKey($section.inject)) {
                throw "gitignore section '$($section.id)' names inject provider '$($section.inject)', which the caller did not supply. Providers given: $(if ($Inject.Keys.Count) { $Inject.Keys -join ', ' } else { '(none)' })."
            }
            @(foreach ($injected in @($Inject[$section.inject])) {
                    [pscustomobject]@{ pattern = [string] $injected; note = $null }
                })
        }
        else {
            @($section.patterns)
        }

        $lines.Add('')
        foreach ($line in (Format-GitIgnoreSection -Title $section.title -Why $section.why -Pattern $patterns)) {
            $lines.Add($line)
        }
    }

    ($lines -join "`n") + "`n"
}
