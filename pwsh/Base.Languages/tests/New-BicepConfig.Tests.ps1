Describe 'New-BicepConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        $null = New-Item -ItemType Directory -Path (Join-Path $script:root 'widgets') -Force
        $script:url = 'mcr.microsoft.com/bicep'
        $script:analyzers = [ordered]@{ core = [ordered]@{ enabled = $true; verbose = $false } }
        Mock Get-Config -ModuleName Catzc.Base.Languages -ParameterFilter { $Config -eq 'bicep' } {
            [pscustomobject] @{ package_source = [pscustomobject] @{ name = 'widget'; url = $script:url; credential_env = '' }; analyzers = $script:analyzers }
        }
        Mock Get-Track -ModuleName Catzc.Base.Languages {
            [pscustomobject] @{ name = 'widget_track'; languages = @('bicep'); places = @('widgets', 'missing') }
            [pscustomobject] @{ name = 'gadget_track'; languages = @('yaml'); places = @('gadgets') }
        }
        $script:render = {
            param([string] $Url, [string] $Target = '*')
            $script:url = $Url
            New-BicepConfig -RepositoryRoot $script:root -Target $Target
        }
    }

    It 'renders the registry alias with the host and the module path split' {
        $file = & $script:render 'widget.azurecr.io/modules'
        $json = $file.Content | ConvertFrom-Json
        $json.moduleAliases.br.widget.registry | Should -BeExactly 'widget.azurecr.io'
        $json.moduleAliases.br.widget.modulePath | Should -BeExactly 'modules'
    }

    It 'splits the default public registry into mcr.microsoft.com and bicep' {
        $json = (& $script:render 'mcr.microsoft.com/bicep').Content | ConvertFrom-Json
        $json.moduleAliases.br.widget.registry | Should -BeExactly 'mcr.microsoft.com'
        $json.moduleAliases.br.widget.modulePath | Should -BeExactly 'bicep'
    }

    It 'renders no module path when the source is a bare host' {
        $json = (& $script:render 'widget.azurecr.io').Content | ConvertFrom-Json
        $json.moduleAliases.br.widget.registry | Should -BeExactly 'widget.azurecr.io'
        $json.moduleAliases.br.widget.PSObject.Properties.Name | Should -Not -Contain 'modulePath'
    }

    It 'renders the analyzers the config declares' {
        $json = (& $script:render 'mcr.microsoft.com/bicep').Content | ConvertFrom-Json
        $json.analyzers.core.enabled | Should -BeTrue
        $json.analyzers.core.verbose | Should -BeFalse
    }

    It 'renders one file for the track folder that exists, as prettier lays it out' {
        $files = @(& $script:render 'mcr.microsoft.com/bicep')
        $files | Should -HaveCount 1
        $files[0].Target | Should -BeExactly 'widgets/bicepconfig.json'
        ($files[0].Content -split "`n")[0] | Should -BeExactly '{'
        $files[0].Content | Should -BeLike "*}`n"
        $files[0].Content | Should -Not -Match 'credential_env'
    }

    It 'renders nothing for a target that no track folder matches' {
        @(& $script:render 'mcr.microsoft.com/bicep' 'gadgets/bicepconfig.json') | Should -HaveCount 0
    }
}
