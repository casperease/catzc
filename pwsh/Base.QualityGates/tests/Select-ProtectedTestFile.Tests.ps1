Describe 'Select-ProtectedTestFile' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Get-ModuleProtectionIdentity -ModuleName Catzc.Base.QualityGates { 'identity' }

        function Select-Files {
            InModuleScope Catzc.Base.QualityGates {
                Select-ProtectedTestFile -ParallelFiles 'widget/tests/Get-Widget.Tests.ps1' -GreedyFiles 'gadget/tests/Get-Gadget.Tests.ps1' `
                    -SerialFiles 'widget/tests/Set-Widget.Tests.ps1' -Discovery ([pscustomobject]@{ Tests = @() }) -ProtectionKey 'widget-key'
            }
        }
    }

    It 'holds every input file unprotected in build mode and never computes an identity' {
        Mock Test-IsRunningInPipeline -ModuleName Catzc.Base.QualityGates { $false }
        Mock Get-CatzcRunMode -ModuleName Catzc.Base.QualityGates { 'build' }

        $result = Select-Files

        @($result.ParallelFiles) | Should -Be @('widget/tests/Get-Widget.Tests.ps1')
        @($result.GreedyFiles) | Should -Be @('gadget/tests/Get-Gadget.Tests.ps1')
        @($result.SerialFiles) | Should -Be @('widget/tests/Set-Widget.Tests.ps1')
        @($result.ProtectedModules).Count | Should -Be 0
        @($result.Candidates).Count | Should -Be 0
        Should -Invoke Get-ModuleProtectionIdentity -ModuleName Catzc.Base.QualityGates -Times 0
    }

    It 'holds every input file unprotected in a pipeline and never computes an identity' {
        Mock Test-IsRunningInPipeline -ModuleName Catzc.Base.QualityGates { $true }
        Mock Get-CatzcRunMode -ModuleName Catzc.Base.QualityGates { 'source' }

        $result = Select-Files

        @($result.ParallelFiles) | Should -Be @('widget/tests/Get-Widget.Tests.ps1')
        @($result.ProtectedModules).Count | Should -Be 0
        @($result.Candidates).Count | Should -Be 0
        Should -Invoke Get-ModuleProtectionIdentity -ModuleName Catzc.Base.QualityGates -Times 0
    }
}
