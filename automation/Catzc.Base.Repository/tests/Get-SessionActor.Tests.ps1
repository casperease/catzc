Describe 'Get-SessionActor' -Tag 'L0', 'logic', 'ADR-AUTO-TYPES#13' {
    It 'is a person when neither a pipeline nor an agent is detected' {
        Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Base.Repository
        Mock Test-IsRunningAsAgent { $false } -ModuleName Catzc.Base.Repository
        Get-SessionActor | Should -Be 'Person'
    }

    It 'is an agent when an agent is detected outside a pipeline' {
        Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Base.Repository
        Mock Test-IsRunningAsAgent { $true } -ModuleName Catzc.Base.Repository
        Get-SessionActor | Should -Be 'Agent'
    }

    It 'is a pipeline even when an agent runs it' {
        Mock Test-IsRunningInPipeline { $true } -ModuleName Catzc.Base.Repository
        Mock Test-IsRunningAsAgent { $true } -ModuleName Catzc.Base.Repository
        Get-SessionActor | Should -Be 'Pipeline'
    }
}
