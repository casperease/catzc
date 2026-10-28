Describe 'ServiceConnectionsConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        function script:New-WidgetIdentity {
            param([hashtable] $Extra = @{})
            $body = [ordered]@{ role = 'wd'; templates = @('widget'); azure_role = 'owner'; description = 'Deploys the widget.' }
            foreach ($key in $Extra.Keys) {
                $body[$key] = $Extra[$key]
            }
            $body
        }
    }

    It 'reads each identity in file order, with the ado short name by default' {
        $config = [Catzc.Azure.Templates.ServiceConnectionsConfig]::new([ordered]@{
                identities = [ordered]@{
                    widget = New-WidgetIdentity
                    gadget = New-WidgetIdentity @{ role = 'gd'; templates = @('gadget', 'widget') }
                }
            })
        @($config.identities.Keys) | Should -Be @('widget', 'gadget')
        $config.short_name | Should -BeExactly 'ado'
        $config.identities['widget'].azure_role | Should -BeExactly 'owner'
        $config.identities['gadget'].role | Should -BeExactly 'gd'
        @($config.identities['gadget'].templates) | Should -Be @('gadget', 'widget')
    }

    It 'takes the file''s short name in place of the default' {
        $config = [Catzc.Azure.Templates.ServiceConnectionsConfig]::new([ordered]@{ identities = [ordered]@{ widget = New-WidgetIdentity }; short_name = 'wdg' })
        $config.short_name | Should -BeExactly 'wdg'
    }

    It 'has no way to configure a scheme or a stored secret' {
        $thrown = { [Catzc.Azure.Templates.ServiceConnectionsConfig]::new([ordered]@{
                    identities = [ordered]@{
                        widget = New-WidgetIdentity @{ scheme = 'ServicePrincipal' }
                        gadget = New-WidgetIdentity @{ role = 'gd'; secret = 'sprocket' }
                    }
                }) } | Should -Throw -PassThru
        $thrown.Exception.InnerException.Message | Should -BeLike "*identity 'widget': unknown key 'scheme'*WorkloadIdentityFederation*"
        $thrown.Exception.InnerException.Message | Should -BeLike "*identity 'gadget': unknown key 'secret'*"
    }

    It 'refuses <case>' -ForEach @(
        @{ case = 'no configuration'; raw = $null; message = '*must be a mapping*' }
        @{ case = 'an unknown top-level key'; raw = @{ identities = @{ widget = @{} }; sprocket = 1 }; message = "*unknown top-level key 'sprocket'*" }
        @{ case = 'no identities'; raw = @{ identities = @{} }; message = "*'identities' must be a non-empty map*" }
        @{ case = 'a short name the namer refuses'; raw = @{ identities = @{}; short_name = 'Widgets' }; message = '*short_name must be 2-5*' }
        @{ case = 'an identity name that is not kebab-case'; raw = @{ identities = @{ Widget_One = @{} } }; message = "*identity 'Widget_One': the name must be*" }
        @{ case = 'an identity that is not a map'; raw = @{ identities = @{ widget = 'wd' } }; message = "*identity 'widget' must be a map*" }
    ) {
        $thrown = { [Catzc.Azure.Templates.ServiceConnectionsConfig]::new($raw) } | Should -Throw -PassThru
        $thrown.Exception.InnerException.Message | Should -BeLike $message
    }

    It 'refuses an identity with <case>' -ForEach @(
        @{ case = 'a role the namer refuses'; extra = @{ role = 'w' }; message = '*role must be 2-3*' }
        @{ case = 'no templates'; extra = @{ templates = @() }; message = '*needs templates*' }
        @{ case = 'templates that are not a list'; extra = @{ templates = 'widget' }; message = '*needs templates*' }
        @{ case = 'an empty template name'; extra = @{ templates = @('widget', ' ') }; message = '*a template name is empty*' }
        @{ case = 'a scope, since every connection spans its subscription'; extra = @{ scope = 'resourceGroup' }; message = "*unknown key 'scope'*" }
        @{ case = 'no azure role'; extra = @{ azure_role = '' }; message = '*needs azure_role*' }
        @{ case = 'no description'; extra = @{ description = ' ' }; message = '*needs a description*' }
    ) {
        $thrown = { [Catzc.Azure.Templates.ServiceConnectionsConfig]::new([ordered]@{ identities = [ordered]@{ widget = New-WidgetIdentity $extra } }) } |
            Should -Throw -PassThru
        $thrown.Exception.InnerException.Message | Should -BeLike $message
    }

    It 'refuses two identities with one role, since their connection names would collide' {
        $thrown = { [Catzc.Azure.Templates.ServiceConnectionsConfig]::new([ordered]@{
                    identities = [ordered]@{ widget = New-WidgetIdentity; gadget = New-WidgetIdentity }
                }) } | Should -Throw -PassThru
        $thrown.Exception.InnerException.Message | Should -BeLike "*identity 'gadget': role 'wd' is another identity's*"
    }
}
