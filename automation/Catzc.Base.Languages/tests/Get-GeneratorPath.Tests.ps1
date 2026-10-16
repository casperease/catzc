<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/tests/Get-GeneratorPath.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.Languages
    relatives:
      source: automation/Catzc.Base.Languages/private/Get-GeneratorPath.ps1
    adrs:
      - ADR-REPO-FILEMETA#7
---
#>

Describe 'Get-GeneratorPath' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#7' {
    It 'names the file a loaded function is defined in, relative to the root the code lives in, with forward slashes' {
        InModuleScope Catzc.Base.Languages {
            Get-GeneratorPath Format-GeneratedFileHead | Should -BeExactly 'automation/Catzc.Base.Languages/Format-GeneratedFileHead.ps1'
        }
    }

    It 'names a function from another module by its own file' {
        InModuleScope Catzc.Base.Languages {
            Get-GeneratorPath Build-AdrIndex | Should -BeExactly 'automation/Catzc.Base.Docs/Build-AdrIndex.ps1'
        }
    }

    It 'names the file a function in this module keeps under private' {
        InModuleScope Catzc.Base.Languages {
            Get-GeneratorPath Get-GeneratorPath | Should -BeExactly 'automation/Catzc.Base.Languages/private/Get-GeneratorPath.ps1'
        }
    }

    It 'throws for a command that is not a loaded function' {
        InModuleScope Catzc.Base.Languages {
            { Get-GeneratorPath Build-NoSuchWidget } | Should -Throw "*'Build-NoSuchWidget' is no loaded function*"
        }
    }
}
