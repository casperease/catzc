<#
.SYNOPSIS
    Validates configs/analyzer-adr-map.yml and throws with all violations collected.
.DESCRIPTION
    Required shape:
      analyzers: map; <analyzer rule name> -> non-empty list of ADR-<CODE>#<n> citations

    Checks only SHAPE and citation GRAMMAR — that 'analyzers' exists and is non-empty, that every rule name is
    non-empty, that every rule maps to at least one id, and that each id is a well-formed 'ADR-<CODE>#<n>'. It
    does NOT check that each id names a real rule, nor that every custom analyzer is mapped: those cross-asset
    facts are enforced by an integrity test, not at load, so loading this config never reads the ADR tree or
    the .scriptanalyzer folder (the ADR-CUSTOMER:3 pattern — keep config load hermetic).

    Auto-dispatched by Get-Config when loading the 'analyzer-adr-map' config.
#>
function Assert-AnalyzerAdrMapConfig {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Config
    )

    if (-not $Config.Contains('analyzers')) {
        throw "analyzer-adr-map configuration validation failed:`nMissing required top-level key: 'analyzers'"
    }

    $errors = [System.Collections.Generic.List[string]]::new()

    $ruleNames = @($Config.analyzers.Keys)
    if ($ruleNames.Count -eq 0) {
        $errors.Add('analyzers is empty')
    }

    foreach ($rule in $ruleNames) {
        if ([string]::IsNullOrWhiteSpace($rule)) {
            $errors.Add('an analyzer rule name is empty')
            continue
        }
        $ids = @($Config.analyzers[$rule])
        if ($ids.Count -eq 0) {
            $errors.Add("analyzer '$rule' maps to no ADR rule (want a non-empty list of ADR-<CODE>#<n>)")
            continue
        }
        foreach ($id in $ids) {
            if ($id -cnotmatch '^ADR-[A-Z]+#\d+$') {
                $errors.Add("analyzer '$rule' has a malformed citation '$id' (want ADR-<CODE>#<n>, e.g. ADR-ERROR#3)")
            }
        }
    }

    if ($errors.Count -gt 0) {
        throw "analyzer-adr-map configuration validation failed:`n$($errors -join "`n")"
    }
}
