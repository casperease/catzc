Describe 'Assert-CatzcSourceTree' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:originalModulesRoot = $env:CatzcModulesRoot
        $script:originalRepositoryRoot = $env:RepositoryRoot
        $script:originalModulesFolder = $env:CatzcModulesFolder
        $script:repositoryRoot = Join-Path $TestDrive 'widget-repo'
        [System.IO.Directory]::CreateDirectory((Join-Path $script:repositoryRoot 'gadgetry')) | Out-Null
    }
    AfterAll {
        $env:CatzcModulesRoot = $script:originalModulesRoot
        $env:RepositoryRoot = $script:originalRepositoryRoot
        $env:CatzcModulesFolder = $script:originalModulesFolder
    }
    BeforeEach {
        $env:RepositoryRoot = $script:repositoryRoot
        $env:CatzcModulesFolder = 'gadgetry'
    }

    It 'is silent in source mode' {
        $env:CatzcModulesRoot = Join-Path $script:repositoryRoot 'gadgetry'
        { Assert-CatzcSourceTree -Command 'Format-Widget' } | Should -Not -Throw
    }

    It 'throws in build mode, naming the tool and the loaded code root' {
        $env:CatzcModulesRoot = Join-Path $TestDrive 'built/Catzc/6.6.666'
        { Assert-CatzcSourceTree -Command 'Format-Widget' } |
            Should -Throw "*Format-Widget runs in catzc's source tree only*6.6.666*"
    }

    It 'names the calling command when no command is given' {
        $env:CatzcModulesRoot = Join-Path $TestDrive 'built/Catzc/6.6.666'
        function Invoke-Gadget {
            Assert-CatzcSourceTree
        }
        { Invoke-Gadget } | Should -Throw "*Invoke-Gadget runs in catzc's source tree only*"
    }
}
