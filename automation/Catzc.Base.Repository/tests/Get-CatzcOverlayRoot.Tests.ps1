<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Repository/tests/Get-CatzcOverlayRoot.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Repository
    moduletype: pwsh-folder-module
    bundle: azure
---
#>

Describe 'Get-CatzcOverlayRoot' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:originalModulesRoot = $env:CatzcModulesRoot
        $script:originalRepositoryRoot = $env:RepositoryRoot
        # A consumer working root with an overlay, and a built bundle elsewhere.
        $script:consumer = Join-Path $TestDrive 'widget-consumer'
        $script:overlay = Join-Path $consumer '.catzc/automation'
        [System.IO.Directory]::CreateDirectory($overlay) | Out-Null
        [System.IO.Directory]::CreateDirectory((Join-Path $consumer 'automation')) | Out-Null
        $script:bundle = Join-Path $TestDrive 'gadget-store/Catzc/1.2.3'
    }
    AfterAll {
        $env:CatzcModulesRoot = $script:originalModulesRoot
        $env:RepositoryRoot = $script:originalRepositoryRoot
    }

    It 'is the working root''s .catzc/automation in build mode' {
        $env:RepositoryRoot = $consumer
        $env:CatzcModulesRoot = $bundle
        Get-CatzcOverlayRoot | Should -Be ([System.IO.Path]::GetFullPath($overlay))
    }

    It 'is nothing in source mode, even with a .catzc/ folder present' {
        $env:RepositoryRoot = $consumer
        $env:CatzcModulesRoot = Join-Path $consumer 'automation'
        Get-CatzcOverlayRoot | Should -BeNullOrEmpty
    }

    It 'is nothing in build mode when the working root has no overlay' {
        $env:RepositoryRoot = Join-Path $TestDrive 'gizmo-consumer'
        $env:CatzcModulesRoot = $bundle
        Get-CatzcOverlayRoot | Should -BeNullOrEmpty
    }
}
