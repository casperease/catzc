<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/tests/Invoke-Prettier.Tests.ps1.md"
  warning: "Generated Header"
---
#>

Describe 'Invoke-Prettier' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:repo = Join-Path $TestDrive 'repo'
        $script:widget = [System.IO.Path]::GetFullPath((Join-Path $script:repo 'docs/widget.md'))
        $script:gadget = [System.IO.Path]::GetFullPath((Join-Path $script:repo 'docs/gadget.md'))
    }

    BeforeEach {
        $script:listExit = 1
        $script:listOut = "docs/widget.md`n"
        $script:writeExit = 0
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:repo }
        Mock Test-Command -ModuleName Catzc.Base.QualityGates { $true }
        Mock Invoke-Executable -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Command -like 'prettier --list-different *' } {
            [pscustomobject]@{ ExitCode = $script:listExit; Output = $script:listOut; Full = $script:listOut }
        }
        Mock Invoke-Executable -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Command -like 'prettier --write *' } {
            [pscustomobject]@{ ExitCode = $script:writeExit; Output = ''; Full = 'write failed' }
        }
    }

    It 'lists the differing files, then writes exactly those' {
        $changed = InModuleScope Catzc.Base.QualityGates -Parameters @{ Files = @($script:widget, $script:gadget) } {
            param($Files)
            Invoke-Prettier -File $Files
        }
        $changed | Should -Be @($script:widget)
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Command -eq "prettier --list-different `"$script:widget`" `"$script:gadget`""
        }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Command -eq "prettier --write `"$script:widget`""
        }
    }

    It 'writes nothing under -DryRun or when every file is formatted' {
        $null = InModuleScope Catzc.Base.QualityGates -Parameters @{ Files = @($script:widget) } { param($Files) Invoke-Prettier -File $Files -DryRun }
        $script:listExit = 0
        $script:listOut = ''
        $none = InModuleScope Catzc.Base.QualityGates -Parameters @{ Files = @($script:widget) } {
            param($Files)
            @(Invoke-Prettier -File $Files | ForEach-Object { $_ })
        }
        $none | Should -HaveCount 0
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 0 -ParameterFilter { $Command -like 'prettier --write *' }
    }

    It 'runs nothing, and needs no prettier, when there are no files' {
        Mock Test-Command -ModuleName Catzc.Base.QualityGates { $false }
        $none = InModuleScope Catzc.Base.QualityGates { @(Invoke-Prettier -File @() | ForEach-Object { $_ }) }
        $none | Should -HaveCount 0
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 0
    }

    It 'throws a tool error when prettier exits greater than 1, and when a write fails' {
        $script:listExit = 2
        { InModuleScope Catzc.Base.QualityGates -Parameters @{ Files = @($script:widget) } { param($Files) Invoke-Prettier -File $Files } } |
            Should -Throw '*Prettier failed (exit 2)*'
        $script:listExit = 1
        $script:writeExit = 2
        { InModuleScope Catzc.Base.QualityGates -Parameters @{ Files = @($script:widget) } { param($Files) Invoke-Prettier -File $Files } } |
            Should -Throw '*Prettier failed (exit 2): write failed*'
    }

    It 'throws an actionable error when prettier is not installed' {
        Mock Test-Command -ModuleName Catzc.Base.QualityGates { $false }
        { InModuleScope Catzc.Base.QualityGates -Parameters @{ Files = @($script:widget) } { param($Files) Invoke-Prettier -File $Files } } |
            Should -Throw '*Install-Prettier*'
    }
}
