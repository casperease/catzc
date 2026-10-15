<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps.BuildValidation/tests/types/BuildValidationConfig.Tests.ps1
    kind: test
---
#>

# The build-validation.yml type (collect-all-then-throw), plus the shipped-config integrity check: every entry
# ties to a declared globset and resolves a pipeline (the
# [ADR-AZ-CUSTOMER#3](/docs/adr/azure/azure-customer-model.md#rule-adr-az-customer3) pattern — the cross-config
# reference is enforced here and at runtime, never at config load).
Describe 'BuildValidationConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:make = {
            param([System.Collections.IDictionary] $config)
            [Catzc.Azure.DevOps.BuildValidation.BuildValidationConfig]::new($config)
        }
        # Neutral fixture globset/pipeline names (widget/gadget) — the type checks SHAPE only (globset existence
        # is enforced by the integrity test below and at runtime), so a logic fixture must not borrow real
        # deployable-unit names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
        $script:valid = [ordered]@{
            branch      = 'main'
            validations = @(
                [ordered]@{ globset = 'widget' }
                [ordered]@{ globset = 'gadget'; pipeline = 'cd-gadget'; blocking = $false; display_name = 'x' }
            )
        }
    }

    It 'passes a valid config and maps every entry, defaulting blocking to true' {
        $config = & $script:make $script:valid
        $config.branch | Should -Be 'main'
        $config.validations.globset | Should -Be @('widget', 'gadget')
        $config.validations[0].blocking | Should -BeTrue
        $config.validations[0].Contains('pipeline') | Should -BeFalse
        $config.validations[1].pipeline | Should -Be 'cd-gadget'
        $config.validations[1].blocking | Should -BeFalse
        $config.validations[1].display_name | Should -Be 'x'
    }

    It 'rejects <why>' -ForEach @(
        @{ why = 'an unknown top-level key'; config = [ordered]@{ branch = 'main'; validations = @([ordered]@{ globset = 'a' }); extra = 1 } }
        @{ why = 'a missing branch'; config = [ordered]@{ validations = @([ordered]@{ globset = 'a' }) } }
        @{ why = 'an empty branch'; config = [ordered]@{ branch = ' '; validations = @([ordered]@{ globset = 'a' }) } }
        @{ why = 'a missing validations list'; config = [ordered]@{ branch = 'main' } }
        @{ why = 'an empty validations list'; config = [ordered]@{ branch = 'main'; validations = @() } }
        @{ why = 'a non-mapping entry'; config = [ordered]@{ branch = 'main'; validations = @('widget') } }
        @{ why = 'an entry without globset'; config = [ordered]@{ branch = 'main'; validations = @([ordered]@{ pipeline = 'x' }) } }
        @{ why = 'an unknown entry key'; config = [ordered]@{ branch = 'main'; validations = @([ordered]@{ globset = 'a'; nope = 1 }) } }
        @{ why = 'a non-bool blocking'; config = [ordered]@{ branch = 'main'; validations = @([ordered]@{ globset = 'a'; blocking = 'yes' }) } }
        @{ why = 'an empty pipeline'; config = [ordered]@{ branch = 'main'; validations = @([ordered]@{ globset = 'a'; pipeline = ' ' }) } }
        @{ why = 'a duplicate globset entry'; config = [ordered]@{ branch = 'main'; validations = @([ordered]@{ globset = 'a' }, [ordered]@{ globset = 'a' }) } }
    ) {
        { & $script:make $config } | Should -Throw '*build-validation configuration validation failed*'
    }

    It 'collects every violation into one throw' {
        $config = [ordered]@{ branch = ' '; validations = @([ordered]@{ pipeline = ' '; nope = 1 }) }
        $thrown = $null
        try {
            & $script:make $config
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
        $config | Should -BeOfType [Catzc.Azure.DevOps.BuildValidation.BuildValidationConfig]
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
