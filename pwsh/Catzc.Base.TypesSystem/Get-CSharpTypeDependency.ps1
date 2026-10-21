<#
---
catzc:
  immutable:
    with_body_sha: "619c2f08d70f"
  edges:
    test: pwsh/Catzc.Base.TypesSystem/tests/Get-CSharpTypeDependency.Tests.ps1
    docs: "[Get-CSharpTypeDependency.ps1.md](docs/references/pwsh/catzc-base-typessystem/Get-CSharpTypeDependency.ps1.md)"
    cites:
      - ADR-DSGN-RUNMODE
      - ADR-PWSH-PESTER-SYSTEMIOONHOTPATHS
---
#>

function Get-CSharpTypeDependency {
    param(
        [string] $ModulesRoot = (Get-CatzcModulesRoot)
    )

    Assert-SourceTree
    Assert-PathExist $ModulesRoot -PathType Container

    $modules = @((Get-CatzcModule -EngineTrack).name)
    # Longest module name first, so 'Catzc.Azure.Templates.Foo' maps to Catzc.Azure.Templates, not Catzc.Azure.
    $byLength = @($modules | Sort-Object -Property Length -Descending)

    # Only a token that starts with a module name's first segment can name a module, so the scan leaves every other dotted name unmatched.
    $roots = @($modules | ForEach-Object { [regex]::Escape($_.Split('.')[0]) } | Sort-Object -Unique) -join '|'
    $dotted = [regex] "(?<![A-Za-z0-9_.])(?:$roots)(?:\.[A-Za-z_][A-Za-z0-9_]*)+"
    $edges = [ordered]@{}   # "From|To" -> List[string] of reference descriptions
    $targetOf = [System.Collections.Generic.Dictionary[string, string]]::new([System.StringComparer]::Ordinal)
    $target = $null

    foreach ($module in $modules) {
        $typesDir = Join-Path $ModulesRoot "$module/types"
        if (-not (Test-Path $typesDir -PathType Container)) {
            continue
        }

        foreach ($cs in ([System.IO.Directory]::EnumerateFiles($typesDir, '*.cs') | Sort-Object)) {
            $csName = [System.IO.Path]::GetFileName($cs)
            $code = [System.IO.File]::ReadAllText($cs)
            $code = [regex]::Replace($code, '(?s)/\*.*?\*/', ' ')
            $code = [regex]::Replace($code, '//[^\r\n]*', ' ')
            $code = [regex]::Replace($code, '"(?:\\.|[^"\\])*"', ' ')
            $code = [regex]::Replace($code, "'(?:\\.|[^'\\])*'", ' ')
            $code = [regex]::Replace($code, '(?m)^\s*namespace\s+[A-Za-z_][A-Za-z0-9_.]*\s*;\s*', ' ')

            $seen = [System.Collections.Generic.HashSet[string]]::new()
            foreach ($match in $dotted.Matches($code)) {
                $token = $match.Value
                # A token maps to its module once; the same BCL and cross-module names recur across every file.
                if (-not $targetOf.TryGetValue($token, [ref] $target)) {
                    $target = $null
                    foreach ($candidate in $byLength) {
                        if ($token.StartsWith("$candidate.", [System.StringComparison]::Ordinal)) {
                            $target = $candidate; break
                        }
                    }
                    $targetOf[$token] = $target
                }
                if (-not $target -or $target -eq $module) {
                    continue
                }   # BCL or own-module — not a cross-module edge
                if (-not $seen.Add("$csName|$token")) {
                    continue
                }   # de-dup identical refs within a file

                $key = "$module|$target"
                if (-not $edges.Contains($key)) {
                    $edges[$key] = [System.Collections.Generic.List[string]]::new()
                }
                $edges[$key].Add("$csName -> $token")
            }
        }
    }

    foreach ($key in $edges.Keys) {
        $parts = $key -split '\|', 2
        [PSCustomObject]@{
            From       = $parts[0]
            To         = $parts[1]
            References = $edges[$key].ToArray()
        }
    }
}
