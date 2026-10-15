<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-ModuleNameFileMetaFact.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-REPO-CODEMETA#2
---
#>

Describe 'Get-ModuleNameFileMetaFact' -Tag 'L0', 'logic', 'ADR-REPO-CODEMETA#2' {
    BeforeAll {
        function script:Get-Fact {
            param([string] $Path, [hashtable] $Settings = @{})
            $entry = @{ keys = @('module') }
            if ($Settings.Count -gt 0) {
                $entry['settings'] = $Settings
            }
            $kind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'module-name' = $entry } }).kinds[0]
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Kind = $kind; Path = $Path } {
                param($Kind, $Path)
                Get-ModuleNameFileMetaFact -State ([pscustomobject]@{}) -Path $Path -Kind $Kind
            }
        }
    }

    It 'returns the folder under the modules root, whatever the file''s depth' {
        (Get-Fact 'automation/Catzc.Widget/Get-Gadget.ps1').Keys | Should -Be @('module')
        (Get-Fact 'automation/Catzc.Widget/Get-Gadget.ps1')['module'] | Should -BeExactly 'Catzc.Widget'
        (Get-Fact 'automation/Catzc.Widget/private/Get-Sprocket.ps1')['module'] | Should -BeExactly 'Catzc.Widget'
        (Get-Fact 'automation/Catzc.Widget/types/Gadget.cs')['module'] | Should -BeExactly 'Catzc.Widget'
    }

    It 'takes the modules root from the kind''s settings' {
        (Get-Fact 'widgets/Catzc.Gadget/Get-Cog.ps1' @{ root = 'widgets' })['module'] | Should -BeExactly 'Catzc.Gadget'
    }

    It 'refuses a file outside any module, naming the file' {
        { Get-Fact 'docs/gadget.ps1' } | Should -Throw "*kind 'module-name' applies to files under automation/<module>/, but selected 'docs/gadget.ps1'*"
        { Get-Fact 'automation/Get-Gadget.ps1' } | Should -Throw '*but selected*'
    }
}
