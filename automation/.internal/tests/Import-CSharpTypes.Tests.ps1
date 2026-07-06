Describe 'Import-CSharpTypes' -Tag 'L0' {
    BeforeAll {
        Import-Module (Join-Path $env:RepositoryRoot 'automation/.internal/Catzc.Internal.Bootstrap.psm1') -Force

        # Fixtures live OUTSIDE TestDrive: Add-Type loads each compiled DLL into the process, so the file is
        # locked for the process lifetime and can never be deleted in-session. TestDrive's mandatory teardown
        # would fail on the lock; a self-managed temp dir lets us best-effort clean and leak only the DLL.
        $script:fixtureRoot = Join-Path ([System.IO.Path]::GetTempPath()) "importcs-$([guid]::NewGuid().ToString('N'))"

        # Per-run-unique module/type suffix. .NET types persist for the whole process, so a fixed name would
        # be already-loaded on a second suite run in the same session — the loader would then take its no-op
        # branch and skip the compile. A fresh suffix per run keeps the "fresh type" precondition true.
        $script:runId = 'r' + [guid]::NewGuid().ToString('N').Substring(0, 8)

        # Writes a fixture MODULES ROOT: a fresh dir containing one subfolder per module in $Modules (keyed by
        # module name), each with types/<name>.cs for each entry in its value hashtable (keyed by the BARE type
        # name). Sources mirror shipped types: each declares its module's file-scoped namespace, which the loader
        # requires — so New-FixtureRoot auto-prepends "namespace <module>;" UNLESS the case already supplies a
        # namespace line (the negative tests ship a wrong/block-scoped one to exercise the gate). Returns the root
        # to pass as -ModulesRoot. Import-CSharpTypes writes the combined assembly to <root>/.compiled/.
        # [System.IO] rather than New-Item/Set-Content — ~0.1ms vs ~20ms/call (ADR-TEST:18). WriteAllText writes the
        # string verbatim (no trailing newline appended); the auto-prepend uses LF, so a fixture's line endings
        # are exactly the source's bar that one leading line — the CRLF/LF-flip regression below relies on that.
        function New-FixtureRoot {
            param([hashtable] $Modules)
            $root = Join-Path $script:fixtureRoot ([guid]::NewGuid().ToString('N'))
            foreach ($moduleName in $Modules.Keys) {
                $typesDirectory = Join-Path (Join-Path $root $moduleName) 'types'
                [System.IO.Directory]::CreateDirectory($typesDirectory) | Out-Null
                foreach ($name in $Modules[$moduleName].Keys) {
                    $source = $Modules[$moduleName][$name]
                    if ($source -notmatch '(?m)^\s*namespace\b') {
                        $source = "namespace $moduleName;`n$source"
                    }
                    [System.IO.File]::WriteAllText((Join-Path $typesDirectory "$name.cs"), $source)
                }
            }
            $root
        }
    }

    AfterAll {
        # Best-effort: loaded DLLs stay locked (leak into temp, OS reclaims); everything else is removed.
        Remove-Item -Path $script:fixtureRoot -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Module Catzc.Internal.Bootstrap -Force -ErrorAction SilentlyContinue
    }

    BeforeEach {
        # The loader announces a real build via Write-ImporterMessage. Mock it so compile tests stay quiet,
        # and so the announce test can assert the call.
        Mock Write-ImporterMessage { } -ModuleName Catzc.Internal.Bootstrap
    }

    Context 'fixture' -Tag 'logic' {
        # L1: the first Add-Type in the file pays Roslyn's cold-start (~0.5s) on top of the compile itself;
        # the sibling compile tests run against a warm compiler and stay within the L0 budget.
        It 'compiles fresh modules, loads their types, and caches ONE combined DLL' -Tag 'L1' {
            $namespace = "CatzcTestA$runId"
            $root = New-FixtureRoot @{ $namespace = @{ Alpha = 'public class Alpha { }' } }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }

            ([System.Management.Automation.PSTypeName]"$namespace.Alpha").Type | Should -Not -BeNullOrEmpty
            $compiled = Join-Path $root '.compiled'
            @([System.IO.Directory]::EnumerateFiles($compiled, 'Catzc.Types.*.dll')).Count | Should -Be 1
        }

        It 'compiles MULTIPLE sources in ONE module into ONE assembly (intra-module base + derived)' {
            $namespace = "CatzcTestB$runId"
            $root = New-FixtureRoot @{
                $namespace = @{
                    Base  = 'public abstract class Base { public int Tag() { return 7; } }'
                    Thing = 'public sealed class Thing : Base { }'
                }
            }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }

            $thing = ([System.Management.Automation.PSTypeName]"$namespace.Thing").Type
            $thing | Should -Not -BeNullOrEmpty
            [Activator]::CreateInstance($thing).Tag() | Should -Be 7
        }

        It 'compiles types ACROSS modules into one assembly (cross-module base + derived)' {
            $baseNamespace = "CatzcTestBase$runId"
            $derivedNamespace = "CatzcTestDer$runId"
            $root = New-FixtureRoot @{
                $baseNamespace    = @{ Record = 'public abstract class Record { public int Tag() { return 9; } }' }
                $derivedNamespace = @{ Leaf = "public sealed class Leaf : $baseNamespace.Record { }" }
            }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }

            $leaf = ([System.Management.Automation.PSTypeName]"$derivedNamespace.Leaf").Type
            $leaf | Should -Not -BeNullOrEmpty
            # Inherits across modules — proves a type in one module resolved a base in another, in one assembly.
            [Activator]::CreateInstance($leaf).Tag() | Should -Be 9
        }

        It 'announces a real compile with a "Built ..." message' {
            $namespace = "CatzcTestZeta$runId"
            $root = New-FixtureRoot @{ $namespace = @{ Zeta = 'public class Zeta { }' } }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
            Should -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Bootstrap -ParameterFilter { $Message -like 'Built *' }
        }

        It 'is a no-op when the types are already loaded with unchanged sources' {
            $namespace = "CatzcTestDelta$runId"
            $root = New-FixtureRoot @{ $namespace = @{ Delta = 'public class Delta { }' } }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
            { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R } } |
                Should -Not -Throw
        }

        It 'does not trip the changed-since-loaded guard on a pure CRLF/LF line-ending flip' {
            # Regression: the combined hash is EOL-insensitive, so a checkout under git core.autocrlf (or an editor
            # re-saving the file) that flips line endings must NOT be mistaken for a source change. Before the fix
            # this threw '*changed since they were loaded*' even though the content was byte-identical bar EOLs.
            $namespace = "CatzcTestEol$runId"
            # Source carries an explicit CRLF so the flip below is a real line-ending change to neutralize.
            $root = New-FixtureRoot @{ $namespace = @{ Eta = "public class Eta {`r`n}" } }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }

            # Flip the line endings on disk without changing content (CRLF<->LF), as a rewriting checkout would.
            $file = Join-Path $root "$namespace/types/Eta.cs"
            $text = [System.IO.File]::ReadAllText($file)
            $flipped = if ($text.Contains("`r`n")) {
                $text -replace "`r`n", "`n"
            }
            else {
                $text -replace "`n", "`r`n"
            }
            [System.IO.File]::WriteAllText($file, $flipped)

            $threw = $null
            try {
                InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
            }
            catch {
                $threw = $_.Exception.Message
            }
            $threw | Should -BeNullOrEmpty -Because 'a pure CRLF/LF flip is not a source change'
        }

        It 'a load from a different ModulesRoot does not poison another root''s changed-since-loaded guard' {
            # Regression: the session guard is keyed by ModulesRoot. Loading root A, then a DIFFERENT root B
            # (this is exactly what the test-fixture trees do vs the real automation tree), must NOT make a
            # re-import of root A throw a bogus "types changed". Before the fix a single global was overwritten
            # by the last root loaded, so the next real import after the test suite ran threw on session-leaked
            # fixture state. Each root must track its own hash/snapshot.
            $namespaceA = "CatzcTestRootA$runId"
            $rootA = New-FixtureRoot @{ $namespaceA = @{ Apple = 'public class Apple { }' } }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $rootA } { param($R) Import-CSharpTypes -ModulesRoot $R }

            $namespaceB = "CatzcTestRootB$runId"
            $rootB = New-FixtureRoot @{ $namespaceB = @{ Pear = 'public class Pear { }' } }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $rootB } { param($R) Import-CSharpTypes -ModulesRoot $R }

            # Re-import root A (its types are still loaded). It compares against its OWN recorded hash, not B's.
            $threw = $null
            try {
                InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $rootA } { param($R) Import-CSharpTypes -ModulesRoot $R }
            }
            catch {
                $threw = $_.Exception.Message
            }
            $threw | Should -BeNullOrEmpty -Because 'each ModulesRoot tracks its own load state'
        }

        It 'recreates a deleted DLL on re-import even while the types are already loaded' {
            if ($IsWindows) {
                Set-ItResult -Skipped -Because 'windows_not_dlllock'; return
            }

            $namespace = "CatzcTestEpsilon$runId"
            $root = New-FixtureRoot @{ $namespace = @{ Epsilon = 'public class Epsilon { }' } }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
            $compiled = Join-Path $root '.compiled'
            $dll = [System.IO.Directory]::EnumerateFiles($compiled, 'Catzc.Types.*.dll') | Select-Object -First 1
            $dll | Should -Not -BeNullOrEmpty

            Remove-Item $dll -Force                                  # types stay loaded; advisory lock on Unix allows this
            Test-Path $dll | Should -BeFalse

            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
            Test-Path $dll | Should -BeTrue                          # re-import rebuilt the committed artifact
        }

        It 'on a devbox, a source changed after load warns (orange) and keeps the old types — no throw' {
            # A loaded assembly cannot be swapped in-process, but a devbox degrades gracefully: warn and keep the
            # already-loaded types this session. Clear BOTH pipeline env vars so this is the devbox path even in CI.
            $savedTfBuild = $env:TF_BUILD
            $savedGitHubActions = $env:GITHUB_ACTIONS
            $env:TF_BUILD = ''
            $env:GITHUB_ACTIONS = ''
            try {
                $namespace = "CatzcTestGamma$runId"
                $root = New-FixtureRoot @{ $namespace = @{ Gamma = 'public class Gamma { }' } }
                InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
                [System.IO.File]::WriteAllText((Join-Path $root "$namespace/types/Gamma.cs"), "namespace $namespace;`npublic class Gamma { public int X; }")
                { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R } } |
                    Should -Not -Throw
                Should -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Bootstrap -ParameterFilter { $Message -match 'Using old cached C# types' }
            }
            finally {
                $env:TF_BUILD = $savedTfBuild
                $env:GITHUB_ACTIONS = $savedGitHubActions
            }
        }

        It 'in a pipeline, a source changed after load is a hard throw (CI must not run on stale types)' {
            $savedTfBuild = $env:TF_BUILD
            $env:TF_BUILD = 'True'
            try {
                $namespace = "CatzcTestGammaCi$runId"   # fresh namespace: a type persists for the process, so the first import must load it clean
                $root = New-FixtureRoot @{ $namespace = @{ Gamma = 'public class Gamma { }' } }
                InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
                [System.IO.File]::WriteAllText((Join-Path $root "$namespace/types/Gamma.cs"), "namespace $namespace;`npublic class Gamma { public int X; }")
                { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R } } |
                    Should -Throw '*changed since they were loaded*'
            }
            finally {
                $env:TF_BUILD = $savedTfBuild
            }
        }

        It 'throws when a file does not produce the type named by its filename' {
            $namespace = "CatzcTestBeta$runId"
            # Beta.cs declares class Different, so the wrapped <module>.Beta is never produced.
            $root = New-FixtureRoot @{ $namespace = @{ Beta = 'public class Different { }' } }
            { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R } } |
                Should -Throw '*was not produced*'
        }

        It 'throws when a type file declares the WRONG namespace (not its module folder)' {
            $namespace = "CatzcTestNs$runId"
            # The source must declare its module's file-scoped namespace; a different one is the mismatch the
            # loader rejects (the same invariant Test-Types gates). The explicit namespace bypasses auto-prepend.
            $root = New-FixtureRoot @{ $namespace = @{ Widget = "namespace Other;`npublic class Widget { }" } }
            { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R } } |
                Should -Throw '*must declare*'
        }

        It 'throws when a type file uses a BLOCK-scoped namespace' {
            $namespace = "CatzcTestBlock$runId"
            # Block-scoped is not the shape this repo authors; the loader requires a file-scoped declaration.
            $root = New-FixtureRoot @{ $namespace = @{ Widget = "namespace $namespace { public class Widget { } }" } }
            { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R } } |
                Should -Throw '*block-scoped*'
        }

        It 'throws when a type file declares NO namespace' {
            $namespace = "CatzcTestNoNs$runId"
            # Bypass New-FixtureRoot's auto-prepend by writing the source directly, so the file genuinely lacks
            # a namespace — the loader must reject it rather than silently produce a type in the global namespace.
            $root = Join-Path $script:fixtureRoot ([guid]::NewGuid().ToString('N'))
            $typesDirectory = Join-Path (Join-Path $root $namespace) 'types'
            [System.IO.Directory]::CreateDirectory($typesDirectory) | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $typesDirectory 'Widget.cs'), 'public class Widget { }')
            { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R } } |
                Should -Throw '*declares no namespace*'
        }

        It 'throws when a type filename carries a dotted prefix' {
            $namespace = "CatzcTestDot$runId"
            # 'Other.Widget.cs' is the old fully-qualified style — the filename must be the bare type name only.
            $root = New-FixtureRoot @{ $namespace = @{ 'Other.Widget' = 'public class Widget { }' } }
            { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R } } |
                Should -Throw '*bare type only*'
        }

    } # end Context 'fixture'
}

Describe 'shipped C# types' -Tag 'L0', 'integrity' {
    BeforeAll {
        # Every shipped types/*.cs across all modules; its FQN is <module>.<basename> (the file is named for
        # the bare type and declares the module's file-scoped namespace). Scanned ONCE with [System.IO] (ADR-TEST:16/18)
        # instead of a BeforeDiscovery Get-ChildItem -Recurse feeding a per-type -ForEach.
        $automationRoot = Join-Path $env:RepositoryRoot 'automation'
        $script:shippedTypes = [System.Collections.Generic.List[string]]::new()
        foreach ($typesDirectory in [System.IO.Directory]::EnumerateDirectories($automationRoot, 'types', [System.IO.SearchOption]::AllDirectories)) {
            $moduleName = [System.IO.Path]::GetFileName([System.IO.Path]::GetDirectoryName($typesDirectory))
            if ($moduleName -match '^\.') {
                continue
            }
            foreach ($csharpFile in ([System.IO.Directory]::EnumerateFiles($typesDirectory, '*.cs') | Sort-Object)) {
                $script:shippedTypes.Add("$moduleName.$([System.IO.Path]::GetFileNameWithoutExtension($csharpFile))")
            }
        }
    }

    It 'found shipped C# type sources (guards against a silent no-op)' {
        $script:shippedTypes.Count | Should -BeGreaterThan 0
    }

    It 'every shipped C# type resolves after import' {
        $unresolved = @($script:shippedTypes | Where-Object { -not ([System.Management.Automation.PSTypeName]$_).Type })
        $unresolved | Should -BeNullOrEmpty -Because "these shipped types did not resolve after import:`n$($unresolved -join "`n")"
    }

    It 'every shipped C# type declares its module file-scoped namespace (Test-Types gate)' {
        # The loader enforces this at import (it throws on a missing/mismatched namespace); this asserts the same
        # invariant through Test-Types, the authored gate, so a drift is a named failure, not a load-time throw.
        if (-not (Get-Command Test-Types -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'harness_test_types'; return
        }
        $result = Test-Types -PassThru
        $result.ViolationCount | Should -Be 0 -Because "run Format-Types to fix:`n$($result.Violations -join "`n")"
    }
}

# Mixed tiers: the git-status drift guard and the dotnet-build stamp check drive CLIs (L2 — process startup
# well over the L0 limit), while the hash check is pure filesystem (L0). Tier is tagged per It.
Describe 'combined types assembly is committed and current' -Tag 'integrity' {
    BeforeAll {
        # The current combined hash comes from the ONE shared implementation (Get-CombinedTypeHash, loaded by the
        # importer that ran before this suite) — the same function the loader and the janitor call, so there is no
        # separate PowerShell mirror to keep in step. The independent oracle that would catch a bug IN that
        # function is the cross-language MSBuild stamp checked by the 'IDE project build stamps …' test below (a
        # genuinely separate C# implementation of the same hash; see native-csharp-types).
        $script:currentHash = (Get-CombinedTypeHash (Join-Path $env:RepositoryRoot 'automation')).CombinedHash
    }

    # Drift guard: the importer (which ran before this suite) rebuilds automation/.compiled/Catzc.Types.<hash>.dll
    # from source whenever a types/*.cs changed. If that rebuild was not committed, .compiled shows pending git
    # changes here — a forgotten commit of the prebuilt assembly. (Stays red until the rebuilt DLL is committed.)
    It 'has no pending git changes in automation/.compiled after import' -Tag 'L2' {
        if (-not (Get-Command git -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_git_missing'; return
        }
        $status = & git -C $env:RepositoryRoot status --porcelain -- automation/.compiled 2>$null
        $status | Should -BeNullOrEmpty -Because 'a rebuilt Catzc.Types.<hash>.dll must be committed — run the importer, then commit automation/.compiled/'
    }

    It 'is exactly one assembly whose hash matches the current sources' -Tag 'L0' {
        $compiledRoot = Join-Path $env:RepositoryRoot 'automation/.compiled'
        # @() wraps the whole if so a single match stays a one-element ARRAY (an @() inside the branch would be
        # unrolled to a scalar on assignment, and .Count then throws under StrictMode).
        $dlls = @(if ([System.IO.Directory]::Exists($compiledRoot)) {
                [System.IO.Directory]::EnumerateFiles($compiledRoot, 'Catzc.Types.*.dll')
            })
        $dlls.Count | Should -Be 1 -Because 'the janitor keeps exactly the current combined build'
        [System.IO.Path]::GetFileName($dlls[0]) | Should -Be "Catzc.Types.$currentHash.dll"
    }

    # The IDE project (Catzc.Types.csproj) stamps its version from the committed .compiled DLL and FAILS its
    # build when that DLL is stale or missing (see native-csharp-types ADR). Drive the real dotnet build and
    # assert the deps.json project entry carries the CURRENT hash — so a drift between the committed assembly
    # and the stamp, or a broken stamping target, is caught automatically here rather than only at IDE-build
    # time. The stamping algorithm is a mirror of the loader's; this build proves it still agrees.
    It 'the IDE project build stamps its version to the current committed hash (dotnet build)' -Tag 'L2' {
        if (-not (Get-Command dotnet -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_dotnet_missing'; return
        }
        $csproj = Join-Path $env:RepositoryRoot 'automation/.internal/assets/Catzc.Types.csproj'
        # Build to an isolated output dir so we read THIS run's deps.json and never race the default bin/.
        $outputDirectory = Join-Path $TestDrive 'stamp-build'
        $log = & dotnet build $csproj -c Debug --output $outputDirectory -v minimal 2>&1
        $LASTEXITCODE | Should -Be 0 -Because "dotnet build must succeed — the stamping target fails the build when the committed automation/.compiled/Catzc.Types.<hash>.dll is stale or missing:`n$($log -join "`n")"

        $dependencies = Get-Content (Join-Path $outputDirectory 'Catzc.Types.deps.json') -Raw | ConvertFrom-Json
        # The project library entry key is "<AssemblyName>/<Version>"; the stamp makes Version = 1.0.0-<hash>.
        $libraryNames = @($dependencies.libraries.PSObject.Properties.Name)
        $libraryNames | Should -Contain "Catzc.Types/1.0.0-$currentHash" -Because "the deps.json must stamp the current combined types hash, not the default 1.0.0:`n$($libraryNames -join "`n")"
    }
}

Describe 'DictionaryRecord (shared cross-module base)' -Tag 'L0', 'integrity' {
    BeforeAll {
        # A throwaway record deriving from the loaded Catzc.Base.Objects.DictionaryRecord — proves a type compiled
        # later (here, by Add-Type) can derive from the combined assembly's base, and exercises the dict view.
        if (-not ([System.Management.Automation.PSTypeName]'DictionaryRecordProbe').Type) {
            $assembly = [Catzc.Base.Objects.DictionaryRecord].Assembly.Location
            # Customer is never assigned -> genuinely null. (Passing $null from PowerShell would coerce to '',
            # the [string] $null->'' pitfall, so the constructor simply leaves it unset to test the null case.)
            Add-Type -ReferencedAssemblies $assembly -TypeDefinition @'
public sealed class DictionaryRecordProbe : Catzc.Base.Objects.DictionaryRecord {
    public string   Name { get; }
    public string   Customer { get; }
    public string[] Tags { get; }
    public DictionaryRecordProbe(string name, string[] tags) { Name = name; Tags = tags; }
}
'@
        }
    }

    It 'a shipped record derives from the cross-module base (BicepTemplate -> Catzc.Base.Objects.DictionaryRecord)' {
        [Catzc.Azure.Templates.BicepTemplate].BaseType.FullName | Should -Be 'Catzc.Base.Objects.DictionaryRecord'
    }

    It 'Contains is true for a non-null property, false for a null one, an unknown one, or a base member' {
        $record = [DictionaryRecordProbe]::new('a', @('x'))
        $record.Contains('Name') | Should -BeTrue
        $record.Contains('Customer') | Should -BeFalse   # null value -> treated as absent
        $record.Contains('Missing') | Should -BeFalse
        $record.Contains('Keys') | Should -BeFalse        # base view member, not a data property
    }

    It 'the indexer returns the property value (or null for an unknown key)' {
        $record = [DictionaryRecordProbe]::new('a', @())
        $record['Name'] | Should -Be 'a'
        $record['Nope'] | Should -BeNullOrEmpty
    }

    It 'Keys lists only non-null data properties' {
        $keys = @([DictionaryRecordProbe]::new('a', @('x')).Keys)
        $keys | Should -Contain 'Name'
        $keys | Should -Contain 'Tags'
        $keys | Should -Not -Contain 'Customer'   # null
        $keys | Should -Not -Contain 'Keys'        # base member
    }

    It 'ToHashtable carries non-null data props and excludes null props and base members' {
        $hashtable = [DictionaryRecordProbe]::new('a', @('x')).ToHashtable()
        $hashtable['Name'] | Should -Be 'a'
        $hashtable.ContainsKey('Customer') | Should -BeFalse   # null -> omitted
        $hashtable.ContainsKey('Keys') | Should -BeFalse        # base member
    }

    It 'the base Req helper is used by a derived record in another module' {
        # An empty dict is missing every required key — BicepTemplate's ctor calls the base Req, which throws.
        { [Catzc.Azure.Templates.BicepTemplate]::new(@{}) } | Should -Throw '*is required*'
    }
}

Describe 'Import-CSharpTypes — PSTypeAlias accelerators' -Tag 'L0', 'logic' {
    # A [Catzc.Base.Objects.PSTypeAlias("Name")] on a type publishes a PowerShell type-accelerator at load, so
    # [Name] resolves to it. This asserts the real registration on the shipped ModuleDependencyFormat (the
    # importer ran, and so registered it, before Pester started).
    It 'registers the [Catzc.Module.Depm] accelerator for the decorated enum' {
        [Catzc.Module.Depm].FullName | Should -Be 'Catzc.Base.ModuleSystem.ModuleDependencyFormat'
        [Catzc.Module.Depm]::Puml | Should -Be ([Catzc.Base.ModuleSystem.ModuleDependencyFormat]::Puml)
    }
}
