<#
---
catzc:
  derived:
    path: automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1
    kind: automation-function
    module: Catzc.Base.TypesSystem
    visibility: public
    adrs:
      - ADR-DSGN-RUNMODE
      - ADR-PWSH-PESTER#9
  config:
    synopsis: Compiles module-to-module edges from cross-module C# type references in types/*.cs.
    description: |-
      Every module's native types compile into ONE assembly (see Import-CSharpTypes), so the C# compiler no
      longer structurally forbids a type in one module referencing a type in another — including a layer
      inversion or a cycle. This scanner recovers that enforcement for the dependency graph: it reads each
      module's types/*.cs and reports an edge From -> To whenever a file references another module's namespace
      by fully-qualified name (e.g. Catzc.Azure.Templates referencing Catzc.Base.Objects.DictionaryRecord).

      Detection, made precise so Catzc.Azure is not confused with Catzc.Azure.Templates:

        1. The known module names (Get-AutomationModules) are also the known namespaces.
        2. Comments, string/char literals, and the file's own file-scoped namespace declaration are stripped
           first, so a token in a comment — or the module's own "namespace <module>;" line — never becomes an edge.
        3. Every dotted identifier is mapped to its LONGEST known-module-name prefix
           (Catzc.Azure.Templates.BicepTemplate -> Catzc.Azure.Templates; Catzc.Azure.SubCtx -> Catzc.Azure;
           System.String -> none). Self-references (target == the file's own module) and BCL tokens are dropped.

      These edges are folded into Get-ModuleDependencyViolations beside the function-call edges, so the same
      acyclic allow-list (configs/dependencies.yml, asserted by the L2 tests) governs C# type layering.

      Reads the per-module types/*.cs sources, which exist only in the source tree, so it stops with a named
      error in build mode (Assert-SourceTree, [ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)).
    parameters:
      AutomationRoot: Path to the automation directory. Defaults to the loaded code root (Get-CatzcModulesRoot).
    examples:
      - Get-CSharpTypeDependency
      - Get-CSharpTypeDependency | Where-Object { $_.From -eq 'Catzc.Azure.Templates' }
---
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

        # [System.IO] (sorted) instead of Get-ChildItem/Get-Content — ~20ms-per-call cmdlet overhead the raw.NET...
        # [comment:5](/docs/references/automation/catzc-base-typessystem/Get-CSharpTypeDependency.ps1.md#comment5)
        foreach ($cs in ([System.IO.Directory]::EnumerateFiles($typesDir, '*.cs') | Sort-Object)) {
            $csName = [System.IO.Path]::GetFileName($cs)
            # Strip block comments, line comments, then double- and single-quoted literals, so only real code tokens...
            # [comment:6](/docs/references/automation/catzc-base-typessystem/Get-CSharpTypeDependency.ps1.md#comment6)
            $code = [System.IO.File]::ReadAllText($cs)
            $code = [regex]::Replace($code, '(?s)/\*.*?\*/', ' ')
            $code = [regex]::Replace($code, '//[^\r\n]*', ' ')
            $code = [regex]::Replace($code, '"(?:\\.|[^"\\])*"', ' ')
            $code = [regex]::Replace($code, "'(?:\\.|[^'\\])*'", ' ')
            # Drop the file's own file-scoped namespace declaration ("namespace <module>;").
            # [comment:7](/docs/references/automation/catzc-base-typessystem/Get-CSharpTypeDependency.ps1.md#comment7)
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
