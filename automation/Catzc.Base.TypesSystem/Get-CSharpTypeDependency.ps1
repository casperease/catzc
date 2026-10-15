<#
---
catzc:
  derived:
    path: automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1
    kind: function
    module: Catzc.Base.TypesSystem
    visibility: public
    adrs:
      - ADR-DSGN-RUNMODE
      - ADR-PWSH-PESTER#9
---
#>

<#
.SYNOPSIS
    Compiles module-to-module edges from cross-module C# type references in types/*.cs.
.DESCRIPTION
    One shared assembly means the compiler no longer forbids cross-module type references, so this scan does.
.PARAMETER AutomationRoot
    Path to the automation directory. Defaults to the loaded code root (Get-CatzcModulesRoot).
.EXAMPLE
    Get-CSharpTypeDependency
.EXAMPLE
    Get-CSharpTypeDependency | Where-Object { $_.From -eq 'Catzc.Azure.Templates' }
#>
function Get-CSharpTypeDependency {
    param(
        [string] $AutomationRoot = (Get-CatzcModulesRoot)
    )

    Assert-SourceTree
    Assert-PathExist $AutomationRoot -PathType Container

    $modules = @(Get-AutomationModules -AutomationRoot $AutomationRoot)
    # Longest module name first, so 'Catzc.Azure.Templates.Foo' maps to Catzc.Azure.Templates, not Catzc.Azure.
    $byLength = @($modules | Sort-Object -Property Length -Descending)

    $dotted = [regex] '[A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*)+'
    $edges = [ordered]@{}   # "From|To" -> List[string] of reference descriptions
    $targetOf = [System.Collections.Generic.Dictionary[string, string]]::new([System.StringComparer]::Ordinal)
    $target = $null

    foreach ($module in $modules) {
        $typesDir = Join-Path $AutomationRoot "$module/types"
        if (-not (Test-Path $typesDir -PathType Container)) {
            continue
        }

        # Raw .NET, not Get-ChildItem or Get-Content: each cmdlet call adds about 20ms of overhead.
        # [comment:2](/docs/references/automation/catzc-base-typessystem/Get-CSharpTypeDependency.ps1.md#comment2)
        foreach ($cs in ([System.IO.Directory]::EnumerateFiles($typesDir, '*.cs') | Sort-Object)) {
            $csName = [System.IO.Path]::GetFileName($cs)
            # A heuristic, but reliable here: references are fully qualified, with no using aliasing.
            # [comment:3](/docs/references/automation/catzc-base-typessystem/Get-CSharpTypeDependency.ps1.md#comment3)
            $code = [System.IO.File]::ReadAllText($cs)
            $code = [regex]::Replace($code, '(?s)/\*.*?\*/', ' ')
            $code = [regex]::Replace($code, '//[^\r\n]*', ' ')
            $code = [regex]::Replace($code, '"(?:\\.|[^"\\])*"', ' ')
            $code = [regex]::Replace($code, "'(?:\\.|[^'\\])*'", ' ')
            # Left in, a nested namespace would map to its parent module and fabricate a false edge to it.
            # [comment:4](/docs/references/automation/catzc-base-typessystem/Get-CSharpTypeDependency.ps1.md#comment4)
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
