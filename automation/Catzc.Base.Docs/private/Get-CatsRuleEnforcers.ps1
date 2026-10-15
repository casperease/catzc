<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1
    kind: function
    module: Catzc.Base.Docs
    visibility: private
---
#>

<#
.SYNOPSIS
    Maps each ADR rule citation to what mechanically enforces it — analyzer rules and tagged tests — for
    Show-Cats.
.DESCRIPTION
    Tags are read by parsing the AST, never by text scan, so a citation-shaped fixture string is not counted.
    [ADR-AUTO-NOPWD#1](/docs/adr/automation/never-depend-on-pwd.md#rule-adr-auto-nopwd1),
    [ADR-CONF-LOADING#6](/docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading6)
    [comment:1](/docs/references/automation/catzc-base-docs/private/Get-CatsRuleEnforcers.ps1.md#comment1)
.OUTPUTS
    [hashtable] citation ('#' form) -> [pscustomobject]{ Analyzers; Tests } (both sorted sets, possibly empty).
#>
function Get-CatsRuleEnforcers {
    [OutputType([hashtable])]
    [CmdletBinding()]
    param()

    # The test citations are read from the source tree's *.Tests.ps1 files, which a built package does not ship.
    Assert-SourceTree

    # Strict-clean probe: a plain read of the not-yet-created cache variable would throw under strict mode.
    # [ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4)
    # [comment:2](/docs/references/automation/catzc-base-docs/private/Get-CatsRuleEnforcers.ps1.md#comment2)
    $cached = $ExecutionContext.SessionState.PSVariable.GetValue('script:catsRuleEnforcersCache')
    if ($null -ne $cached) {
        return $cached
    }

    $enforcers = @{}
    $ensure = {
        param($id)
        if (-not $enforcers.ContainsKey($id)) {
            $enforcers[$id] = [pscustomobject]@{
                Analyzers = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
                Tests     = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
            }
        }
    }

    # Analyzer enforcers — the analyzer-adr-map (a global Get-Config read; it needs no dependency edge).
    $map = Get-Config -Config analyzer-adr-map
    foreach ($analyzer in $map.analyzers.Keys) {
        foreach ($id in $map.analyzers[$analyzer]) {
            & $ensure $id
            [void]$enforcers[$id].Analyzers.Add($analyzer)
        }
    }

    # Read by AST so a citation-shaped fixture string is never mistaken for a real Tag.
    # [comment:3](/docs/references/automation/catzc-base-docs/private/Get-CatsRuleEnforcers.ps1.md#comment3)
    $isCommand = { param($node) $node -is [System.Management.Automation.Language.CommandAst] }
    $isString = { param($node) $node -is [System.Management.Automation.Language.StringConstantExpressionAst] }
    $automationRoot = Resolve-RepoPath 'automation'
    foreach ($file in [System.IO.Directory]::EnumerateFiles($automationRoot, '*.Tests.ps1', [System.IO.SearchOption]::AllDirectories)) {
        if ($file -match '[\\/]\.vendor[\\/]') {
            continue
        }
        $tokens = $null
        $parseErrors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($file, [ref]$tokens, [ref]$parseErrors)
        $relative = ConvertTo-RepoRelativePath $file

        foreach ($command in $ast.FindAll($isCommand, $true)) {
            if ($command.GetCommandName() -notin 'Describe', 'Context', 'It') {
                continue
            }
            $elements = $command.CommandElements
            $tagValue = $null
            for ($i = 1; $i -lt $elements.Count; $i++) {
                $element = $elements[$i]
                if ($element -isnot [System.Management.Automation.Language.CommandParameterAst]) {
                    continue
                }
                if ($element.ParameterName -ine 'Tag') {
                    continue
                }
                $tagValue = if ($element.Argument) {
                    $element.Argument
                }
                elseif ($i + 1 -lt $elements.Count) {
                    $elements[$i + 1]
                }
                break
            }
            if (-not $tagValue) {
                continue
            }
            foreach ($string in $tagValue.FindAll($isString, $true)) {
                if ($string.Value -cmatch '^ADR-[A-Z]+(?:-[A-Z]+)*#\d+$') {
                    & $ensure $string.Value
                    [void]$enforcers[$string.Value].Tests.Add($relative)
                }
            }
        }
    }

    $script:catsRuleEnforcersCache = $enforcers
    $enforcers
}
