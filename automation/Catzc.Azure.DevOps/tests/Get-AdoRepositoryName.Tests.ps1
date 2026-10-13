Describe 'Get-AdoRepositoryName' -Tag 'L0', 'logic', 'ADR-AUTO-PSPARAM#4' {
    BeforeEach {
        $script:originalName = $env:BUILD_REPOSITORY_NAME
        $env:BUILD_REPOSITORY_NAME = $null
        Mock Get-RepositoryRoot { Join-Path $TestDrive 'widget-repository' } -ModuleName Catzc.Azure.DevOps
    }

    AfterEach {
        $env:BUILD_REPOSITORY_NAME = $script:originalName
    }

    It 'is the pipeline agent''s repository in a pipeline' {
        $env:BUILD_REPOSITORY_NAME = 'gadget-repository'
        Get-AdoRepositoryName | Should -Be 'gadget-repository'
    }

    It 'is the checkout folder''s name on a devbox' {
        Get-AdoRepositoryName | Should -Be 'widget-repository'
    }
}
