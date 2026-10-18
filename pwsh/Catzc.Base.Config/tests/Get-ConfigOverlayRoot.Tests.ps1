Describe 'Get-ConfigOverlayRoot' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:originalRepositoryRoot = $env:RepositoryRoot
        $script:run = { & (Get-Module Catzc.Base.Config) { Get-ConfigOverlayRoot } }
        foreach ($consumer in 'widget-consumer', 'gadget-consumer') {
            [System.IO.Directory]::CreateDirectory((Join-Path $TestDrive $consumer)) | Out-Null
        }
    }
    AfterAll {
        $env:RepositoryRoot = $script:originalRepositoryRoot
        & (Get-Module Catzc.Base.Config) { $script:configOverlayAnchors = $null }
    }

    BeforeEach {
        & (Get-Module Catzc.Base.Config) { $script:configOverlayAnchors = $null }
        Mock Get-CatzcOverlayRoot -ModuleName Catzc.Base.Config -MockWith { "overlay-of:$env:RepositoryRoot" }
        Mock Get-CatzcRunMode -ModuleName Catzc.Base.Config -MockWith { 'build' }
    }

    Context 'source mode reads this repository''s own config fragments only' -Tag 'ADR-PRIN-CATS-FOLDERSUSECATZC' {
        BeforeEach {
            Mock Get-CatzcRunMode -ModuleName Catzc.Base.Config -MockWith { 'source' }
            Mock Get-CatzcModulesRoot -ModuleName Catzc.Base.Config -MockWith { Join-Path $env:RepositoryRoot 'widgetry' }
        }

        It 'returns .catzc and the modules folder''s name when that folder exists, and never the consumer overlay' {
            $env:RepositoryRoot = Join-Path $TestDrive 'widget-consumer'
            $fragments = Join-Path $env:RepositoryRoot '.catzc/widgetry'
            [System.IO.Directory]::CreateDirectory($fragments) | Out-Null
            & $run | Should -Be ([System.IO.Path]::GetFullPath($fragments))
            Should -Invoke Get-CatzcOverlayRoot -ModuleName Catzc.Base.Config -Times 0
        }

        It 'returns nothing when the repository holds no fragment folder' {
            $env:RepositoryRoot = Join-Path $TestDrive 'gadget-consumer'
            & $run | Should -BeNullOrEmpty
        }
    }

    It 'derives the overlay root once per pair of anchors' {
        $env:RepositoryRoot = Join-Path $TestDrive 'widget-consumer'
        & $run | Should -Be "overlay-of:$(Join-Path $TestDrive 'widget-consumer')"
        & $run | Should -Be "overlay-of:$(Join-Path $TestDrive 'widget-consumer')"
        Should -Invoke Get-CatzcOverlayRoot -ModuleName Catzc.Base.Config -Times 1 -Exactly
    }

    It 'derives it again when an anchor changes' {
        $env:RepositoryRoot = Join-Path $TestDrive 'widget-consumer'
        $null = & $run
        $env:RepositoryRoot = Join-Path $TestDrive 'gadget-consumer'
        & $run | Should -Be "overlay-of:$(Join-Path $TestDrive 'gadget-consumer')"
        Should -Invoke Get-CatzcOverlayRoot -ModuleName Catzc.Base.Config -Times 2 -Exactly
    }
}
