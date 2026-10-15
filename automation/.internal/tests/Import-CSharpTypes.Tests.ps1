<#
---
catzc:
  derived:
    path: automation/.internal/tests/Import-CSharpTypes.Tests.ps1
    kind: pester-test
    relatives:
      page: docs/references/automation/internal/tests/Import-CSharpTypes.Tests.ps1.md
    adrs:
      - ADR-PWSH-PESTER#9
---
#>

Describe 'Import-CSharpTypes' -Tag 'L0' {
    BeforeAll {
        Import-Module (Join-Path $env:RepositoryRoot 'automation/.internal/Catzc.Internal.Bootstrap.psm1') -Force

        $script:fixtureRoot = Join-Path ([System.IO.Path]::GetTempPath()) "importcs-$([guid]::NewGuid().ToString('N'))"

        $script:runId = 'r' + [guid]::NewGuid().ToString('N').Substring(0, 8)

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
        Mock Write-ImporterMessage { } -ModuleName Catzc.Internal.Bootstrap
        $shadowRoot = Join-Path $script:fixtureRoot 'shadow'
        Mock Get-TypesShadowRoot { $shadowRoot }.GetNewClosure() -ModuleName Catzc.Internal.Types
    }

    Context 'fixture' -Tag 'logic' {
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

        It 'writes the types manifest beside the DLL it builds' {
            $namespace = "CatzcTestManifest$runId"
            $root = New-FixtureRoot @{ $namespace = @{ Omega = 'public class Omega { }' } }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
            $manifests = @([System.IO.Directory]::EnumerateFiles((Join-Path $root '.compiled'), 'Catzc.Types.*.json'))
            $manifests.Count | Should -Be 1
            @(([System.IO.File]::ReadAllText($manifests[0]) | ConvertFrom-Json).types.name) | Should -Be @("$namespace.Omega")
        }

        It 'restores a missing manifest beside a DLL that predates it' {
            $namespace = "CatzcTestRestore$runId"
            $root = New-FixtureRoot @{ $namespace = @{ Psi = 'public class Psi { }' } }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
            $manifest = @([System.IO.Directory]::EnumerateFiles((Join-Path $root '.compiled'), 'Catzc.Types.*.json'))[0]
            [System.IO.File]::Delete($manifest)
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
            [System.IO.File]::Exists($manifest) | Should -BeTrue
        }

        It 'throws for a bundle whose manifest is missing and never writes one' {
            $namespace = "CatzcTestBundle$runId"
            $root = New-FixtureRoot @{ $namespace = @{ Chi = 'public class Chi { }' } }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
            $manifest = @([System.IO.Directory]::EnumerateFiles((Join-Path $root '.compiled'), 'Catzc.Types.*.json'))[0]
            [System.IO.File]::Delete($manifest)
            { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R -PrebuiltOnly } } |
                Should -Throw '*missing its prebuilt types manifest*'
            [System.IO.File]::Exists($manifest) | Should -BeFalse
        }

        It 'verifies but does not load the types for a console host, and the first Initialize-Types loads them' {
            $namespace = "CatzcTestLazy$runId"
            $root = New-FixtureRoot @{ $namespace = @{ Lambda = 'public class Lambda { }' } }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R -HostKind console }

            ([System.Management.Automation.PSTypeName]"$namespace.Lambda").Type | Should -BeNullOrEmpty
            @([System.IO.Directory]::EnumerateFiles((Join-Path $root '.compiled'), 'Catzc.Types.*.dll')).Count | Should -Be 1
            $entry = $global:__CatzcDeferredTypes[[System.IO.Path]::GetFullPath($root)]
            $entry.Loaded | Should -BeFalse
            [System.IO.Path]::GetDirectoryName($entry.Path) | Should -Be (Join-Path $root '.compiled')

            Initialize-Types | Out-Null
            ([System.Management.Automation.PSTypeName]"$namespace.Lambda").Type | Should -Not -BeNullOrEmpty
            $entry.Loaded | Should -BeTrue
        }

        It 'defers a console bundle load too, from the prebuilt DLL and manifest, without compiling' {
            $namespace = "CatzcTestLazyBundle$runId"
            $root = New-FixtureRoot @{ $namespace = @{ Mu = 'public class Mu { }' } }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R -HostKind console }
            $dll = @([System.IO.Directory]::EnumerateFiles((Join-Path $root '.compiled'), 'Catzc.Types.*.dll'))[0]
            $stamp = [System.IO.File]::GetLastWriteTimeUtc($dll)

            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R -HostKind console -PrebuiltOnly }

            [System.IO.File]::GetLastWriteTimeUtc($dll) | Should -Be $stamp
            ([System.Management.Automation.PSTypeName]"$namespace.Mu").Type | Should -BeNullOrEmpty
            $global:__CatzcDeferredTypes[[System.IO.Path]::GetFullPath($root)].Loaded | Should -BeFalse
            Initialize-Types | Out-Null
        }

        It 'loads at import when the policy names an eager type, and refuses a name no module declares' {
            $namespace = "CatzcTestEager$runId"
            $root = New-FixtureRoot @{ $namespace = @{ Nu = 'public class Nu { }' } }
            $eager = @{ Name = 'Nope.Missing' }
            Mock Get-TypesLoadPolicy {
                [pscustomobject]@{ Cell = 'console.windows.source'; Engine = 'pwsh'; Load = 'lazy'; Trigger = 'lookup-hook'; EagerTypes = @($eager.Name); ShadowCopy = $true }
            }.GetNewClosure() -ModuleName Catzc.Internal.Bootstrap

            { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R -HostKind console } } |
                Should -Throw '*eager type*Nope.Missing*'
            ([System.Management.Automation.PSTypeName]"$namespace.Nu").Type | Should -BeNullOrEmpty

            $eager.Name = "$namespace.Nu"
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R -HostKind console }
            ([System.Management.Automation.PSTypeName]"$namespace.Nu").Type | Should -Not -BeNullOrEmpty
        }

        It 'is a no-op when the types are already loaded with unchanged sources' {
            $namespace = "CatzcTestDelta$runId"
            $root = New-FixtureRoot @{ $namespace = @{ Delta = 'public class Delta { }' } }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
            { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R } } |
                Should -Not -Throw
        }

        It 'does not trip the changed-since-loaded guard on a pure CRLF/LF line-ending flip' {
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
                Should -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Bootstrap -ParameterFilter { $Message -match 'Using the old C# types' }
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
        BeforeAll {
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
            Should -Not -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Bootstrap -ParameterFilter { $Message -match 'Using the old C# types' }
            (Get-TypeRecord $rootB).Hash | Should -Be (Get-TypeRecord $rootA).Hash
        }

        It 'on a devbox, a differing digest warns naming the changed types, keeps the old types, and does not record' {
            $namespace = "CatzcTestSplit$runId"
            $rootA = New-FixtureRoot @{ $namespace = @{ Widget = 'public class Widget { }' } }
            $rootB = New-FixtureRoot @{ $namespace = @{ Widget = 'public class Widget { public int Gear; }' } }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $rootA } { param($R) Import-CSharpTypes -ModulesRoot $R }
            { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $rootB } { param($R) Import-CSharpTypes -ModulesRoot $R } } |
                Should -Not -Throw
            Should -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Bootstrap -ParameterFilter {
                $Message -like 'Using the old C# types*Widget*'
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
            Should -Not -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Bootstrap -ParameterFilter { $Message -match 'Using the old C# types' }
        }

        It 'a subset root after the full root reuses the loaded types (every needed digest matches)' {
            $namespace = "CatzcTestSuperset$runId"
            $rootA = New-FixtureRoot @{ $namespace = @{ Widget = 'public class Widget { }'; Gadget = 'public class Gadget { }' } }
            $rootB = New-FixtureRoot @{ $namespace = @{ Widget = 'public class Widget { }' } }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $rootA } { param($R) Import-CSharpTypes -ModulesRoot $R }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $rootB } { param($R) Import-CSharpTypes -ModulesRoot $R }
            Should -Not -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Bootstrap -ParameterFilter { $Message -match 'Using the old C# types' }
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
        if (-not (Get-Command Test-Formatting -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'harness_test_formatting'; return
        }
        Mock Format-Code -ModuleName Catzc.Base.QualityGates { }
        $result = Test-Formatting -Language csharp -PassThru -OutputFolder (Join-Path $TestDrive 'formatting')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}

Describe 'combined types assembly is committed and current' -Tag 'integrity' {
    BeforeAll {
        $script:currentHash = (Get-CombinedTypeHash (Join-Path $env:RepositoryRoot 'automation')).CombinedHash
    }

    It 'is exactly one committed assembly whose hash matches the current sources (Test-BuildArtifact)' -Tag 'L2', 'source-only' {
        if (-not (Get-Command git -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_git_missing'; return
        }
        $result = Test-BuildArtifact -Facet Types -PassThru -OutputFolder (Join-Path $TestDrive 'build-artifact')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }

    It 'the IDE project build stamps its version to the current committed hash (dotnet build)' -Tag 'L2' {
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
    It 'registers the [Catzc.Module.Depm] accelerator for the decorated enum' {
        [Catzc.Module.Depm].FullName | Should -Be 'Catzc.Base.ModuleSystem.ModuleDependencyFormat'
        [Catzc.Module.Depm]::Puml | Should -Be ([Catzc.Base.ModuleSystem.ModuleDependencyFormat]::Puml)
    }
}
