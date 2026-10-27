# Shape only at load; each entry's tie to a declared globset and a pipeline is asserted here instead.
Describe 'BuildValidationConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:make = {
            param([System.Collections.IDictionary] $config)
            [Catzc.Azure.DevOps.BuildValidation.BuildValidationConfig]::new($config)
        }
        # Neutral widget/gadget names: the type checks shape only, so a fixture never borrows a real unit's name.
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
        @{ why = 'a non-mapping policies'; config = [ordered]@{ branch = 'main'; validations = @([ordered]@{ globset = 'a' }); policies = 'strict' } }
        @{ why = 'an unknown policy key'; config = [ordered]@{ branch = 'main'; validations = @([ordered]@{ globset = 'a' }); policies = [ordered]@{ nope = 1 } } }
        @{ why = 'a minimum of zero reviewers'; config = [ordered]@{ branch = 'main'; validations = @([ordered]@{ globset = 'a' }); policies = [ordered]@{ minimum_reviewers = 0 } } }
        @{ why = 'an unknown merge type'; config = [ordered]@{ branch = 'main'; validations = @([ordered]@{ globset = 'a' }); policies = [ordered]@{ merge_types = @('fast_forward') } } }
        @{ why = 'no merge type'; config = [ordered]@{ branch = 'main'; validations = @([ordered]@{ globset = 'a' }); policies = [ordered]@{ merge_types = @() } } }
        @{ why = 'a reviewer that is not an id'; config = [ordered]@{ branch = 'main'; validations = @([ordered]@{ globset = 'a' }); policies = [ordered]@{ automatic_reviewer_ids = @('widget-team') } } }
        @{ why = 'a non-bool policy flag'; config = [ordered]@{ branch = 'main'; validations = @([ordered]@{ globset = 'a' }); policies = [ordered]@{ reset_on_push = 'yes' } } }
    ) {
        { & $script:make $config } | Should -Throw '*build-validation configuration validation failed*'
    }

    It 'defaults every policy when the config omits policies: one reviewer, author excluded, reset on push, comments resolved, squash only' {
        $policies = (& $script:make $script:valid).policies
        $policies.minimum_reviewers | Should -Be 1
        $policies.creator_vote_counts | Should -BeFalse
        $policies.reset_on_push | Should -BeTrue
        $policies.require_comment_resolution | Should -BeTrue
        @($policies.automatic_reviewer_ids).Count | Should -Be 0
        $policies.merge_types | Should -Be @('squash')
    }

    It 'takes a team''s raised floor from its config' {
        $config = [ordered]@{ branch = 'main'; validations = @([ordered]@{ globset = 'a' }); policies = [ordered]@{ minimum_reviewers = 2; merge_types = @('squash', 'rebase') } }
        $policies = (& $script:make $config).policies
        $policies.minimum_reviewers | Should -Be 2
        $policies.merge_types | Should -Be @('squash', 'rebase')
        $policies.reset_on_push | Should -BeTrue
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

    It 'declares the main-via-pr policies: at least one reviewer, reset on push, comments resolved, squash only' -Tag 'EDR-AZ-CAF-DEVOPS-R25', 'EDR-AZ-CAF-DEVOPS-R26', 'FDR-GIT-ONESQUASHEDCOMMIT' {
        $policies = (Get-Config -Config build-validation).policies
        $policies.minimum_reviewers | Should -BeGreaterOrEqual 1
        $policies.reset_on_push | Should -BeTrue
        $policies.require_comment_resolution | Should -BeTrue
        $policies.merge_types | Should -Be @('squash')
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
            $pipeline |
                Should -Not -BeNullOrEmpty -Because "entry '$($entry.globset)' must resolve a pipeline (its own key or the globset's annotation)"
        }
    }
}
