# cspell:ignore ndeployment nresource nsubscription toolong
Describe 'Read-BicepTemplateOptions' -Tag 'L0', 'logic' {
    BeforeAll {
        # Private function — invoke it inside the module's scope.
        $script:invoke = {
            param($Folder)
            & (Get-Module Catzc.Azure.Templates) { Read-BicepTemplateOptions $args[0] } $Folder
        }
    }

    BeforeEach {
        $script:folder = Join-Path ([IO.Path]::GetTempPath()) ('catzc-options-' + [Guid]::NewGuid())
        New-Item -ItemType Directory -Path $script:folder -Force | Out-Null
    }

    AfterEach {
        if ($script:folder -and (Test-Path $script:folder)) {
            Remove-Item $script:folder -Recurse -Force
        }
    }

    It 'returns an empty dict when no options.yml is present' {
        $result = & $script:invoke $script:folder
        $result | Should -BeOfType ([System.Collections.Specialized.OrderedDictionary])
        $result.Count | Should -Be 0
    }

    It 'returns an empty dict for a comment-only options.yml' {
        Set-Content (Join-Path $script:folder 'options.yml') -Value '# nothing here'
        $result = & $script:invoke $script:folder
        $result.Count | Should -Be 0
    }

    It 'returns only the key present for a partial override' {
        Set-Content (Join-Path $script:folder 'options.yml') -Value 'deployment_mode: Complete'
        $result = & $script:invoke $script:folder
        $result.Count | Should -Be 1
        $result.deployment_mode | Should -Be 'Complete'
        $result.Contains('deployment_target') | Should -BeFalse
    }

    It 'returns both keys for a full override' {
        Set-Content (Join-Path $script:folder 'options.yml') -Value "deployment_mode: DoNotRun`ndeployment_target: Subscription"
        $result = & $script:invoke $script:folder
        $result.deployment_mode | Should -Be 'DoNotRun'
        $result.deployment_target | Should -Be 'Subscription'
    }

    It 'parses a short_name' {
        Set-Content (Join-Path $script:folder 'options.yml') -Value 'short_name: smpl'
        $result = & $script:invoke $script:folder
        $result.short_name | Should -Be 'smpl'
    }

    It 'parses a customer_deployment boolean' {
        Set-Content (Join-Path $script:folder 'options.yml') -Value 'customer_deployment: true'
        $result = & $script:invoke $script:folder
        $result.customer_deployment | Should -BeTrue
    }

    It 'throws on a non-boolean customer_deployment' {
        Set-Content (Join-Path $script:folder 'options.yml') -Value 'customer_deployment: maybe'
        { & $script:invoke $script:folder } | Should -Throw '*invalid customer_deployment*'
    }

    It 'throws on a malformed short_name' {
        Set-Content (Join-Path $script:folder 'options.yml') -Value 'short_name: TOOLONG'
        { & $script:invoke $script:folder } | Should -Throw '*invalid short_name*'
    }

    It 'rejects the removed indexed key as unknown' {
        Set-Content (Join-Path $script:folder 'options.yml') -Value 'indexed: true'
        { & $script:invoke $script:folder } | Should -Throw '*unknown key*indexed*'
    }

    It 'throws on an invalid deployment_mode, naming the valid set' {
        Set-Content (Join-Path $script:folder 'options.yml') -Value 'deployment_mode: Sideways'
        { & $script:invoke $script:folder } | Should -Throw '*invalid deployment_mode*Incremental*Complete*DoNotRun*'
    }

    It 'throws on an invalid deployment_target, naming the valid set' {
        Set-Content (Join-Path $script:folder 'options.yml') -Value 'deployment_target: Tenant'
        { & $script:invoke $script:folder } | Should -Throw '*invalid deployment_target*ResourceGroup*Subscription*'
    }

    It 'throws on an unknown key (strict schema)' {
        Set-Content (Join-Path $script:folder 'options.yml') -Value "deployment_mode: Incremental`nresource_group: rg-typo"
        { & $script:invoke $script:folder } | Should -Throw "*unknown key 'resource_group'*"
    }

    It 'rejects the removed slotted key (slot is per-config, not a template bit)' {
        Set-Content (Join-Path $script:folder 'options.yml') -Value 'slotted: true'
        { & $script:invoke $script:folder } | Should -Throw "*unknown key 'slotted'*"
    }

    It 'parses environment_kind' {
        Set-Content (Join-Path $script:folder 'options.yml') -Value 'environment_kind: subscription'
        (& $script:invoke $script:folder).environment_kind | Should -Be 'subscription'
    }

    It 'throws on an invalid environment_kind, naming the valid set' {
        Set-Content (Join-Path $script:folder 'options.yml') -Value 'environment_kind: tenant'
        { & $script:invoke $script:folder } | Should -Throw '*invalid environment_kind*standard*subscription*'
    }

    It 'rejects the removed subscription_groups key as unknown (templates target subscriptions by config folder now)' {
        Set-Content (Join-Path $script:folder 'options.yml') -Value "short_name: smpl`nsubscription_groups: [shared, customer]"
        { & $script:invoke $script:folder } | Should -Throw '*unknown key*subscription_groups*'
    }
}
