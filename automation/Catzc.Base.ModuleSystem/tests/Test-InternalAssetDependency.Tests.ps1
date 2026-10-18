Describe 'Test-InternalAssetDependency' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        Mock Get-InternalAssetDependency -ModuleName Catzc.Base.ModuleSystem -ParameterFilter { $Violation } { }
        Mock Get-UncoveredInternalAssetDependency -ModuleName Catzc.Base.ModuleSystem { }
        $script:out = Join-Path $TestDrive 'out'
    }

    It 'passes when every call site is literal and every dependency is covered' {
        $result = Test-InternalAssetDependency -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
    }

    It 'throws once naming a non-literal call site and an uncovered function' {
        Mock Get-InternalAssetDependency -ModuleName Catzc.Base.ModuleSystem -ParameterFilter { $Violation } {
            [pscustomobject]@{ File = 'widgets/Widget/Get-Widget.ps1'; Line = 7; Function = 'Get-Widget'; Reason = '-ChildPath is not a string literal' }
        }
        Mock Get-UncoveredInternalAssetDependency -ModuleName Catzc.Base.ModuleSystem {
            [pscustomobject]@{ Module = 'Gadget'; Function = 'Get-Gadget'; ChildPath = @('assets/a.txt', 'assets/b.txt'); Reason = 'no test cites ADR-WIDGET-GADGET#3' }
        }
        $thrown = { Test-InternalAssetDependency -OutputFolder $out } | Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -BeLike 'Test-InternalAssetDependency failed: 2 issue(s)*'
        $message | Should -Match 'widgets/Widget/Get-Widget.ps1:7 Get-Widget: -ChildPath is not a string literal'
        $message | Should -Match 'Gadget/Get-Gadget \[assets/a.txt, assets/b.txt\]: no test cites'
    }

    It 'returns the issues under -PassThru instead of throwing' {
        Mock Get-UncoveredInternalAssetDependency -ModuleName Catzc.Base.ModuleSystem {
            [pscustomobject]@{ Module = 'Gadget'; Function = 'Get-Gadget'; ChildPath = @('.'); Reason = 'no test file' }
        }
        $result = Test-InternalAssetDependency -OutputFolder $out -PassThru
        $result.Subject | Should -Be 'internal-asset-dependency'
        $result.Issues | Should -HaveCount 1
    }
}
