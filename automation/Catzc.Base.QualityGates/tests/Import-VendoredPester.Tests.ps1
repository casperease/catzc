<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/tests/Import-VendoredPester.Tests.ps1
    folder: tests
    name: import-vendored-pester-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-qualitygates/tests/Import-VendoredPester.Tests.ps1.md
    cites:
      - ADR-PWSH-VENDOR#5
---
#>

Describe 'Import-VendoredPester' -Tag 'L0', 'logic', 'ADR-PWSH-VENDOR#5' {
    BeforeEach {
        $script:codeRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $script:vendoredBase = Join-Path $script:codeRoot '.vendor/Pester/9.9.9'
        [System.IO.Directory]::CreateDirectory($script:vendoredBase) | Out-Null
        Mock Get-CatzcModulesRoot { $script:codeRoot } -ModuleName Catzc.Base.QualityGates
        Mock Import-Module { [pscustomobject]@{ Version = [version] '9.9.9' } } -ModuleName Catzc.Base.QualityGates
        Mock Remove-Module { } -ModuleName Catzc.Base.QualityGates
        Mock Write-Message { } -ModuleName Catzc.Base.QualityGates
    }

    It 'leaves a session that already has the vendored version loaded' {
        Mock Get-Module { [pscustomobject]@{ Version = [version] '9.9.9'; ModuleBase = $script:vendoredBase } } -ModuleName Catzc.Base.QualityGates
        InModuleScope Catzc.Base.QualityGates { Import-VendoredPester }
        Should -Invoke Import-Module -ModuleName Catzc.Base.QualityGates -Times 0 -Exactly
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 0 -Exactly
    }

    It 'loads the vendored version into a session without Pester' {
        Mock Get-Module { } -ModuleName Catzc.Base.QualityGates
        InModuleScope Catzc.Base.QualityGates { Import-VendoredPester }
        Should -Invoke Remove-Module -ModuleName Catzc.Base.QualityGates -Times 0 -Exactly
        Should -Invoke Import-Module -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Message -like 'Loaded vendor module Pester 9.9.9 from *' -and $Message -notlike '*replaced*' }
    }

    It 'replaces another Pester and names it in the announcement' {
        Mock Get-Module { [pscustomobject]@{ Version = [version] '4.10.1'; ModuleBase = 'C:\system\Pester\4.10.1' } } -ModuleName Catzc.Base.QualityGates
        InModuleScope Catzc.Base.QualityGates { Import-VendoredPester }
        Should -Invoke Remove-Module -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly
        Should -Invoke Import-Module -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Message -like "*; replaced Pester 4.10.1 from 'C:\system\Pester\4.10.1'" }
    }

    It 'replaces the right version loaded from the wrong place' {
        Mock Get-Module { [pscustomobject]@{ Version = [version] '9.9.9'; ModuleBase = 'C:\system\Pester\9.9.9' } } -ModuleName Catzc.Base.QualityGates
        InModuleScope Catzc.Base.QualityGates { Import-VendoredPester }
        Should -Invoke Import-Module -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly
    }

    It 'fails fast when the vendor folder does not hold exactly one version' {
        [System.IO.Directory]::CreateDirectory((Join-Path $script:codeRoot '.vendor/Pester/9.9.8')) | Out-Null
        Mock Get-Module { } -ModuleName Catzc.Base.QualityGates
        { InModuleScope Catzc.Base.QualityGates { Import-VendoredPester } } | Should -Throw '*expected one vendored Pester version*found 2*'
    }
}
