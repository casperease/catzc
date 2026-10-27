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
                [Catzc.Base.Execution.NetworkCallsConfig]::new([ordered]@{ sites = [ordered]@{ 'pwsh/Widget/Get-Widget.ps1#Get-Widget' = $entry } })
            }
        }

        It 'defaults to no sites when the file is empty' {
            [Catzc.Base.Execution.NetworkCallsConfig]::new($null).sites.Count | Should -Be 0
        }

        It 'reads a site with its file, function, class, trigger and guard' {
            $site = (& $script:make (& $script:site)).sites['pwsh/Widget/Get-Widget.ps1#Get-Widget']
            $site.path | Should -BeExactly 'pwsh/Widget/Get-Widget.ps1'
            $site.name | Should -BeExactly 'Get-Widget'
            $site.class | Should -BeExactly 'package-install'
            $site.trigger | Should -BeExactly 'on-request'
            $site.IsViolation | Should -BeFalse
        }

        It 'marks a default-path site as a violation' {
            (& $script:make (& $script:site @{ trigger = 'default-path' })).sites['pwsh/Widget/Get-Widget.ps1#Get-Widget'].IsViolation | Should -BeTrue
        }

        It 'keeps two sites of one file apart, each with its own class' {
            $config = [Catzc.Base.Execution.NetworkCallsConfig]::new([ordered]@{
                    sites = [ordered]@{
                        'pipelines/widget.yaml#WidgetInstall' = (& $script:site)
                        'pipelines/widget.yaml#GadgetDeploy'  = (& $script:site @{ class = 'azure-control-plane'; trigger = 'pipeline-only' })
                    }
                })
            $config.sites['pipelines/widget.yaml#WidgetInstall'].class | Should -BeExactly 'package-install'
            $config.sites['pipelines/widget.yaml#GadgetDeploy'].class | Should -BeExactly 'azure-control-plane'
        }

        It 'rejects a site key without its function or step (<Key>)' -ForEach @(
            @{ Key = 'pwsh/Widget/Get-Widget.ps1' }, @{ Key = '#Get-Widget' }, @{ Key = 'pwsh/Widget/Get-Widget.ps1#' }
        ) {
            { [Catzc.Base.Execution.NetworkCallsConfig]::new([ordered]@{ sites = [ordered]@{ $Key = (& $script:site) } }) } |
                Should -Throw "*must be keyed '<file>#<function or step>'*"
        }

        It 'rejects an unknown top-level key' {
            { [Catzc.Base.Execution.NetworkCallsConfig]::new([ordered]@{ gadget = 1 }) } | Should -Throw '*unknown key*gadget*'
        }

        It 'rejects sites that are not a map' {
            { [Catzc.Base.Execution.NetworkCallsConfig]::new([ordered]@{ sites = 'gadget' }) } | Should -Throw '*sites must be a map*'
        }

        It 'rejects a site that is not a map' {
            { [Catzc.Base.Execution.NetworkCallsConfig]::new([ordered]@{ sites = [ordered]@{ 'pwsh/Widget/Get-Widget.ps1#Get-Widget' = 'gadget' } }) } |
                Should -Throw '*must be a map*'
        }

        It 'rejects an unknown site key' {
            { & $script:make (& $script:site @{ gadget = 'x' }) } | Should -Throw "*unknown key 'gadget'*"
        }

        It 'rejects a class outside the six' {
            { & $script:make (& $script:site @{ class = 'gadget-feed' }) } | Should -Throw "*class 'gadget-feed' is not one of*"
        }

        It 'accepts the release-publish class' {
            (& $script:make (& $script:site @{ class = 'release-publish'; trigger = 'pipeline-only' })).sites.Values |
                ForEach-Object class | Should -BeExactly 'release-publish'
        }

        It 'rejects a trigger outside the four' {
            { & $script:make (& $script:site @{ trigger = 'sometimes' }) } | Should -Throw "*trigger 'sometimes' is not one of*"
        }

        It 'requires <Key>' -ForEach @(@{ Key = 'class' }, @{ Key = 'trigger' }, @{ Key = 'gated_by' }) {
            $entry = & $script:site
            $entry.Remove($Key)
            { & $script:make $entry } | Should -Throw "*$Key is required*"
        }

        It 'defaults to no patterns and the declared skip paths' {
            $config = [Catzc.Base.Execution.NetworkCallsConfig]::new($null)
            $config.patterns.Count | Should -Be 0
            $config.skip | Should -Contain '*/tests/*'
            $config.Matches('Invoke-WidgetFetch') | Should -BeNullOrEmpty
        }

        It 'names every pattern one line matches, in declaration order' {
            $config = [Catzc.Base.Execution.NetworkCallsConfig]::new([ordered]@{
                    patterns = [ordered]@{ 'widget-fetch' = '\bInvoke-WidgetFetch\b'; 'gadget-pull' = '\bgadget pull\b' }
                })
            $config.patterns.Count | Should -Be 2
            $config.Matches('Invoke-WidgetFetch; gadget pull') | Should -Be @('widget-fetch', 'gadget-pull')
            $config.Matches('Get-Widget') | Should -BeNullOrEmpty
        }

        It 'reads a skip list in place of the default' {
            $config = [Catzc.Base.Execution.NetworkCallsConfig]::new([ordered]@{ skip = @('widgets/*') })
            $config.skip | Should -Be @('widgets/*')
        }

        It 'rejects patterns that are not a map' {
            { [Catzc.Base.Execution.NetworkCallsConfig]::new([ordered]@{ patterns = 'gadget' }) } | Should -Throw '*patterns must be a map*'
        }

        It 'rejects an empty pattern' {
            { [Catzc.Base.Execution.NetworkCallsConfig]::new([ordered]@{ patterns = [ordered]@{ widget = '' } }) } |
                Should -Throw "*patterns 'widget' is empty*"
        }

        It 'rejects a pattern that is not a regular expression' {
            { [Catzc.Base.Execution.NetworkCallsConfig]::new([ordered]@{ patterns = [ordered]@{ widget = '(' } }) } |
                Should -Throw "*patterns 'widget' is not a regular expression*"
        }

        It 'rejects a skip entry that is blank' {
            { [Catzc.Base.Execution.NetworkCallsConfig]::new([ordered]@{ skip = @('widgets/*', ' ') }) } | Should -Throw '*skip must be a list*'
        }
    }
}
