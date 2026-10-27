Describe 'NetworkCallsConfig' -Tag 'L0' {
    Context 'integrity (shipped network-calls.yml)' -Tag 'integrity' {
        It 'accepts the shipped network-calls.yml' {
            $path = Join-Path $PSScriptRoot '../../configs/network-calls.yml'
            $config = Get-Content $path -Raw | ConvertFrom-Yaml -Ordered
            { [Catzc.Base.Execution.NetworkCallsConfig]::new($config) } | Should -Not -Throw
        }
    }

    Context 'logic (inline configs)' -Tag 'logic' {
        BeforeAll {
            $script:site = {
                param([hashtable] $extra = @{})
                $entry = [ordered]@{
                    function = 'Get-Widget'
                    class    = 'package-install'
                    trigger  = 'on-request'
                    gated_by = 'an explicit widget command'
                }
                foreach ($key in $extra.Keys) {
                    $entry[$key] = $extra[$key]
                }
                $entry
            }
            $script:make = {
                param($entry)
                [Catzc.Base.Execution.NetworkCallsConfig]::new([ordered]@{ sites = [ordered]@{ 'pwsh/Widget/Get-Widget.ps1' = $entry } })
            }
        }

        It 'defaults to no sites when the file is empty' {
            [Catzc.Base.Execution.NetworkCallsConfig]::new($null).sites.Count | Should -Be 0
        }

        It 'reads a site with its class, trigger and guard' {
            $site = (& $script:make (& $script:site)).sites['pwsh/Widget/Get-Widget.ps1']
            $site.class | Should -BeExactly 'package-install'
            $site.trigger | Should -BeExactly 'on-request'
            $site.IsViolation | Should -BeFalse
        }

        It 'marks a default-path site as a violation' {
            (& $script:make (& $script:site @{ trigger = 'default-path' })).sites['pwsh/Widget/Get-Widget.ps1'].IsViolation | Should -BeTrue
        }

        It 'rejects an unknown top-level key' {
            { [Catzc.Base.Execution.NetworkCallsConfig]::new([ordered]@{ gadget = 1 }) } | Should -Throw '*unknown key*gadget*'
        }

        It 'rejects sites that are not a map' {
            { [Catzc.Base.Execution.NetworkCallsConfig]::new([ordered]@{ sites = 'gadget' }) } | Should -Throw '*sites must be a map*'
        }

        It 'rejects a site that is not a map' {
            { [Catzc.Base.Execution.NetworkCallsConfig]::new([ordered]@{ sites = [ordered]@{ 'pwsh/Widget/Get-Widget.ps1' = 'gadget' } }) } |
                Should -Throw '*must be a map*'
        }

        It 'rejects an unknown site key' {
            { & $script:make (& $script:site @{ gadget = 'x' }) } | Should -Throw "*unknown key 'gadget'*"
        }

        It 'rejects a class outside the five' {
            { & $script:make (& $script:site @{ class = 'gadget-feed' }) } | Should -Throw "*class 'gadget-feed' is not one of*"
        }

        It 'rejects a trigger outside the four' {
            { & $script:make (& $script:site @{ trigger = 'sometimes' }) } | Should -Throw "*trigger 'sometimes' is not one of*"
        }

        It 'requires <Key>' -ForEach @(@{ Key = 'function' }, @{ Key = 'class' }, @{ Key = 'trigger' }, @{ Key = 'gated_by' }) {
            $entry = & $script:site
            $entry.Remove($Key)
            { & $script:make $entry } | Should -Throw "*$Key is required*"
        }
    }
}
