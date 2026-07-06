# The build-validation.yml shape validator (collect-all-then-throw), plus the shipped-config integrity
# check: every entry ties to a declared globset and resolves a pipeline (the ADR-CUSTOMER:3 pattern — the
# cross-config reference is enforced here and at runtime, never at config load).
Describe 'Assert-BuildValidationConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:validate = {
            param($config)
            & (Get-Module Catzc.Azure.DevOps.BuildValidation) { param($inner) Assert-BuildValidationConfig $inner } $config
        }
        $script:valid = [ordered]@{
            branch      = 'main'
            validations = @(
                [ordered]@{ globset = 'automation' }
                [ordered]@{ globset = 'template-azure-subscription-foundation'; pipeline = 'ci-foundation'; blocking = $false; display_name = 'x' }
            )
        }
    }

    It 'passes a valid config' {
        { & $script:validate $script:valid } | Should -Not -Throw
    }

    It 'rejects <why>' -ForEach @(
        @{ why = 'an unknown top-level key'; config = [ordered]@{ branch = 'main'; validations = @([ordered]@{ globset = 'a' }); extra = 1 } }
        @{ why = 'a missing branch'; config = [ordered]@{ validations = @([ordered]@{ globset = 'a' }) } }
        @{ why = 'an empty branch'; config = [ordered]@{ branch = ' '; validations = @([ordered]@{ globset = 'a' }) } }
        @{ why = 'a missing validations list'; config = [ordered]@{ branch = 'main' } }
        @{ why = 'an empty validations list'; config = [ordered]@{ branch = 'main'; validations = @() } }
        @{ why = 'a non-mapping entry'; config = [ordered]@{ branch = 'main'; validations = @('automation') } }
        @{ why = 'an entry without globset'; config = [ordered]@{ branch = 'main'; validations = @([ordered]@{ pipeline = 'x' }) } }
        @{ why = 'an unknown entry key'; config = [ordered]@{ branch = 'main'; validations = @([ordered]@{ globset = 'a'; nope = 1 }) } }
        @{ why = 'a non-bool blocking'; config = [ordered]@{ branch = 'main'; validations = @([ordered]@{ globset = 'a'; blocking = 'yes' }) } }
        @{ why = 'an empty pipeline'; config = [ordered]@{ branch = 'main'; validations = @([ordered]@{ globset = 'a'; pipeline = ' ' }) } }
        @{ why = 'a duplicate globset entry'; config = [ordered]@{ branch = 'main'; validations = @([ordered]@{ globset = 'a' }, [ordered]@{ globset = 'a' }) } }
    ) {
        { & $script:validate $config } | Should -Throw '*build-validation configuration validation failed*'
    }

    It 'collects every violation into one throw' {
        $config = [ordered]@{ branch = ' '; validations = @([ordered]@{ pipeline = ' '; nope = 1 }) }
        $thrown = $null
        try {
            & $script:validate $config
        }
        catch {
            $thrown = "$_"
        }
        $thrown | Should -Match 'branch is empty'
        $thrown | Should -Match "unknown key 'nope'"
        $thrown | Should -Match "'globset' is required"
    }
}

Describe 'Shipped build-validation config integrity' -Tag 'L0', 'integrity' {
    It 'loads through Get-Config and its validator' {
        $config = Get-Config -Config build-validation
        $config.branch | Should -Not -BeNullOrEmpty
        @($config.validations).Count | Should -BeGreaterThan 0
    }

    It 'ties every entry to a declared globset that resolves a pipeline' {
        $config = Get-Config -Config build-validation
        foreach ($entry in @($config.validations)) {
            $set = Get-GlobSet -Name $entry.globset
            $pipeline = if ($entry.Contains('pipeline')) {
                $entry.pipeline
            }
            else {
                $set.Pipeline
            }
            $pipeline | Should -Not -BeNullOrEmpty -Because "entry '$($entry.globset)' must resolve a pipeline (its own key or the globset's annotation)"
        }
    }
}
