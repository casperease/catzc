Describe 'New-Npmrc' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:source = $null
        Mock Get-Config -ModuleName Catzc.Base.Languages -ParameterFilter { $Config -eq 'javascript' } { [pscustomobject] @{ package_source = $script:source } }
        $script:render = {
            param([string] $Url, [string] $VariableName = '')
            $script:source = [pscustomobject] @{ name = 'widget'; url = $Url; credential_env = $VariableName }
            New-Npmrc
        }
    }

    It 'renders the public registry and no token line for the default source' {
        $lines = @((& $script:render 'https://registry.npmjs.org') -split "`n" | Where-Object { $_ })
        $lines | Should -HaveCount 1
        $lines[0] | Should -BeExactly 'registry=https://registry.npmjs.org/'
    }

    It 'keeps exactly one trailing slash on the registry' {
        $lines = @((& $script:render 'https://feed.widget.example/npm//') -split "`n" | Where-Object { $_ })
        $lines[0] | Should -BeExactly 'registry=https://feed.widget.example/npm/'
    }

    It 'renders the token line with the variable reference when the source names a credential' {
        $lines = @((& $script:render 'https://feed.widget.example/npm' 'WIDGET_TOKEN') -split "`n" | Where-Object { $_ })
        $lines | Should -HaveCount 2
        $lines[1] | Should -BeExactly '//feed.widget.example/npm/:_authToken=${WIDGET_TOKEN}'
    }

    It 'ends with one line feed and carries no head of its own' {
        $text = & $script:render 'https://registry.npmjs.org'
        $text | Should -BeExactly "registry=https://registry.npmjs.org/`n"
    }
}
