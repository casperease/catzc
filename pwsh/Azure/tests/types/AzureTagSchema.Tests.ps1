Describe 'AzureTagSchema' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:schema = { param($Raw) [Catzc.Azure.AzureTagSchema]::new($Raw, [System.Collections.Generic.List[string]]::new()) }
        $script:errorsOf = {
            param($Raw)
            $errors = [System.Collections.Generic.List[string]]::new()
            $null = [Catzc.Azure.AzureTagSchema]::new($Raw, $errors)
            @($errors)
        }
        $script:good = [ordered]@{
            workload = 'widget'; environment = 'nonprod'; owner = 'gadget'; 'cost-center' = 'gadget'; criticality = 'low'
            'data-classification' = 'internal'
        }
    }

    It 'takes the shipped defaults when azure.yml has no tags section' {
        $tags = & $schema $null
        @($tags.keys.Keys) | Should -Be @('workload', 'environment', 'owner', 'cost-center', 'criticality', 'data-classification')
        $tags.provenance['branch'] | Should -Be 'deployed-from-branch'
    }

    It 'passes tags that hold to the schema, provenance tags of any template prefix included' {
        $tagged = [ordered]@{} + $good
        $tagged['deployed-from-commit'] = 'Ab12Cd'
        $tagged['widget-deployed-from-branch'] = 'refs/heads/main'
        (& $schema $null).TagErrors($tagged) | Should -BeNullOrEmpty
    }

    It 'reports a dropped key, a misspelled value and a value that is not lowercase' {
        $broken = [ordered]@{} + $good
        $broken.Remove('owner')
        $broken['criticality'] = 'urgent'
        $broken['workload'] = 'Widget'
        $found = @((& $schema $null).TagErrors($broken))
        $found | Should -Contain 'misses the CAF tag(s) owner'
        $found | Should -Contain "tag criticality 'urgent' is not one of low, medium, high"
        $found | Should -Contain "tag workload 'Widget' is not lowercase"
    }

    It 'reports a data-classification outside its closed set' {
        $unknown = [ordered]@{} + $good
        $unknown['data-classification'] = 'secret'
        @((& $schema $null).TagErrors($unknown)) |
            Should -Be @("tag data-classification 'secret' is not one of public, internal, confidential, restricted")
    }

    It 'rejects a schema whose key, value or provenance name is not lowercase, or that misses a provenance name' {
        & $errorsOf @{ keys = @{ Workload = @() } } | Should -Contain "tags.keys: 'Workload' is not lowercase"
        & $errorsOf @{ keys = @{ criticality = @('High') } } | Should -Contain "tags.keys['criticality']: value 'High' is not lowercase"
        & $errorsOf @{ provenance = @{ commit = 'Deployed_From_Commit'; build_id = 'b'; branch = 'c' } } |
            Should -Contain "tags.provenance['commit']: 'Deployed_From_Commit' is not lowercase"
        & $errorsOf @{ provenance = @{ commit = 'a'; build_id = 'b' } } | Should -Contain "tags.provenance misses 'branch'"
        & $errorsOf @{ widget = 1 } | Should -Contain "tags: unknown key 'widget' (allowed: keys, provenance)"
    }
}
