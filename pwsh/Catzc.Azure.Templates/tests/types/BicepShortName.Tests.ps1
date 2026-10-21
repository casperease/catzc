<#
---
catzc:
  immutable:
    with_body_sha: "987d24d3be35"
  edges:
    docs: "[BicepShortName.Tests.ps1.md](docs/references/pwsh/catzc-azure-templates/tests/types/BicepShortName.Tests.ps1.md)"
    code: pwsh/Catzc.Azure.Templates/types/BicepShortName.cs
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
      - ADR-AZ-NAMING-TWOTEMPLATEIDENTIFIERS
---
#>

# cspell:ignore deriv abcdef gadge gadgetry getry gadg
Describe 'BicepShortName' -Tag 'L0', 'logic' {

    Context 'Derive (folder name -> short_name)' {
        It 'takes the first 5 [a-z0-9] characters' {
            [Catzc.Azure.Templates.BicepShortName]::Derive('my-core') | Should -Be 'mycor'
        }

        It 'drops hyphens (and any other punctuation)' {
            [Catzc.Azure.Templates.BicepShortName]::Derive('gad-getry') | Should -Be 'gadge'
        }

        It 'lowercases the folder name' {
            [Catzc.Azure.Templates.BicepShortName]::Derive('MyApp') | Should -Be 'myapp'
        }

        It 'returns a short folder unchanged when it is under 5 chars' {
            [Catzc.Azure.Templates.BicepShortName]::Derive('fnd') | Should -Be 'fnd'
        }

        It 'yields an empty string for an all-punctuation folder (rejected later by Resolve)' {
            [Catzc.Azure.Templates.BicepShortName]::Derive('---') | Should -Be ''
        }
    }

    Context 'IsValid (2-5 lowercase-alnum, leading letter)' {
        It 'accepts a well-formed short_name' {
            [Catzc.Azure.Templates.BicepShortName]::IsValid('gadge') | Should -BeTrue
            [Catzc.Azure.Templates.BicepShortName]::IsValid('a1')    | Should -BeTrue
        }

        It 'rejects too-short, too-long, leading-digit, and non-alnum values' {
            [Catzc.Azure.Templates.BicepShortName]::IsValid('a')       | Should -BeFalse -Because '1 char'
            [Catzc.Azure.Templates.BicepShortName]::IsValid('abcdef')  | Should -BeFalse -Because '6 chars'
            [Catzc.Azure.Templates.BicepShortName]::IsValid('1abc')    | Should -BeFalse -Because 'leading digit'
            [Catzc.Azure.Templates.BicepShortName]::IsValid('ab-c')    | Should -BeFalse -Because 'hyphen'
            [Catzc.Azure.Templates.BicepShortName]::IsValid('Abc')     | Should -BeFalse -Because 'uppercase'
            [Catzc.Azure.Templates.BicepShortName]::IsValid('')        | Should -BeFalse -Because 'empty'
        }
    }

    Context 'Resolve (folder + optional override)' {
        It 'derives from the folder when no override is given' {
            $shortName = [Catzc.Azure.Templates.BicepShortName]::Resolve('gadgetry', $null)
            $shortName.value      | Should -Be 'gadge'
            $shortName.folder     | Should -Be 'gadgetry'
            $shortName.overridden | Should -BeFalse
        }

        It 'treats an empty override the same as no override (derives)' {
            [Catzc.Azure.Templates.BicepShortName]::Resolve('gadgetry', '').value | Should -Be 'gadge'
        }

        It 'takes a valid override verbatim and marks it overridden' {
            $shortName = [Catzc.Azure.Templates.BicepShortName]::Resolve('gadgetry', 'gadg')
            $shortName.value      | Should -Be 'gadg'
            $shortName.overridden | Should -BeTrue
        }

        It 'throws on a malformed override, naming the template' {
            { [Catzc.Azure.Templates.BicepShortName]::Resolve('gadgetry', 'BAD-1') } |
                Should -Throw "*Template 'gadgetry'*invalid short_name override*"
        }

        It 'throws when the folder cannot derive a valid short_name and no override is given' {
            { [Catzc.Azure.Templates.BicepShortName]::Resolve('x', $null) } |
                Should -Throw "*Template 'x'*derives an invalid short_name*"
        }
    }
}
