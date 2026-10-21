<#
---
catzc:
  immutable:
    with_body_sha: "8db7777429c3"
  edges:
    test: pwsh/Catzc.Base.Docs/tests/Get-CatsRuleEnforcers.Tests.ps1
    docs: "[Get-CatsRuleEnforcers.ps1.md](docs/references/pwsh/catzc-base-docs/private/Get-CatsRuleEnforcers.ps1.md)"
    cites:
      - ADR-AUTO-NOPWD-NOWORKINGDIRECTORYPATHS
      - ADR-CONF-LOADING-READINGISGLOBAL
      - ADR-PWSH-CACHE-STRICTSAFEPROBE
---
#>

function Get-CatsRuleEnforcers {
    [OutputType([hashtable])]
    [CmdletBinding()]
    param()

    # The test citations are read from the source tree's *.Tests.ps1 files, which a built package does not ship.
    Assert-SourceTree

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

    $form = (Get-Config -Config adrs).CodeForm
    $isCommand = { param($node) $node -is [System.Management.Automation.Language.CommandAst] }
    $isString = { param($node) $node -is [System.Management.Automation.Language.StringConstantExpressionAst] }
    $modulesRoot = Get-CatzcModulesRoot
    # Test files reach four levels below pwsh/ (module, tests, types, file); vendored modules are pruned by the walk.
    foreach ($file in Get-ChildPath $modulesRoot -File -Filter '*.Tests.ps1' -Depth 4 -PruneVendor $true) {
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
                if ($form.IsRule($string.Value)) {
                    & $ensure $string.Value
                    [void]$enforcers[$string.Value].Tests.Add($relative)
                }
            }
        }
    }

    $script:catsRuleEnforcersCache = $enforcers
    $enforcers
}
