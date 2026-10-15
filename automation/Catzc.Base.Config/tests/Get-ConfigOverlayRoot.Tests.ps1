<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Config/tests/Get-ConfigOverlayRoot.Tests.ps1
    kind: test
---
#>

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
