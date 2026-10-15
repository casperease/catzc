<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ConfigExtensions/tests/Test-ConfigValidators.Tests.ps1
    kind: pester-test
---
#>

# Test-ConfigValidators over a fixture code root in $TestDrive and two in-memory fixture modules whose private
# validators the gate lists from their own scope. Neutral fixture names
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Test-ConfigValidators' -Tag 'L0', 'logic' {
    BeforeAll {
        $root = Join-Path $TestDrive 'automation'
        foreach ($path in 'TstWidget/configs/widget-parts.yml', 'TstGadget/configs/gadget.yml', '.internal/x.txt') {
            $full = Join-Path $root $path
            [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($full))
            [System.IO.File]::WriteAllText($full, '')
        }
        New-Module -Name TstWidget -ScriptBlock {
            function Assert-WidgetPartsConfig {
            }
            Export-ModuleMember
        } | Import-Module
        New-Module -Name TstGadget -ScriptBlock {
            function Assert-GadgetConfig {
            }
            function Assert-SprocketConfig {
            }
            Export-ModuleMember
        } | Import-Module
        $script:out = Join-Path $TestDrive 'out'
    }

    AfterAll {
        Remove-Module TstWidget, TstGadget -ErrorAction Ignore
    }

    BeforeEach {
        Mock Get-CatzcModulesRoot -ModuleName Catzc.Base.ConfigExtensions { Join-Path $TestDrive 'automation' }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
    }

    It 'throws once naming the validator with no matching config' {
        $thrown = { Test-ConfigValidators -OutputFolder $out } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-ConfigValidators failed: 1 issue(s)*'
        $thrown.Exception.Message | Should -Match 'Assert-SprocketConfig in TstGadget has no matching configs/\*\.yml'
    }

    It 'returns the result and counts every validator under -PassThru' {
        $result = Test-ConfigValidators -OutputFolder $out -PassThru
        $result.Subject | Should -Be 'config-validators'
        $result.Validators | Should -Be 3
        $result.Issues | Should -HaveCount 1
    }

    It 'passes when every validator maps to a kebab-case config of its module' {
        [System.IO.File]::WriteAllText((Join-Path $TestDrive 'automation/TstGadget/configs/sprocket.yml'), '')
        try {
            { Test-ConfigValidators -OutputFolder $out } | Should -Not -Throw
        }
        finally {
            Remove-Item (Join-Path $TestDrive 'automation/TstGadget/configs/sprocket.yml')
        }
    }
}

Describe 'Config validator coverage' -Tag 'L0', 'integrity' {
    # Title deliberately avoids Pester's <var> name-template syntax — under the importer's strict mode an
    # unmatched <name> token in an It title throws at name-expansion time instead of expanding to empty.
    It 'every Assert-*Config validator maps to a configs/*.yml in its module (no orphans)' {
        $result = Test-ConfigValidators -PassThru -OutputFolder (Join-Path $TestDrive 'config-validators')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
