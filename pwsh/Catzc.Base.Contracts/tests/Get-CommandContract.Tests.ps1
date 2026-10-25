Describe 'Get-CommandContract' -Tag 'L0', 'logic', 'ADR-REPO-CMDCONTRACT-ONEREADER' {
    BeforeAll {
        function Add-Asset {
            param([string] $Relative, [string] $Content = '')
            $file = Join-Path $script:root "contracts/$Relative"
            $null = New-Item -ItemType Directory -Force -Path ([System.IO.Path]::GetDirectoryName($file))
            [System.IO.File]::WriteAllText($file, $Content)
        }
    }

    BeforeEach {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('n'))
        $null = New-Item -ItemType Directory -Force -Path $script:root
        Mock -ModuleName Catzc.Base.Contracts Get-CatzcModule {
            [pscustomobject]@{ name = $Name; root = "widgets/$Name"; languages = @('powershell') }
        }
        Add-Asset 'widget/0.0.0/catzc.widget/get_widget.command.yml' "parameters:`n  path: string!`n  strict: switch`noutput: string`n"
        Add-Asset 'widget/0.0.0/catzc.widget/set_widget.command.yml' ''
        Add-Asset 'widget/0.0.0/catzc.gadget/get_gadget.command.yml' "parameters:`n  count: int = 2`n"
        Add-Asset 'widget/0.0.0/catzc.gadget/gadget.yml' 'gadget: 1'
    }

    It 'returns every command contract of the draft as a typed record, in asset order' {
        $commands = @(Get-CommandContract -RepositoryRoot $script:root)
        $commands | Should -BeOfType ([Catzc.Base.Contracts.ContractCommand])
        $commands.Name | Should -Be @('get_gadget', 'get_widget', 'set_widget')
        $commands[1].Asset.AssetPath | Should -Be 'contracts/widget/0.0.0/catzc.widget/get_widget.command.yml'
        $commands[1].Signature | Should -Be 'path: string!, strict: switch -> string'
        $commands[2].parameters.Count | Should -Be 0
        $commands[2].output | Should -Be 'void'
    }

    It 'narrows by command name and by module, with wildcards' {
        @(Get-CommandContract -Name 'get_*' -RepositoryRoot $script:root).Name | Should -Be @('get_gadget', 'get_widget')
        @(Get-CommandContract -Module catzc.widget -RepositoryRoot $script:root).Name | Should -Be @('get_widget', 'set_widget')
        @(Get-CommandContract set_widget -RepositoryRoot $script:root).Name | Should -Be 'set_widget'
        @(Get-CommandContract -Name get_sprocket -RepositoryRoot $script:root).Count | Should -Be 0
    }

    It 'throws naming the asset when a contract is not written in the contract language' {
        Add-Asset 'widget/0.0.0/catzc.gadget/get_gadget.command.yml' "parameters:`n  count: number`n"
        { Get-CommandContract -RepositoryRoot $script:root } |
            Should -Throw "*'contracts/widget/0.0.0/catzc.gadget/get_gadget.command.yml': command contract validation failed*type 'number' is not one of*"
    }

    It 'throws naming the asset and the name when a contract names anything outside the normal form' -Tag 'ADR-REPO-CMDCONTRACT-CONTRACTLANGUAGE' {
        Add-Asset 'widget/0.0.0/catzc.gadget/get_gadget.command.yml' "parameters:`n  Count: int`noutput: Catzc.Widgets.WidgetGadget`n"
        { Get-CommandContract -RepositoryRoot $script:root } |
            Should -Throw "*'contracts/widget/0.0.0/catzc.gadget/get_gadget.command.yml': 'Count' is not in the repository normal form, snake*'Catzc' is not*"
    }
}
