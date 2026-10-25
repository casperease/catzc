Describe 'Set-GitTrackedPathMock' -Tag 'L0', 'logic', 'ADR-AUTO-TEST-PROCESSTRIPWIRE' {
    BeforeAll {
        Import-InternalModule TestKit
    }

    Context 'registered in a BeforeAll' {
        BeforeAll {
            Set-GitTrackedPathMock
        }

        It 'answers the Languages module''s git seam with nothing, launching no git' {
            $tracked = & (Get-Module Catzc.Base.Languages) { Get-GitTrackedPath -Path 'widgets/gadget.txt' }

            $tracked | Should -BeNullOrEmpty
            Should -Invoke Get-GitTrackedPath -ModuleName Catzc.Base.Languages -Times 1 -Exactly
        }
    }
}
