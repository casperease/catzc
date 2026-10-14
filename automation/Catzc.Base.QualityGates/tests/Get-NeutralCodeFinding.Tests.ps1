# Get-NeutralCodeFinding over fixture test files: ADR-WIDGET-GADGET stands in for a code the ADR registry declares,
# and ADR-WIDGET-SPROCKET for a neutral one
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Get-NeutralCodeFinding' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:find = {
            param([string] $Text)
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($Text, [ref]$null, [ref]$null)
            $real = [System.Collections.Generic.HashSet[string]]::new([string[]] @('ADR-WIDGET-GADGET'))
            & (Get-Module Catzc.Base.QualityGates) {
                Get-NeutralCodeFinding -Path 'src/tests/Get-Widget.Tests.ps1' -Ast $args[0] -Code $args[1]
            } $ast $real
        }
    }

    It 'flags a real code in an L0 block''s fixture data, with its line' -Tag 'ADR-AUTO-TEST#3' {
        $found = @(& $find (@(
                    'Describe ''Get-Widget'' -Tag ''L0'', ''logic'' {'
                    '    It ''reads a rule'' {'
                    '        Get-Widget -Citation ''ADR-WIDGET-GADGET#2'' | Should -Be 1'
                    '    }'
                    '}'
                ) -join "`n"))
        $found | Should -HaveCount 1
        $found[0] | Should -BeLike "src/tests/Get-Widget.Tests.ps1:3: L0 fixture data uses the real ADR code 'ADR-WIDGET-GADGET'*"
    }

    It 'passes a real code in a -Tag value and in a comment, and a neutral code anywhere' -Tag 'ADR-AUTO-TEST#3' {
        $found = @(& $find (@(
                    '# Proves ADR-WIDGET-GADGET#2.'
                    'Describe ''Get-Widget'' -Tag ''L0'', ''logic'' {'
                    '    It ''reads a rule'' -Tag ''ADR-WIDGET-GADGET#2'' {'
                    '        Get-Widget -Citation ''ADR-WIDGET-SPROCKET#2'' | Should -Be 1'
                    '    }'
                    '}'
                ) -join "`n"))
        $found | Should -HaveCount 0
    }

    It 'passes a real code in a block whose nearest tier is not L0' -Tag 'ADR-AUTO-TEST#3' {
        $found = @(& $find (@(
                    'Describe ''Get-Widget'' -Tag ''L0'', ''logic'' {'
                    '    Context ''the shipped registry'' -Tag ''L1'', ''integrity'' {'
                    '        It ''reads it'' { Get-Widget -Citation ''ADR-WIDGET-GADGET#2'' | Should -Be 1 }'
                    '    }'
                    '    It ''reads a fixture'' { Get-Widget -Citation "ADR-WIDGET-GADGET#3" | Should -Be 1 }'
                    '}'
                ) -join "`n"))
        $found | Should -HaveCount 1
        $found[0] | Should -BeLike 'src/tests/Get-Widget.Tests.ps1:5:*'
    }

    It 'reads setup outside every block as L0 when L0 is the file''s only tier' -Tag 'ADR-AUTO-TEST#3' {
        $found = @(& $find (@(
                    '$fixture = @{ code = ''ADR-WIDGET-GADGET'' }'
                    'Describe ''Get-Widget'' -Tag ''L0'', ''logic'' { It ''x'' { 1 | Should -Be 1 } }'
                ) -join "`n"))
        $found | Should -HaveCount 1
        $found[0] | Should -BeLike 'src/tests/Get-Widget.Tests.ps1:1:*'
    }
}
