<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/tests/Test-ParameterConsistency.Tests.ps1.md"
  warning: "Generated Header"
---
#>

Describe 'Test-ParameterConsistency' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { 'C:\widget-repo' }
        Mock Get-CatzcModulesFolder -ModuleName Catzc.Base.QualityGates { 'widget-modules' }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates {
            'widget-modules/Catzc.Widget/Get-Widget.ps1', 'widget-modules/Catzc.Widget/private/Set-Widget.ps1', 'widget-modules/Catzc.Widget/tests/Get-Widget.Tests.ps1', 'widget-modules/.internal/Get-Gadget.ps1'
        }
        Mock Get-ParameterTypeConflict -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Name = 'Count'; Types = @([pscustomobject]@{ Type = 'int'; Functions = @('Get-Widget') }, [pscustomobject]@{ Type = 'string'; Functions = @('Set-Gadget') }) }
            [pscustomobject]@{ Name = 'Kind'; Types = @([pscustomobject]@{ Type = 'string'; Functions = @('Get-Widget') }, [pscustomobject]@{ Type = 'int'; Functions = @('Set-Gadget') }) }
        }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'parameter-consistency' } {
            [Catzc.Base.QualityGates.ParameterConsistencyConfig]::new([ordered]@{ exempt = [ordered]@{ Kind = 'widget kinds and gadget kinds differ'; Gone = 'once conflicted' } })
        }
        $script:report = Join-Path $TestDrive 'parameter-consistency'
    }

    It 'reads only the public function files' {
        Test-ParameterConsistency -PassThru -OutputFolder $script:report | Out-Null
        Should -Invoke Get-ParameterTypeConflict -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            @($Path).Count -eq 1 -and $Path[0] -like '*Catzc.Widget*Get-Widget.ps1'
        }
    }

    It 'reports a conflicting name with its types and functions, skips an exempt one, and reports a stale exemption' {
        $result = Test-ParameterConsistency -PassThru -OutputFolder $script:report
        $result.Issues | Should -Be @(
            '-Count: one name, more than one type — [int] in Get-Widget; [string] in Set-Gadget. Give it one type, or exempt it in parameter-consistency.yml with the reason'
            "$(Get-CatzcModulesFolder)/Catzc.Base.QualityGates/configs/parameter-consistency.yml: -Gone is exempt but no longer conflicts — remove the entry"
        )
        $result.Facts['Exempt'] | Should -Be 2
    }
}

Describe 'Parameter consistency of the public functions' -Tag 'L0', 'integrity', 'source-only' {
    BeforeAll {
        $script:result = Test-ParameterConsistency -PassThru -OutputFolder (Join-Path $TestDrive 'parameter-consistency')
    }

    It 'the scan read the public functions (guards the check below against a silent no-op)' {
        $script:result.Facts['Functions'] | Should -BeGreaterThan 100
    }

    It 'gives every parameter name one type, apart from the exempt names, and exempts only real conflicts' {
        $script:result.IssueCount | Should -Be 0 -Because ($script:result.Issues -join "`n")
    }
}

Describe 'Test-ParameterConsistency — shipped configs/parameter-consistency.yml' -Tag 'L1', 'integrity', 'ADR-AUTO-ASSETDEP-COVEREDBYREALTEST' {
    It 'finds the exemption list it names in the loaded module' {
        $config = [System.IO.File]::ReadAllText((Get-CatzcModuleRoot 'configs/parameter-consistency.yml' -Module Catzc.Base.QualityGates)) | ConvertFrom-Yaml -Ordered
        @($config['exempt'].Keys).Count | Should -BeGreaterThan 0
    }
}
