Describe 'Get-ContractTypeFindings' -Tag 'L0', 'logic', 'ADR-REPO-CONTRACT-BINDINGINTERFACE' {
    BeforeAll {
        function Add-File {
            param([string] $Relative, [string] $Content)
            $file = Join-Path $script:root $Relative
            $null = [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($file))
            [System.IO.File]::WriteAllText($file, $Content)
        }
        $script:find = {
            param([object[]] $Commands)
            InModuleScope Catzc.Base.Contracts -Parameters @{ Root = $script:root; Commands = $Commands } {
                param($Root, $Commands)
                $script:mockedCommands = $Commands
                Mock Get-CommandContract { $script:mockedCommands }
                Mock Get-ContractGroup { 'pwsh.' + ($Module.Substring('Catzc.'.Length).ToLowerInvariant()) }
                @(Get-ContractTypeFindings -Version '0.1.0' -RepositoryRoot $Root)
            }
        }
        $script:command = {
            param([string[]] $ParameterTypes, [string] $Output)
            [pscustomobject]@{
                parameters = @($ParameterTypes | ForEach-Object { [pscustomobject]@{ Type = $_ } })
                output     = $Output
                Asset      = [pscustomobject]@{ AssetPath = 'contracts/catzc/0.1.0/pwsh.widgets/get_widget.command.yml' }
            }
        }
    }

    BeforeEach {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        Add-File 'contracts/catzc/0.1.0/pwsh.widgets/types.json' '{ "types": [ { "name": "Catzc.Widgets.WidgetRecord", "aliases": [], "display": [], "members": [] } ] }'
    }

    It 'passes a command whose parameter and output types a types surface lists, and skips base types' {
        @(& $script:find @(& $script:command @('string', 'catzc.widgets.widget_record[]') 'catzc.widgets.widget_record')) |
            Should -BeNullOrEmpty
    }

    It 'reports a parameter type no types surface lists' {
        $findings = @(& $script:find @(& $script:command @('catzc.widgets.gadget') 'string'))
        $findings | Should -HaveCount 1
        $findings[0] | Should -BeLike "*get_widget.command.yml names the type 'catzc.widgets.gadget', which no group's types.json lists*"
    }

    It 'reports an output type no types surface lists' {
        (& $script:find @(& $script:command @() 'catzc.widgets.sprocket[]')) | Should -BeLike "*'catzc.widgets.sprocket'*"
    }

    It 'reports a types surface in a group that is not its module''s' {
        Add-File 'contracts/catzc/0.1.0/pwsh.gadgets/types.json' '{ "types": [ { "name": "Catzc.Sprockets.Sprocket", "aliases": [], "display": [], "members": [] } ] }'
        (& $script:find @()) | Should -BeLike "*pwsh.gadgets/types.json lists types of Catzc.Sprockets, whose contract group is 'pwsh.sprockets'*"
    }
}

Describe 'the types surface file name' -Tag 'L0', 'logic', 'ADR-REPO-CONTRACT-BINDINGINTERFACE' {
    It 'is the same in the bootstrap writer''s Get-TypesContractPath and on ContractLayout' {
        Import-Module (Join-Path (Get-CatzcModulesRoot) '.internal/Catzc.Internal.Types.psm1') -Force
        $root = Join-Path $TestDrive 'surface'
        $null = [System.IO.Directory]::CreateDirectory((Join-Path $root 'contracts/catzc/0.1.0/pwsh.widgets'))
        $path = InModuleScope Catzc.Internal.Types -Parameters @{ Root = $root } {
            param($Root)
            Get-TypesContractPath -RepositoryRoot $Root -Namespace Catzc.Widgets
        }
        [System.IO.Path]::GetFileName($path) | Should -BeExactly ([Catzc.Base.Contracts.ContractLayout]::TypesSurfaceName)
    }
}
