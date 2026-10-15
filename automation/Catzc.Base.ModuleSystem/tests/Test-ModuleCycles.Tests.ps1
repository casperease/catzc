<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/tests/Test-ModuleCycles.Tests.ps1
    kind: pester-test
    relatives:
      page: docs/references/automation/catzc-base-modulesystem/tests/Test-ModuleCycles.Tests.ps1.md
      source: automation/Catzc.Base.ModuleSystem/Test-ModuleCycles.ps1
    adrs:
      - ADR-AUTO-TEST#3
---
#>

Describe 'Test-ModuleCycles' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        $script:out = Join-Path $TestDrive 'out'
    }

    It 'passes an acyclic graph and counts its modules and edges' {
        Mock Get-ModuleDependency -ModuleName Catzc.Base.ModuleSystem {
            [pscustomobject]@{ From = 'Widget'; To = 'Gadget' }
            [pscustomobject]@{ From = 'Gadget'; To = 'Sprocket' }
            [pscustomobject]@{ From = 'Widget'; To = 'Sprocket' }
        }
        $result = Test-ModuleCycles -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Modules | Should -Be 3
        $result.Edges | Should -Be 3
    }

    It 'throws once naming every module on a cycle or called from one' {
        Mock Get-ModuleDependency -ModuleName Catzc.Base.ModuleSystem {
            [pscustomobject]@{ From = 'Widget'; To = 'Gadget' }
            [pscustomobject]@{ From = 'Gadget'; To = 'Widget' }
            [pscustomobject]@{ From = 'Gadget'; To = 'Sprocket' }
        }
        $thrown = { Test-ModuleCycles -OutputFolder $out } | Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -BeLike 'Test-ModuleCycles failed: 3 issue(s)*'
        $message | Should -Match 'Gadget: on a dependency cycle, or called from one \(calls into Sprocket, Widget\)'
        $message | Should -Match 'Widget: on a dependency cycle, or called from one \(calls into Gadget\)'
        $message | Should -Match 'Sprocket: on a dependency cycle, or called from one'
    }

    It 'returns the issues under -PassThru instead of throwing' {
        Mock Get-ModuleDependency -ModuleName Catzc.Base.ModuleSystem {
            [pscustomobject]@{ From = 'Widget'; To = 'Gadget' }
            [pscustomobject]@{ From = 'Gadget'; To = 'Widget' }
        }
        $result = Test-ModuleCycles -OutputFolder $out -PassThru
        $result.Subject | Should -Be 'module-cycles'
        $result.Issues | Should -HaveCount 2
    }
}
