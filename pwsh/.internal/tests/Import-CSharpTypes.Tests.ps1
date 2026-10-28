# cspell:ignore importcs dlllock  -- a fixture folder prefix and a skip reason, data
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '',
    Justification = 'Tests read $global:__CatzcDeferredTypes, the session-global pending record of the deferred types load')]
param()

Describe 'Import-CSharpTypes' -Tag 'L0' {
    BeforeAll {
        Import-Module (Join-Path (Get-CatzcModulesRoot) '.internal/Catzc.Internal.Bootstrap.psm1') -Force

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

        # The import writes the DLL and its manifest into its build directory (the mocked shadow root), named by the fixture's hash.
        function Get-FixtureManifest {
            param([string] $Root)
            Join-Path $script:shadowRoot "Catzc.Types.$((Get-CombinedTypeHash -ModulesRoot $Root).CombinedHash).json"
        }

        # A bundle ships the DLL beside its manifest in its own .compiled.
        function Copy-FixtureBundleBuild {
            param([string] $Root)
            $manifest = Get-FixtureManifest -Root $Root
            $compiled = [System.IO.Directory]::CreateDirectory((Join-Path $Root '.compiled')).FullName
            foreach ($source in $manifest, [System.IO.Path]::ChangeExtension($manifest, 'dll')) {
                [System.IO.File]::Copy($source, (Join-Path $compiled ([System.IO.Path]::GetFileName($source))))
            }
            Join-Path $compiled ([System.IO.Path]::GetFileName($manifest))
        }

        $script:contractFixtures = 0
        function New-ContractFixtureRoot {
            $script:contractFixtures++
            $namespace = "Catzc.WidgetContract$($script:contractFixtures)$runId"
            $repository = Join-Path $script:fixtureRoot ([guid]::NewGuid().ToString('N'))
            $modules = Join-Path $repository 'pwsh'
            [System.IO.Directory]::CreateDirectory((Join-Path $modules '.internal')) | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $modules '.internal/Catzc.Internal.Types.psm1'), '')
            [System.IO.Directory]::CreateDirectory((Join-Path $repository 'contracts/catzc')) | Out-Null
            $types = [System.IO.Directory]::CreateDirectory((Join-Path $modules "$namespace/types")).FullName
            [System.IO.File]::WriteAllText((Join-Path $types 'Widget.cs'), "namespace $namespace;`npublic class Widget { }")
            $modules
        }

        function Get-ContractFixturePath {
            param([string] $Root)
            $repository = [System.IO.Path]::GetDirectoryName($Root)
            $folder = [System.IO.Path]::GetFileName(@([System.IO.Directory]::GetDirectories($Root) | Where-Object { [System.IO.Path]::GetFileName($_) -like 'Catzc.*' })[0])
            Join-Path $repository (Get-TypesContractPath -RepositoryRoot $repository -Namespace $folder)
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
        Mock Get-TypesShadowRoot { $shadowRoot }.GetNewClosure() -ModuleName Catzc.Internal.Bootstrap
        $script:shadowRoot = $shadowRoot
        $script:originalTerminalProgram = $env:TERM_PROGRAM
        $env:TERM_PROGRAM = ''
    }

    AfterEach {
        $env:TERM_PROGRAM = $script:originalTerminalProgram
    }

    Context 'fixture' -Tag 'logic' {
        It 'compiles fresh modules, loads their types, and caches ONE combined DLL' -Tag 'L1' {
            $namespace = "WidgetTestA$runId"
            $root = New-FixtureRoot @{ $namespace = @{ Alpha = 'public class Alpha { }' } }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }

            ([System.Management.Automation.PSTypeName]"$namespace.Alpha").Type | Should -Not -BeNullOrEmpty
            [System.IO.Directory]::Exists((Join-Path $root '.compiled')) | Should -BeFalse -Because 'a source tree never holds a build'
            $manifest = Get-FixtureManifest -Root $root
            [System.IO.File]::Exists($manifest) | Should -BeTrue
            [System.IO.File]::Exists([System.IO.Path]::ChangeExtension($manifest, 'dll')) | Should -BeTrue
        }

        It 'compiles MULTIPLE sources in ONE module into ONE assembly (intra-module base + derived)' {
            $namespace = "WidgetTestB$runId"
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
            $baseNamespace = "WidgetTestBase$runId"
            $derivedNamespace = "WidgetTestDer$runId"
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
            $namespace = "WidgetTestZeta$runId"
            $root = New-FixtureRoot @{ $namespace = @{ Zeta = 'public class Zeta { }' } }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
            Should -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Bootstrap -ParameterFilter { $Message -like 'Built *' }
        }

        It 'writes the types manifest beside the DLL it builds' {
            $namespace = "WidgetTestManifest$runId"
            $root = New-FixtureRoot @{ $namespace = @{ Omega = 'public class Omega { }' } }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
            $manifest = Get-FixtureManifest -Root $root
            @(([System.IO.File]::ReadAllText($manifest) | ConvertFrom-Json).types.name) |
                Should -Be @("$namespace.Omega")
        }

        It 'restores a missing manifest beside a DLL that predates it' {
            $namespace = "WidgetTestRestore$runId"
            $root = New-FixtureRoot @{ $namespace = @{ Psi = 'public class Psi { }' } }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
            $manifest = Get-FixtureManifest -Root $root
            [System.IO.File]::Delete($manifest)
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
            [System.IO.File]::Exists($manifest) | Should -BeTrue
        }

        It 'rewrites a deleted or changed types contract on a cache-hit import' {
            $root = New-ContractFixtureRoot
            Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Internal.Bootstrap
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
            $contract = Get-ContractFixturePath -Root $root
            [System.IO.File]::Exists($contract) | Should -BeTrue -Because 'a compile writes the contract'
            $written = [System.IO.File]::ReadAllText($contract)

            [System.IO.File]::Delete($contract)
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
            [System.IO.File]::ReadAllText($contract) | Should -BeExactly $written
            Should -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Bootstrap -ParameterFilter { $Message -like 'Wrote the types contract*' } -Times 2 -Exactly

            [System.IO.File]::WriteAllText($contract, '{}')
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
            [System.IO.File]::ReadAllText($contract) | Should -BeExactly $written
        }

        It 'calls no Write-TypesContract on a cache-hit import whose contract matches its stamp' {
            $root = New-ContractFixtureRoot
            Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Internal.Bootstrap
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
            [System.IO.File]::Exists((Get-ContractFixturePath -Root $root)) | Should -BeTrue

            Mock Write-TypesContract { } -ModuleName Catzc.Internal.Types
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
            Should -Invoke Write-TypesContract -ModuleName Catzc.Internal.Types -Times 0 -Exactly
        }

        It 'throws for a bundle whose manifest is missing and never writes one' {
            $namespace = "WidgetTestBundle$runId"
            $root = New-FixtureRoot @{ $namespace = @{ Chi = 'public class Chi { }' } }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
            $manifest = Copy-FixtureBundleBuild -Root $root
            [System.IO.File]::Delete($manifest)
            { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R -PrebuiltOnly } } |
                Should -Throw '*missing its prebuilt types manifest*'
            [System.IO.File]::Exists($manifest) | Should -BeFalse
        }

        It 'verifies but does not load the types for a console host, and the first Initialize-Types loads them' {
            $namespace = "WidgetTestLazy$runId"
            $root = New-FixtureRoot @{ $namespace = @{ Lambda = 'public class Lambda { }' } }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R -HostKind console }

            ([System.Management.Automation.PSTypeName]"$namespace.Lambda").Type | Should -BeNullOrEmpty
            $entry = $global:__CatzcDeferredTypes[[System.IO.Path]::GetFullPath($root)]
            $entry.Loaded | Should -BeFalse
            [System.IO.Path]::GetDirectoryName($entry.Path) | Should -Be $script:shadowRoot

            Initialize-Types | Out-Null
            ([System.Management.Automation.PSTypeName]"$namespace.Lambda").Type | Should -Not -BeNullOrEmpty
            $entry.Loaded | Should -BeTrue
        }

        It 'defers a console bundle load too, from the prebuilt DLL and manifest, without compiling' {
            $namespace = "WidgetTestLazyBundle$runId"
            $root = New-FixtureRoot @{ $namespace = @{ Mu = 'public class Mu { }' } }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R -HostKind console }
            $dll = [System.IO.Path]::ChangeExtension((Copy-FixtureBundleBuild -Root $root), 'dll')
            $stamp = [System.IO.File]::GetLastWriteTimeUtc($dll)

            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R -HostKind console -PrebuiltOnly }

            [System.IO.File]::GetLastWriteTimeUtc($dll) | Should -Be $stamp
            ([System.Management.Automation.PSTypeName]"$namespace.Mu").Type | Should -BeNullOrEmpty
            $global:__CatzcDeferredTypes[[System.IO.Path]::GetFullPath($root)].Loaded | Should -BeFalse
            Initialize-Types | Out-Null
        }

        It 'stacks a changed build beside the loaded one up to the generations cap, then keeps the old types' {
            $namespace = "WidgetTestStack$runId"
            $root = New-FixtureRoot @{ $namespace = @{ Widget = 'public class Widget { }' } }
            $cap = @{ Generations = 2 }
            Mock Get-TypesLoadPolicy {
                [pscustomobject]@{ Cell = 'console.windows.source'; Engine = 'pwsh'; Load = 'eager'; Trigger = 'none'; EagerTypes = @(); ShadowCopy = $true; Generations = $cap.Generations }
            }.GetNewClosure() -ModuleName Catzc.Internal.Bootstrap
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R -HostKind console }
            $types = Join-Path $root "$namespace/types"

            [System.IO.File]::WriteAllText((Join-Path $types 'Gadget.cs'),
                "namespace $namespace;`npublic class Gadget { }")
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R -HostKind console }
            ([System.Management.Automation.PSTypeName]"$namespace.Gadget").Type | Should -Not -BeNullOrEmpty
            $global:__CatzcDeferredTypes[[System.IO.Path]::GetFullPath($root)].Generation | Should -Be 2
            Should -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Bootstrap -ParameterFilter { "$Message" -like 'Loaded changed types*build 2 of 2*' }

            [System.IO.File]::WriteAllText((Join-Path $types 'Gizmo.cs'),
                "namespace $namespace;`npublic class Gizmo { }")
            { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R -HostKind console } } |
                Should -Throw '*Restart PowerShell*'
            ([System.Management.Automation.PSTypeName]"$namespace.Gizmo").Type | Should -BeNullOrEmpty
        }

        It 'loads at import when the policy names an eager type, and refuses a name no module declares' {
            $namespace = "WidgetTestEager$runId"
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
            $namespace = "WidgetTestDelta$runId"
            $root = New-FixtureRoot @{ $namespace = @{ Delta = 'public class Delta { }' } }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
            { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R } } |
                Should -Not -Throw
        }

        It 'does not trip the changed-since-loaded guard on a pure CRLF/LF line-ending flip' {
            $namespace = "WidgetTestEol$runId"
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
            $namespaceA = "WidgetTestRootA$runId"
            $rootA = New-FixtureRoot @{ $namespaceA = @{ Apple = 'public class Apple { }' } }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $rootA } { param($R) Import-CSharpTypes -ModulesRoot $R }

            $namespaceB = "WidgetTestRootB$runId"
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

            $namespace = "WidgetTestEpsilon$runId"
            $root = New-FixtureRoot @{ $namespace = @{ Epsilon = 'public class Epsilon { }' } }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
            $dll = [System.IO.Path]::ChangeExtension((Get-FixtureManifest -Root $root), 'dll')
            $dll | Should -Not -BeNullOrEmpty

            Remove-Item $dll -Force                                  # types stay loaded; advisory lock on Unix allows this
            Test-Path $dll | Should -BeFalse

            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
            Test-Path $dll | Should -BeTrue                          # re-import rebuilt the committed artifact
        }

        It 'on a devbox, a source changed after load warns (yellow) and keeps the old types — no throw' {
            $savedTfBuild = $env:TF_BUILD
            $savedGitHubActions = $env:GITHUB_ACTIONS
            $env:TF_BUILD = ''
            $env:GITHUB_ACTIONS = ''
            try {
                $namespace = "WidgetTestGamma$runId"
                $root = New-FixtureRoot @{ $namespace = @{ Gamma = 'public class Gamma { }' } }
                InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
                [System.IO.File]::WriteAllText((Join-Path $root "$namespace/types/Gamma.cs"),
                    "namespace $namespace;`npublic class Gamma { public int X; }")
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
                $namespace = "WidgetTestGammaAdd$runId"
                $root = New-FixtureRoot @{ $namespace = @{ Gamma = 'public class Gamma { }' } }
                InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
                [System.IO.File]::WriteAllText((Join-Path $root "$namespace/types/Delta.cs"),
                    "namespace $namespace;`npublic class Delta { }")
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
                $namespace = "WidgetTestGammaCi$runId"   # fresh namespace: a type persists for the process, so the first import must load it clean
                $root = New-FixtureRoot @{ $namespace = @{ Gamma = 'public class Gamma { }' } }
                InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
                [System.IO.File]::WriteAllText((Join-Path $root "$namespace/types/Gamma.cs"),
                    "namespace $namespace;`npublic class Gamma { public int X; }")
                { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R } } |
                    Should -Throw '*changed since they were loaded*'
            }
            finally {
                $env:TF_BUILD = $savedTfBuild
            }
        }

        It 'inside VS Code, a source changed after load keeps the old types and names the loaded dll by hash — no throw' {
            $savedTfBuild = $env:TF_BUILD
            $savedGitHubActions = $env:GITHUB_ACTIONS
            $env:TF_BUILD = ''
            $env:GITHUB_ACTIONS = ''
            $env:TERM_PROGRAM = 'vscode'
            try {
                $namespace = "WidgetTestGammaCode$runId"
                $root = New-FixtureRoot @{ $namespace = @{ Gamma = 'public class Gamma { }' } }
                InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
                $loadedHash = (Get-Variable -Name '__CatzcTypes' -Scope Global -ValueOnly)[[System.IO.Path]::GetFullPath($root)].Hash
                [System.IO.File]::WriteAllText((Join-Path $root "$namespace/types/Gamma.cs"),
                    "namespace $namespace;`npublic class Gamma { public int X; }")
                { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R } } |
                    Should -Not -Throw
                Should -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Bootstrap -ParameterFilter {
                    $Message -like "Loaded inside VS Code with non-current types dll: $loadedHash *"
                }
                Should -Not -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Bootstrap -ParameterFilter { $Message -match 'Using the old C# types' }
                (Get-Variable -Name '__CatzcTypes' -Scope Global -ValueOnly)[[System.IO.Path]::GetFullPath($root)].Hash | Should -Be $loadedHash -Because 'the session keeps the loaded assembly and records no new hash'
            }
            finally {
                $env:TF_BUILD = $savedTfBuild
                $env:GITHUB_ACTIONS = $savedGitHubActions
            }
        }

        It 'inside VS Code, a type added after load is the same message, never a throw' {
            $savedTfBuild = $env:TF_BUILD
            $savedGitHubActions = $env:GITHUB_ACTIONS
            $env:TF_BUILD = ''
            $env:GITHUB_ACTIONS = ''
            $env:TERM_PROGRAM = 'vscode'
            try {
                $namespace = "WidgetTestGammaCodeAdd$runId"
                $root = New-FixtureRoot @{ $namespace = @{ Gamma = 'public class Gamma { }' } }
                InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
                [System.IO.File]::WriteAllText((Join-Path $root "$namespace/types/Delta.cs"),
                    "namespace $namespace;`npublic class Delta { }")
                { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R } } |
                    Should -Not -Throw
                Should -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Bootstrap -ParameterFilter { $Message -like 'Loaded inside VS Code with non-current types dll:*' }
            }
            finally {
                $env:TF_BUILD = $savedTfBuild
                $env:GITHUB_ACTIONS = $savedGitHubActions
            }
        }

        It 'in a pipeline run from a VS Code terminal, a source changed after load still throws (the pipeline wins)' {
            $savedTfBuild = $env:TF_BUILD
            $env:TF_BUILD = 'True'
            $env:TERM_PROGRAM = 'vscode'
            try {
                $namespace = "WidgetTestGammaCodeCi$runId"
                $root = New-FixtureRoot @{ $namespace = @{ Gamma = 'public class Gamma { }' } }
                InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R }
                [System.IO.File]::WriteAllText((Join-Path $root "$namespace/types/Gamma.cs"),
                    "namespace $namespace;`npublic class Gamma { public int X; }")
                { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R } } |
                    Should -Throw '*changed since they were loaded*'
            }
            finally {
                $env:TF_BUILD = $savedTfBuild
            }
        }

        It 'throws when a file does not produce the type named by its filename' {
            $namespace = "WidgetTestBeta$runId"
            # Beta.cs declares class Different, so the wrapped <module>.Beta is never produced.
            $root = New-FixtureRoot @{ $namespace = @{ Beta = 'public class Different { }' } }
            { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R } } |
                Should -Throw '*was not produced*'
        }

        It 'throws when a type file declares the WRONG namespace (not its module folder)' {
            $namespace = "WidgetTestNs$runId"
            $root = New-FixtureRoot @{ $namespace = @{ Widget = "namespace Other;`npublic class Widget { }" } }
            { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R } } |
                Should -Throw '*must declare*'
        }

        It 'throws when a type file uses a BLOCK-scoped namespace' {
            $namespace = "WidgetTestBlock$runId"
            # Block-scoped is not the shape this repo authors; the loader requires a file-scoped declaration.
            $root = New-FixtureRoot @{ $namespace = @{ Widget = "namespace $namespace { public class Widget { } }" } }
            { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R } } |
                Should -Throw '*block-scoped*'
        }

        It 'throws when a type file declares NO namespace' {
            $namespace = "WidgetTestNoNs$runId"
            $root = Join-Path $script:fixtureRoot ([guid]::NewGuid().ToString('N'))
            $typesDirectory = Join-Path (Join-Path $root $namespace) 'types'
            [System.IO.Directory]::CreateDirectory($typesDirectory) | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $typesDirectory 'Widget.cs'), 'public class Widget { }')
            { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R } } |
                Should -Throw '*declares no namespace*'
        }

        It 'throws when a type filename carries a dotted prefix' {
            $namespace = "WidgetTestDot$runId"
            # 'Other.Widget.cs' is the old fully-qualified style — the filename must be the bare type name only.
            $root = New-FixtureRoot @{ $namespace = @{ 'Other.Widget' = 'public class Widget { }' } }
            { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ R = $root } { param($R) Import-CSharpTypes -ModulesRoot $R } } |
                Should -Throw '*bare type only*'
        }
    }
}
