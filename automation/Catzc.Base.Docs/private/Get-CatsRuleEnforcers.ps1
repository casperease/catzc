<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1
    kind: automation-function
    module: Catzc.Base.Docs
    visibility: private
    adrs:
      - ADR-AUTO-NOPWD#1
      - ADR-CONF-LOADING#6
      - ADR-PWSH-CACHE#4
  config:
    synopsis: |-
      Maps each ADR rule citation to what mechanically enforces it — analyzer rules and tagged tests — for
      Show-Cats.
    description: |-
      Returns a hashtable keyed by rule citation in the '#' form (e.g. 'ADR-AUTO-NOPWD#1'), each value an object with
      two sorted sets: Analyzers (the PSScriptAnalyzer rules mapped to it in analyzer-adr-map.yml) and Tests (the
      repo-relative test files that cite it). Both sources run inside Test-Automation, so together they are what
      the rule-coverage report counts — this is the interactive, offline view of the same fact.

      The test citations are read by PARSING each test file's AST and taking only the `-Tag` arguments of
      Describe/Context/It — never a text scan, which would false-match a citation-shaped string in a fixture or
      an assertion. The analyzer map is read through Get-Config (a global config read; owned by the QualityGates
      module but reachable from anywhere —
      [ADR-CONF-LOADING#6](/docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading6) — so no module
      dependency on it is taken). A pure
      function of the files on disk, memoized for the session (re-run the importer to refresh). It reads the
      source tree's tests, so it runs in source mode only (Assert-SourceTree).

      Private helper for Show-Cats; not exported.
    outputs: '[hashtable] citation (''#'' form) -> [pscustomobject]{ Analyzers; Tests } (both sorted sets, possibly empty).'
---
#>

function Get-CatsRuleEnforcers {
    [OutputType([hashtable])]
    [CmdletBinding()]
    param()

    # The test citations are read from the source tree's *.Tests.ps1 files, which a built package does not ship.
    Assert-SourceTree

    # strict-clean
    # [comment:4](/docs/references/automation/catzc-base-docs/private/Get-CatsRuleEnforcers.ps1.md#comment4)
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

    # Test enforcers — the `-Tag` citations of Describe/Context/It, read by AST so a citation-shaped fixture string...
    # [comment:5](/docs/references/automation/catzc-base-docs/private/Get-CatsRuleEnforcers.ps1.md#comment5)
    $isCommand = { param($node) $node -is [System.Management.Automation.Language.CommandAst] }
    $isString = { param($node) $node -is [System.Management.Automation.Language.StringConstantExpressionAst] }
    $automationRoot = Resolve-RepoPath 'automation'
    # Test files reach four levels below automation (module, tests, types, file); vendored modules are pruned by the walk.
    foreach ($file in Get-ChildPath $automationRoot -File -Filter '*.Tests.ps1' -Depth 4 -PruneVendor $true) {
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
