<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Save-FileMetaResult.Tests.ps1
    kind: pester-test
    relatives:
      source: automation/Catzc.Base.QualityGates/private/Save-FileMetaResult.ps1
    adrs:
      - ADR-REPO-FILEMETA#3
---
#>

Describe 'Save-FileMetaResult' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#3' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'save-repository'
        $script:result = [pscustomobject]@{
            FileCount = 3
            Files     = @(
                [pscustomobject]@{ Path = 'docs/widget.md'; Findings = @([pscustomobject]@{ Kind = 'Drift' }); Fixed = "---`ncatzc:`n---`n# Widget`n" }
                [pscustomobject]@{ Path = 'docs/gadget.md'; Findings = @([pscustomobject]@{ Kind = 'Unowned'; Actual = 'catzc.derived.colour' }); Fixed = "unchanged`n" }
                [pscustomobject]@{ Path = 'automation/Widget/Get-Cog.ps1'; Findings = @([pscustomobject]@{ Kind = 'UnownedHead'; Actual = 'catzc head.colour' }); Fixed = "unchanged`n" }
            )
        }
    }

    BeforeEach {
        $null = New-Item -ItemType Directory -Path (Join-Path $script:root 'docs') -Force
        [System.IO.File]::WriteAllText((Join-Path $script:root 'docs/widget.md'), "# Widget`n")
    }

    It 'writes only the drifted files, without a byte order mark, and names the findings a person must settle' {
        $saved = InModuleScope Catzc.Base.QualityGates -Parameters @{ Result = $script:result; Root = $script:root } {
            param($Result, $Root)
            Save-FileMetaResult -Result $Result -RepositoryRoot $Root
        }
        $saved.Fixed.Path | Should -Be @('docs/widget.md')
        $bytes = [System.IO.File]::ReadAllBytes((Join-Path $script:root 'docs/widget.md'))
        $bytes[0] | Should -Be ([byte] [char] '-')
        [System.Text.Encoding]::UTF8.GetString($bytes) | Should -BeExactly "---`ncatzc:`n---`n# Widget`n"
        $saved.Unowned.Kind | Should -Be @('Unowned', 'UnownedHead')
        Test-Path (Join-Path $script:root 'docs/gadget.md') | Should -BeFalse -Because 'an unowned key leaves the file as it is'
    }

    It 'writes nothing under -DryRun and still names what would change' {
        $saved = InModuleScope Catzc.Base.QualityGates -Parameters @{ Result = $script:result; Root = $script:root } {
            param($Result, $Root)
            Save-FileMetaResult -Result $Result -RepositoryRoot $Root -DryRun
        }
        $saved.Fixed.Path | Should -Be @('docs/widget.md')
        [System.IO.File]::ReadAllText((Join-Path $script:root 'docs/widget.md')) | Should -BeExactly "# Widget`n"
    }

    It 'returns empty lists for a result with no findings' {
        $saved = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root } {
            param($Root)
            Save-FileMetaResult -Result ([pscustomobject]@{ FileCount = 0; Files = @() }) -RepositoryRoot $Root
        }
        @($saved.Fixed).Count | Should -Be 0
        @($saved.Unowned).Count | Should -Be 0
    }
}
