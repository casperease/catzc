# These checks are a pure function of the files on disk (ADR-AUTO-TEST:16), so they SCAN THE TREE ONCE and assert
# invariants across the whole set, rather than spawning one Describe per file. The old shape generated ~175
# per-file `-ForEach` Describes (heavy discovery) and parsed every source file's AST TWICE (once per file for
# the one-function/name checks, once more for global uniqueness). Here a single BeforeAll enumerates with
# [System.IO] (ADR-AUTO-TEST:18) and parses each file exactly once into a rich observation; the It blocks assert facets
# of it (ADR-AUTO-TEST:20). A violation lists every offending file in one message.
Describe 'Source & test file conventions' -Tag 'L0', 'integrity' {
    BeforeAll {
        $automationRoot = Join-Path $env:RepositoryRoot 'automation'
        $isFunctionAst = { param($node) $node -is [System.Management.Automation.Language.FunctionDefinitionAst] }

        # Source files (module-root *.ps1 = public; private/*.ps1 except _* = private), parsed once each.
        # $script:sourceFiles: @{ Module; Path; BaseName; Functions = @(top-level function names) }
        # $script:definitions: function name -> list of '<Module>/<relative path>' that define it.
        $script:sourceFiles = [System.Collections.Generic.List[object]]::new()
        $script:testFiles = [System.Collections.Generic.List[object]]::new()
        $script:definitions = @{}
        $script:typeNames = @{}                                                  # '<Module>/<TypeName>' per types/*.cs
        $script:typeTestFiles = [System.Collections.Generic.List[object]]::new()  # tests/types/*.Tests.ps1

        foreach ($moduleDir in ([System.IO.Directory]::EnumerateDirectories($automationRoot) | Sort-Object)) {
            $module = [System.IO.Path]::GetFileName($moduleDir)

            # --- Source files: non-dot module dirs only ---
            if ($module -notmatch '^\.') {
                $paths = [System.Collections.Generic.List[string]]::new()
                foreach ($p in ([System.IO.Directory]::EnumerateFiles($moduleDir, '*.ps1') | Sort-Object)) {
                    if ($p -notlike '*.Tests.ps1') {
                        $paths.Add($p)
                    }   # module root = public
                }
                $privateDir = Join-Path $moduleDir 'private'
                if ([System.IO.Directory]::Exists($privateDir)) {
                    foreach ($p in ([System.IO.Directory]::EnumerateFiles($privateDir, '*.ps1') | Sort-Object)) {
                        if ([System.IO.Path]::GetFileName($p) -notlike '_*') {
                            $paths.Add($p)
                        }   # private/ (skip _*)
                    }
                }

                foreach ($path in $paths) {
                    $tokens = $null; $errors = $null
                    $ast = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$tokens, [ref]$errors)
                    $fns = @($ast.FindAll($isFunctionAst, $false) | Where-Object { $_.Parent.Parent -eq $ast })

                    $script:sourceFiles.Add([pscustomobject]@{
                            Module    = $module
                            Path      = $path
                            BaseName  = [System.IO.Path]::GetFileNameWithoutExtension($path)
                            Functions = @($fns | ForEach-Object { $_.Name })
                        })

                    $relative = $path.Substring($moduleDir.Length + 1) -replace '\\', '/'
                    foreach ($fn in $fns) {
                        if (-not $script:definitions.ContainsKey($fn.Name)) {
                            $script:definitions[$fn.Name] = [System.Collections.Generic.List[string]]::new()
                        }
                        $script:definitions[$fn.Name].Add("$module/$relative")
                    }
                }

                # --- C# type names (types/*.cs): the set a tests/types/ file must be named for ---
                $typesDir = Join-Path $moduleDir 'types'
                if ([System.IO.Directory]::Exists($typesDir)) {
                    foreach ($p in ([System.IO.Directory]::EnumerateFiles($typesDir, '*.cs') | Sort-Object)) {
                        $script:typeNames["$module/$([System.IO.Path]::GetFileNameWithoutExtension($p))"] = $true
                    }
                }
            }

            # --- Test files: every dir except .vendor / .scriptanalyzer, under tests/ ---
            if ($module -notin '.vendor', '.scriptanalyzer') {
                $testsDir = Join-Path $moduleDir 'tests'
                if ([System.IO.Directory]::Exists($testsDir)) {
                    # Direct children of tests/ are function tests (Verb-Noun, asserted below).
                    foreach ($p in ([System.IO.Directory]::EnumerateFiles($testsDir, '*.Tests.ps1') | Sort-Object)) {
                        $script:testFiles.Add([pscustomobject]@{
                                Module   = $module
                                BaseName = [System.IO.Path]::GetFileNameWithoutExtension($p)
                            })
                    }

                    # tests/types/ is the conventional home for native-type tests — named for their type
                    # (which has no verb), so they live here rather than under the Verb-Noun rule above.
                    $typesTestDir = Join-Path $testsDir 'types'
                    if ([System.IO.Directory]::Exists($typesTestDir)) {
                        foreach ($p in ([System.IO.Directory]::EnumerateFiles($typesTestDir, '*.Tests.ps1') | Sort-Object)) {
                            $script:typeTestFiles.Add([pscustomobject]@{
                                    Module   = $module
                                    BaseName = [System.IO.Path]::GetFileNameWithoutExtension($p)
                                })
                        }
                    }
                }
            }
        }

        # --- Skip-reason keys: every `Set-ItResult ... -Because '<literal>'` reason is a constrained key
        # (lowercase alnum segments joined by '_', e.g. <os>_<only|not>_<detail> or tool_<name>_missing),
        # never free prose, so the skip report groups by a stable vocabulary (see test-automation ADR). Only
        # static string-literal reasons are checkable; a variable reason (e.g. $script:skip) is computed at
        # runtime and cannot be verified statically.
        $script:skipReasons = [System.Collections.Generic.List[object]]::new()
        $isSetItResult = {
            param($node)
            $node -is [System.Management.Automation.Language.CommandAst] -and $node.GetCommandName() -eq 'Set-ItResult'
        }
        foreach ($tf in [System.IO.Directory]::EnumerateFiles($automationRoot, '*.Tests.ps1', [System.IO.SearchOption]::AllDirectories)) {
            if ($tf -match '[\\/]\.vendor[\\/]') {
                continue
            }
            $skipTokens = $null; $skipErrors = $null
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($tf, [ref]$skipTokens, [ref]$skipErrors)
            foreach ($call in $ast.FindAll($isSetItResult, $true)) {
                $els = $call.CommandElements
                for ($i = 1; $i -lt $els.Count; $i++) {
                    $el = $els[$i]
                    if ($el -isnot [System.Management.Automation.Language.CommandParameterAst] -or $el.ParameterName -ine 'Because') {
                        continue
                    }
                    $arg = $null
                    if ($el.Argument) {
                        $arg = $el.Argument
                    }
                    elseif ($i + 1 -lt $els.Count) {
                        $arg = $els[$i + 1]
                    }
                    if ($arg -is [System.Management.Automation.Language.StringConstantExpressionAst]) {
                        $script:skipReasons.Add([pscustomobject]@{
                                File   = ($tf.Substring($automationRoot.Length + 1) -replace '\\', '/')
                                Reason = $arg.Value
                            })
                    }
                    break
                }
            }
        }
    }

    It 'the scan found source and test files (guards the checks below against a silent no-op)' {
        # The convention assertions below pass vacuously on an empty set, so prove the scan actually
        # enumerated the tree — otherwise a broken enumeration would turn every check into a false green.
        $sourceFiles.Count | Should -BeGreaterThan 100
        $testFiles.Count | Should -BeGreaterThan 100
        $skipReasons.Count | Should -BeGreaterThan 10   # the Set-ItResult AST scan actually found skip reasons
    }

    It 'every source file is named Verb-Noun' {
        $bad = @($sourceFiles | Where-Object { $_.BaseName -notmatch '-' } | ForEach-Object { "$($_.Module)/$($_.BaseName).ps1" })
        $bad | Should -BeNullOrEmpty -Because "these source files are not Verb-Noun:`n$($bad -join "`n")"
    }

    It 'every source file contains exactly one top-level function' {
        $bad = @($sourceFiles | Where-Object { $_.Functions.Count -ne 1 } |
                ForEach-Object { "$($_.Module)/$($_.BaseName).ps1 (has $($_.Functions.Count))" })
        $bad | Should -BeNullOrEmpty -Because "these source files do not contain exactly one function:`n$($bad -join "`n")"
    }

    It 'every function name matches its file name' {
        $bad = @($sourceFiles | Where-Object { $_.Functions.Count -eq 1 -and $_.Functions[0] -ne $_.BaseName } |
                ForEach-Object { "$($_.Module)/$($_.BaseName).ps1 defines '$($_.Functions[0])'" })
        $bad | Should -BeNullOrEmpty -Because "these files define a function whose name does not match the file:`n$($bad -join "`n")"
    }

    It 'every test file is named Verb-Noun.Tests.ps1' {
        $bad = @($testFiles | Where-Object { ($_.BaseName -replace '\.Tests$') -notmatch '-' } |
                ForEach-Object { "$($_.Module)/tests/$($_.BaseName).ps1" })
        $bad | Should -BeNullOrEmpty -Because "these test files are not Verb-Noun.Tests.ps1:`n$($bad -join "`n")"
    }

    It 'every test under tests/types/ is named for a C# type in the module' {
        # tests/types/ is the conventional home for native-type tests; a type has no verb, so these are exempt
        # from Verb-Noun. Poka-yoke for that exemption: a file here MUST name a real types/*.cs in the module,
        # so the folder cannot collect mislocated or misnamed tests.
        $bad = @($typeTestFiles | Where-Object { -not $script:typeNames.ContainsKey("$($_.Module)/$($_.BaseName -replace '\.Tests$')") } |
                ForEach-Object { "$($_.Module)/tests/types/$($_.BaseName).ps1" })
        $bad | Should -BeNullOrEmpty -Because "tests/types/ holds only tests named for a C# type (matching types/*.cs):`n$($bad -join "`n")"
    }

    It 'every Set-ItResult skip reason is a constrained key, not free prose' {
        # A skip reason is a sortable vocabulary key, not a sentence, so the skip report groups by it.
        # Conventions: platform skips are <os>_<only|not>_<detail> (os = windows|unix); tool skips are
        # tool_<name>_missing. The grammar below enforces the alnum-key shape; see test-automation ADR.
        $skipKey = '^[a-z][a-z0-9]*(_[a-z0-9]+)+$'
        $bad = @($skipReasons | Where-Object { $_.Reason -cnotmatch $skipKey } |
                ForEach-Object { "$($_.File): '$($_.Reason)'" })
        $bad | Should -BeNullOrEmpty -Because "Set-ItResult -Because takes a constrained skip key, not prose (see docs/adr/automation/test-automation.md):`n$($bad -join "`n")"
    }

    It 'every function name (public and private) is defined in exactly one file' {
        $duplicates = foreach ($entry in $script:definitions.GetEnumerator()) {
            if ($entry.Value.Count -gt 1) {
                "$($entry.Key): $($entry.Value -join ', ')"
            }
        }
        $duplicates | Should -BeNullOrEmpty -Because "function names defined in more than one file:`n$(($duplicates | Sort-Object) -join "`n")"
    }
}

Describe 'Function dependencies' -Tag 'L2', 'integrity' {
    It 'has no unresolved function calls' {
        Test-FunctionDependency | Should -BeTrue
    }
}

Describe 'Module dependencies' -Tag 'L0', 'integrity' {
    BeforeAll {
        $script:edges = Get-ModuleDependency
    }

    It 'has no circular module dependencies' {
        # Collect all modules that participate in cross-module calls
        $adjacency = @{}
        $inDegree = @{}
        foreach ($edge in $edges) {
            if (-not $adjacency[$edge.From]) {
                $adjacency[$edge.From] = [System.Collections.Generic.List[string]]::new()
            }
            if (-not $adjacency[$edge.To]) {
                $adjacency[$edge.To] = [System.Collections.Generic.List[string]]::new()
            }
            $adjacency[$edge.From].Add($edge.To)
            if (-not $inDegree.ContainsKey($edge.From)) {
                $inDegree[$edge.From] = 0
            }
            if (-not $inDegree.ContainsKey($edge.To)) {
                $inDegree[$edge.To] = 0
            }
            $inDegree[$edge.To]++
        }

        # Kahn's algorithm — BFS topological sort
        $queue = [System.Collections.Generic.Queue[string]]::new()
        foreach ($mod in $inDegree.Keys) {
            if ($inDegree[$mod] -eq 0) {
                $queue.Enqueue($mod)
            }
        }

        $processed = 0
        while ($queue.Count -gt 0) {
            $current = $queue.Dequeue()
            $processed++
            foreach ($neighbor in $adjacency[$current]) {
                $inDegree[$neighbor]--
                if ($inDegree[$neighbor] -eq 0) {
                    $queue.Enqueue($neighbor)
                }
            }
        }

        $totalModules = $inDegree.Count
        $cycleModules = if ($processed -lt $totalModules) {
            ($inDegree.Keys | Where-Object { $inDegree[$_] -gt 0 }) -join ' <-> '
        }

        $processed | Should -Be $totalModules -Because "circular dependency detected: $cycleModules"
    }
}
