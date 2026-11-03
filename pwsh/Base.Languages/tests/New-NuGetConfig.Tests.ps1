Describe 'New-NuGetConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        function Get-Elements {
            param($Document, [string] $Section)
            @($Document.configuration.SelectSingleNode($Section).ChildNodes | Where-Object { $_.NodeType -eq 'Element' })
        }
    }

    It 'renders the default source after clear and clears the audit sources' {
        [xml] $document = New-NuGetConfig
        $packages = @(Get-Elements $document 'packageSources')
        $packages | Should -HaveCount 2
        $packages[0].LocalName | Should -Be 'clear'
        $packages[1].GetAttribute('key') | Should -Be 'nuget'
        $packages[1].GetAttribute('value') | Should -Be 'https://api.nuget.org/v3/index.json'
        $document.configuration.SelectSingleNode('packageSourceCredentials') | Should -BeNullOrEmpty
        $audit = @(Get-Elements $document 'auditSources')
        $audit | Should -HaveCount 1
        $audit[0].LocalName | Should -Be 'clear'
    }

    It 'renders a widget source with its credential as a variable reference, never a value' {
        Mock Get-Config -ModuleName Catzc.Base.Languages -ParameterFilter { $Config -eq 'bcl' } {
            [Catzc.Base.Languages.BclConfig]::new([ordered]@{
                    package_source = [ordered]@{ name = 'widget'; url = 'https://widget.example/v3/index.json'; credential_env = 'WIDGET_TOKEN' }
                })
        }
        $env:WIDGET_TOKEN = 'secret-widget-value'
        try {
            $text = New-NuGetConfig
        }
        finally {
            Remove-Item Env:WIDGET_TOKEN
        }
        $text | Should -Not -BeLike '*secret-widget-value*'
        [xml] $document = $text
        @(Get-Elements $document 'packageSources')[1].GetAttribute('key') | Should -Be 'widget'
        $credentials = @($document.configuration.packageSourceCredentials.widget.add)
        $credentials | Should -HaveCount 2
        $credentials[0].key | Should -Be 'Username'
        $credentials[1].key | Should -Be 'ClearTextPassword'
        $credentials[1].value | Should -Be '%WIDGET_TOKEN%'
    }

    It 'renders a config the guard accepts' {
        $root = Join-Path $TestDrive 'widget-repo'
        [System.IO.Directory]::CreateDirectory((Join-Path $root 'gadgets')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $root 'nuget.config'), (New-NuGetConfig))
        { Assert-DotnetOffline 'gadgets' -RepositoryRoot $root } | Should -Not -Throw
    }
}
