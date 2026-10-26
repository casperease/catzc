<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-types-system/Get-CSharpTypeDependency.ps1.md"
  header: "generated"
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

    # Only a token that starts with a module name's first segment can name a module, so the scan leaves every other
    # dotted name unmatched.
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

        # The walker and System.IO over the cmdlets: at about 20 ms a call, the cmdlets dominate a scan of every type.
        foreach ($cs in [Catzc.Base.Folders.PathSet]::new((Get-Config -Config folder-walk)).AddPattern($typesDir,
            '*.cs', 1).ToArray()) {
            $csName = [System.IO.Path]::GetFileName($cs)
            # Comments and literals are stripped first, so only real code tokens count as references.
            $code = [System.IO.File]::ReadAllText($cs)
            # The file's own namespace names its own module, and would otherwise map to a shorter known module.
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
