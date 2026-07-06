# Validates the compiled TerminologyConfig / TerminologyTerm types directly — the constructor is the gate
# that stops an unjustified or malformed registry entry from ever producing an instance (ADR-SPELL:6). The
# 'categories' map is the single source of the allowed categories; 'terms' groups entries under those
# category keys, so a term's category is the group it is listed under (no per-entry category field).
Describe 'TerminologyConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:cats = @{
            domain       = @{ description = 'a domain term' }
            abbreviation = @{ description = 'a short form' }
            fixture      = @{ description = 'a test-only token' }
        }
        $script:make = {
            param([hashtable] $termsMap)
            [Catzc.Base.QualityGates.TerminologyConfig]::new(@{ categories = $script:cats; terms = $termsMap })
        }
    }

    It 'constructs and exposes the categories and a valid term with its group category' {
        $c = & $script:make @{ domain = @(@{ term = 'bicep'; meaning = 'Azure Bicep' }) }
        $c.terms.Count | Should -Be 1
        $c.terms[0].term | Should -Be 'bicep'
        $c.terms[0].category | Should -Be 'domain'
        $c.categories | Should -Contain 'domain'
    }

    It 'keeps an abbreviation''s expansion' {
        $c = & $script:make @{ abbreviation = @(@{ term = 'ctx'; meaning = 'context'; expands_to = 'context' }) }
        $c.terms[0].expands_to | Should -Be 'context'
    }

    It 'throws when meaning is missing (ADR-SPELL:6)' {
        { & $script:make @{ domain = @(@{ term = 'x' }) } } | Should -Throw '*meaning is required*'
    }

    It 'throws when a terms group is not a defined category' {
        { & $script:make @{ nope = @(@{ term = 'x'; meaning = 'y' }) } } |
            Should -Throw '*not a defined category*'
    }

    It 'throws when an abbreviation has no expansion' {
        { & $script:make @{ abbreviation = @(@{ term = 'x'; meaning = 'y' }) } } |
            Should -Throw '*abbreviation must carry*'
    }

    It 'throws when a non-abbreviation carries an expansion' {
        { & $script:make @{ domain = @(@{ term = 'x'; meaning = 'y'; expands_to = 'z' }) } } |
            Should -Throw '*only an abbreviation*'
    }

    It 'throws on a duplicate term across groups' {
        {
            & $script:make @{
                domain  = @(@{ term = 'dup'; meaning = 'a' })
                fixture = @(@{ term = 'dup'; meaning = 'b' })
            }
        } | Should -Throw '*duplicate term*'
    }

    It 'throws when the categories map is empty or absent' {
        { [Catzc.Base.QualityGates.TerminologyConfig]::new(
                @{ terms = @{ domain = @(@{ term = 'a'; meaning = 'b' }) } }) } |
            Should -Throw "*non-empty 'categories'*"
        { [Catzc.Base.QualityGates.TerminologyConfig]::new(@{ categories = @{}; terms = @{} }) } |
            Should -Throw "*non-empty 'categories'*"
    }

    It 'throws when a defined category has no description' {
        { [Catzc.Base.QualityGates.TerminologyConfig]::new(
                @{ categories = @{ domain = '' }; terms = @{ domain = @(@{ term = 'a'; meaning = 'b' }) } }) } |
            Should -Throw '*a description is required*'
    }

    It 'throws when the terms map is empty or absent' {
        { & $script:make @{} } | Should -Throw "*non-empty 'terms'*"
        { [Catzc.Base.QualityGates.TerminologyConfig]::new(@{ categories = $script:cats }) } |
            Should -Throw "*non-empty 'terms'*"
    }
}
