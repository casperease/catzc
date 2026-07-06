<#
.SYNOPSIS
    Renders the repository-root .gitignore content from the gitignore registry — the pretty-printer behind
    "what git ignores is declared, explained, and generated".
.DESCRIPTION
    Reads the zone registry (configs/gitignore.yml, via Get-Config -Config gitignore) and renders it to the
    full .gitignore text: a generated-file header naming the registry, then each zone as a titled comment
    block with its wrapped `why` explanation and its verbatim pattern lines (Format-GitIgnoreZone). A zone
    declaring `inject: <provider>` takes its patterns from -Inject at render time — the root-config zone is
    fed the registry's committed:false targets by Build-RootConfig, so the ignored-copies list lives in ONE
    place (rootconfig.yml) and .gitignore can never drift from it.

    This is a pure renderer: it returns the content and writes nothing — it is the `generator` the
    root-config registry names for the .gitignore target, and Build-RootConfig owns the write (through the
    same idempotent Write-FileIfChanged path as every managed file). It reads only its own registry, never
    rootconfig.yml, so Catzc.Base.Git carries no dependency on Catzc.Base.RootConfig (the composition edge
    runs the other way; see docs/adr/repository/generated-root-configs.md).
.PARAMETER Inject
    Render-time patterns per provider name (e.g. @{ 'rootconfig-committed-false' = '/.editorconfig', … }).
    Every `inject` provider the registry names must be supplied — an unknown provider throws; an empty list
    renders the zone titled but empty.
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
    $lines.Add('#   automation/Catzc.Base.Git/configs/gitignore.yml (zones; rendered by New-GitIgnore)')
    $lines.Add('#   automation/Catzc.Base.RootConfig/configs/rootconfig.yml (the injected managed-copies zone)')
    $lines.Add('# Regenerated on import by Build-RootConfig; committed, so a fresh clone ignores correctly from checkout.')

    foreach ($zone in $config.zones) {
        # Resolve the zone's patterns: static from the registry, or injected by the caller. An inject
        # provider the caller did not supply is a wiring defect — fail loudly, never render a silently
        # incomplete .gitignore.
        $patterns = if ($zone.inject) {
            if (-not $Inject.ContainsKey($zone.inject)) {
                throw "gitignore zone '$($zone.id)' names inject provider '$($zone.inject)', which the caller did not supply. Providers given: $(if ($Inject.Keys.Count) { $Inject.Keys -join ', ' } else { '(none)' })."
            }
            @(foreach ($injected in @($Inject[$zone.inject])) {
                    [pscustomobject]@{ pattern = [string] $injected; note = $null }
                })
        }
        else {
            @($zone.patterns)
        }

        $lines.Add('')
        foreach ($line in (Format-GitIgnoreZone -Title $zone.title -Why $zone.why -Pattern $patterns)) {
            $lines.Add($line)
        }
    }

    ($lines -join "`n") + "`n"
}
