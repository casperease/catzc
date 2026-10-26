<#
---
catzc:
  docs: "../../../docs/references/pwsh/internal/tests/Import-CSharpTypes.CrossRoot.Tests.ps1.md"
  header: "generated"
---
#>

# cspell:ignore importcs dlllock  -- a fixture folder prefix and a skip reason, data
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '',
    Justification = 'Tests read $global:__CatzcDeferredTypes, the session-global pending record of the deferred types load')]
param()

Describe 'Import-CSharpTypes cross-root types guard' -Tag 'L0' {
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
        # A run from a VS Code terminal carries its mark; every case here is a plain devbox unless it sets the mark
        # itself.
        $script:originalTerminalProgram = $env:TERM_PROGRAM
        $env:TERM_PROGRAM = ''
    }

    AfterEach {
        $env:TERM_PROGRAM = $script:originalTerminalProgram
    }

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
