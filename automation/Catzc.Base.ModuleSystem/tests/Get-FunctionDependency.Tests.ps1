<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/tests/Get-FunctionDependency.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-modulesystem/tests/Get-FunctionDependency.Tests.ps1.md
---
#>

Describe 'Get-FunctionDependency' -Tag 'L0', 'integrity', 'source-only' {
    BeforeAll {
        $script:dependencies = Get-FunctionDependency
    }

    It 'CrossModule is true when CallerModule != TargetModule' {
        $violations = foreach ($dependency in $dependencies) {
            if ($dependency.CrossModule -and $dependency.CallerModule -eq $dependency.TargetModule) {
                $dependency
            }
        }
        @($violations) | Should -BeNullOrEmpty
    }
}

Describe 'Get-FunctionDependency — shared parse' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-InternalModule TestKit
        $script:fake = New-FakeRepositoryRoot -Modules @{
            'Catzc.Base.Widget' = @{ Files = @{ 'Get-Widget.ps1' = "function Get-Widget {`n    Get-Gadget`n}" } }
            'Catzc.Base.Gadget' = @{ Files = @{ 'Get-Gadget.ps1' = "function Get-Gadget {`n    'gadget'`n}" } }
        }
        Mock Assert-SourceTree -ModuleName Catzc.Base.ModuleSystem { }
    }

    AfterAll {
        Remove-FakeRepositoryRoot $script:fake
    }

    It 'parses each file once into the holder it is given' {
        $parsed = [Catzc.Base.Repository.ParsedScripts]::new()
        $edges = @(Get-FunctionDependency -AutomationRoot $script:fake.Automation -ParsedScripts $parsed)
        $parsed.ParseCount | Should -Be 2
        $edges | Should -HaveCount 1
        $edges[0].CallerFunction | Should -Be 'Get-Widget'
    }
}

Describe 'Get-FunctionDependency — build mode' -Tag 'L0', 'logic' {
    It 'stops with a named error when the session runs a built package' {
        Mock Get-CatzcRunMode { 'build' } -ModuleName Catzc.Base.Repository
        { Get-FunctionDependency -AutomationRoot $TestDrive } | Should -Throw '*Get-FunctionDependency operates on the catzc source tree*'
    }
}
