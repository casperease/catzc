Describe 'Import-CSharpTypes' -Tag 'L0' {
    BeforeAll {
        Import-Module (Join-Path $env:RepositoryRoot 'automation/.internal/Catzc.Internal.Bootstrap.psm1') -Force

        # Fixtures live OUTSIDE TestDrive: Add-Type loads each compiled DLL into the process, so the file is
        # locked for the process lifetime and can never be deleted in-session. TestDrive's mandatory teardown
        # would fail on the lock; a self-managed temp dir lets us best-effort clean and leak only the DLL.
        $script:fixtureRoot = Join-Path ([System.IO.Path]::GetTempPath()) "importcs-$([guid]::NewGuid().ToString('N'))"

        # Per-run-unique module/type suffix. .NET types persist for the whole process, so a fixed name would
        # be already-loaded on a second test run in the same session — the loader would then take its no-op
        # branch and skip the compile. A fresh suffix per run keeps the "fresh type" precondition true.
        $script:runId = 'r' + [guid]::NewGuid().ToString('N').Substring(0, 8)

        # Writes a fixture MODULES ROOT: a fresh dir containing one subfolder per module in $Modules (keyed by
        # module name), each with types/<name>.cs for each entry in its value hashtable (keyed by the BARE type
        # name). Sources mirror shipped types: each declares its module's file-scoped namespace, which the loader
        # requires — so New-FixtureRoot auto-prepends "namespace <module>;" UNLESS the case already supplies a
        # namespace line (the negative tests ship a wrong/block-scoped one to exercise the gate). Returns the root
        # to pass as -ModulesRoot. Import-CSharpTypes writes the combined assembly to <root>/.compiled/.
        # [System.IO] rather than New-Item/Set-Content — ~0.1ms vs ~20ms/call
        # ([ADR-AUTO-TEST#18](/docs/adr/automation/test-automation.md#rule-adr-auto-test18)). WriteAllText writes the
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
        # Loads go through the per-user shadow copy (Import-TypesAssembly); keep the fixtures' copies out of the
        # real %LOCALAPPDATA%\catzc\types. Under fixtureRoot, not TestDrive: a loaded copy stays locked too.
        $shadowRoot = Join-Path $script:fixtureRoot 'shadow'
        Mock Get-TypesShadowRoot { $shadowRoot }.GetNewClosure() -ModuleName Catzc.Internal.Types
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
            # by the last root loaded, so the next real import after a test run threw on session-leaked
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

        It 'on a devbox, a type added after load is a hard throw (code using it cannot run on the old types)' {
            $savedTfBuild = $env:TF_BUILD
            $savedGitHubActions = $env:GITHUB_ACTIONS
            $env:TF_BUILD = ''
            $env:GITHUB_ACTIONS = ''
            try {
                $namespace = "CatzcTestGammaAdd$runId"
                $root = New-FixtureRoot @{ $namespace = @{ Gamma = 'public class Gamma { }' } }
                InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
                [System.IO.File]::WriteAllText((Join-Path $root "$namespace/types/Delta.cs"), "namespace $namespace;`npublic class Delta { }")
                { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R } } |
                    Should -Throw "*added $namespace/Delta*Restart PowerShell*"
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
            # loader rejects (the same invariant Test-Formatting checks). The explicit namespace bypasses auto-prepend.
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

    Context 'cross-root types guard' -Tag 'logic' {
        # The two run modes compile their DLLs from the same types/*.cs, so a root loading AFTER another root has
        # put the same type names in the AppDomain compares per-file digests against that root's record: equal
        # reuses, different (or a needed type missing) takes the stale-types contract and names both roots.
        BeforeAll {
            # The loader's per-root session record (the session-global __CatzcTypes), read without a $global:
            # reference: the record for <Root>, or $null when that root never recorded.
            function Get-TypeRecord {
                param([string] $Root)
                $records = Get-Variable -Name '__CatzcTypes' -Scope Global -ValueOnly
                $records[[System.IO.Path]::GetFullPath($Root)]
            }
        }

        BeforeEach {
            $script:savedTfBuild = $env:TF_BUILD
            $script:savedGitHubActions = $env:GITHUB_ACTIONS
            $env:TF_BUILD = ''
            $env:GITHUB_ACTIONS = ''
        }

        AfterEach {
            $env:TF_BUILD = $script:savedTfBuild
            $env:GITHUB_ACTIONS = $script:savedGitHubActions
        }

        It 'reuses the loaded types silently when every digest matches, and records the new root' {
            $namespace = "CatzcTestTwin$runId"
            $rootA = New-FixtureRoot @{ $namespace = @{ Widget = 'public class Widget { }' } }
            $rootB = New-FixtureRoot @{ $namespace = @{ Widget = 'public class Widget { }' } }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $rootA } { param($R) Import-CSharpTypes -ModulesRoot $R }
            { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $rootB } { param($R) Import-CSharpTypes -ModulesRoot $R } } |
                Should -Not -Throw
            Should -Not -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Bootstrap -ParameterFilter { $Message -match 'Using old cached C# types' }
            (Get-TypeRecord $rootB).Hash | Should -Be (Get-TypeRecord $rootA).Hash
        }

        It 'on a devbox, a differing digest warns naming both roots, keeps the old types, and does not record' {
            $namespace = "CatzcTestSplit$runId"
            $rootA = New-FixtureRoot @{ $namespace = @{ Widget = 'public class Widget { }' } }
            $rootB = New-FixtureRoot @{ $namespace = @{ Widget = 'public class Widget { public int Gear; }' } }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $rootA } { param($R) Import-CSharpTypes -ModulesRoot $R }
            { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $rootB } { param($R) Import-CSharpTypes -ModulesRoot $R } } |
                Should -Not -Throw
            Should -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Bootstrap -ParameterFilter {
                $Message -like "Using old cached C# types*already loaded from*$rootA*differ from*$rootB*changed $namespace/Widget*"
            }
            Get-TypeRecord $rootB | Should -BeNullOrEmpty
        }

        It 'in a pipeline, a differing digest is a hard throw naming both roots' {
            $env:TF_BUILD = 'True'
            $namespace = "CatzcTestSplitCi$runId"
            $rootA = New-FixtureRoot @{ $namespace = @{ Widget = 'public class Widget { }' } }
            $rootB = New-FixtureRoot @{ $namespace = @{ Widget = 'public class Widget { public int Gear; }' } }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $rootA } { param($R) Import-CSharpTypes -ModulesRoot $R }
            { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $rootB } { param($R) Import-CSharpTypes -ModulesRoot $R } } |
                Should -Throw "*already loaded from*$rootA*differ from*$rootB*"
        }

        It 'on a devbox, a type the second root needs but the AppDomain lacks (a subset loaded first) is a hard throw' {
            $namespace = "CatzcTestSubset$runId"
            $rootA = New-FixtureRoot @{ $namespace = @{ Widget = 'public class Widget { }' } }
            $rootB = New-FixtureRoot @{ $namespace = @{ Widget = 'public class Widget { }'; Gadget = 'public class Gadget { }' } }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $rootA } { param($R) Import-CSharpTypes -ModulesRoot $R }
            { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $rootB } { param($R) Import-CSharpTypes -ModulesRoot $R } } |
                Should -Throw "*not loaded $namespace/Gadget*Restart PowerShell*"
            Should -Not -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Bootstrap -ParameterFilter { $Message -match 'Using old cached C# types' }
        }

        It 'a subset root after the full root reuses the loaded types (every needed digest matches)' {
            $namespace = "CatzcTestSuperset$runId"
            $rootA = New-FixtureRoot @{ $namespace = @{ Widget = 'public class Widget { }'; Gadget = 'public class Gadget { }' } }
            $rootB = New-FixtureRoot @{ $namespace = @{ Widget = 'public class Widget { }' } }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $rootA } { param($R) Import-CSharpTypes -ModulesRoot $R }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $rootB } { param($R) Import-CSharpTypes -ModulesRoot $R }
            Should -Not -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Bootstrap -ParameterFilter { $Message -match 'Using old cached C# types' }
            Get-TypeRecord $rootB | Should -Not -BeNullOrEmpty
        }
    }
}

Describe 'shipped C# types' -Tag 'L0', 'integrity' {
    It 'every shipped C# type resolves after import (Test-ShippedTypes quality gate)' {
        $result = Test-ShippedTypes -PassThru -OutputFolder (Join-Path $TestDrive 'shipped-types')
        $result.Types | Should -BeGreaterThan 0 -Because 'the gate must find shipped C# type sources (no silent no-op)'
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }

    It 'every shipped C# type declares its module file-scoped namespace (Test-Formatting quality gate)' {
        # The loader enforces this at import (it throws on a missing/mismatched namespace); this asserts the same
        # invariant through Test-Formatting's Format-Types check, the authored quality gate, so a drift is a named
        # failure, not a load-time throw. The namespace rule is what this test is about, so the gate's layout engine
        # (dotnet format over every C# file, seconds of a real tool) stays out of it: the real engine's run over the
        # repository is the L2 integrity test in Test-Formatting.Tests.ps1.
        if (-not (Get-Command Test-Formatting -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'harness_test_formatting'; return
        }
        Mock Format-Code -ModuleName Catzc.Base.QualityGates { }
        $result = Test-Formatting -Language csharp -PassThru -OutputFolder (Join-Path $TestDrive 'formatting')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}

# Mixed tiers: the git-status drift guard and the dotnet-build stamp check drive CLIs (L2 — process startup
# well over the L0 limit), while the hash check is pure filesystem (L0). Tier is tagged per It.
Describe 'combined types assembly is committed and current' -Tag 'integrity' {
    BeforeAll {
        # The current combined hash comes from the ONE shared implementation (Get-CombinedTypeHash, loaded by the
        # importer that ran before this test file) — the same function the loader and the janitor call, so there is no
        # separate PowerShell mirror to keep in step. The independent oracle that would catch a bug IN that
        # function is the cross-language MSBuild stamp checked by the 'IDE project build stamps …' test below (a
        # genuinely separate C# implementation of the same hash; see native-csharp-types).
        $script:currentHash = (Get-CombinedTypeHash (Join-Path $env:RepositoryRoot 'automation')).CombinedHash
    }

    # Drift guard: the importer (which ran before this test file) rebuilds automation/.compiled/Catzc.Types.<hash>.dll
    # from source whenever a types/*.cs changed, and every build copies that DLL. Test-BuildArtifact's types facet
    # checks it is exactly one assembly named for the current sources' hash, with no pending git change (a
    # forgotten commit of the prebuilt assembly stays red until it is committed). source-only: it reads the
    # repository's own .compiled through the source tree.
    It 'is exactly one committed assembly whose hash matches the current sources (Test-BuildArtifact)' -Tag 'L2', 'source-only' {
        if (-not (Get-Command git -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_git_missing'; return
        }
        $result = Test-BuildArtifact -Facet Types -PassThru -OutputFolder (Join-Path $TestDrive 'build-artifact')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }

    # The IDE project (Catzc.Types.csproj) stamps its version from the committed .compiled DLL and FAILS its
    # build when that DLL is stale or missing (see native-csharp-types ADR). Drive the real dotnet build and
    # assert the deps.json project entry carries the CURRENT hash — so a drift between the committed assembly
    # and the stamp, or a broken stamping target, is caught automatically here rather than only at IDE-build
    # time. The stamping algorithm is a mirror of the loader's; this build proves it still agrees.
    It 'the IDE project build stamps its version to the current committed hash (dotnet build)' -Tag 'L2' {
        # Test-Tool, not Get-Command: a machine can carry the dotnet host with no SDK, and `dotnet build` needs the
        # SDK — Test-Tool probes the pinned version, which only an installed SDK answers (as Invoke-Dotnet's L2 does).
        if (-not (Test-Tool 'dotnet')) {
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

Describe 'Import-CSharpTypes — PSTypeAlias accelerators' -Tag 'L0', 'logic' {
    # A [Catzc.Base.Objects.PSTypeAlias("Name")] on a type publishes a PowerShell type-accelerator at load, so
    # [Name] resolves to it. This asserts the real registration on the shipped ModuleDependencyFormat (the
    # importer ran, and so registered it, before Pester started).
    It 'registers the [Catzc.Module.Depm] accelerator for the decorated enum' {
        [Catzc.Module.Depm].FullName | Should -Be 'Catzc.Base.ModuleSystem.ModuleDependencyFormat'
        [Catzc.Module.Depm]::Puml | Should -Be ([Catzc.Base.ModuleSystem.ModuleDependencyFormat]::Puml)
    }
}
