<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Contracts/tests/Get-CommandContract.Tests.ps1
    folder: tests
    name: get-command-contract-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-REPO-CMDCONTRACT#5
---
#>

Describe 'Get-CommandContract' -Tag 'L0', 'logic', 'ADR-REPO-CMDCONTRACT#5' {
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
            [pscustomobject]@{ name = $Name; root = "automation/$Name"; languages = @('powershell') }
        }
        Add-Asset 'widget/0.0.0/Catzc.Widget/Get-Widget.command.yml' "parameters:`n  Path: string!`n  Strict: switch`noutput: string`n"
        Add-Asset 'widget/0.0.0/Catzc.Widget/Set-Widget.command.yml' ''
        Add-Asset 'widget/0.0.0/Catzc.Gadget/Get-Gadget.command.yml' "parameters:`n  Count: int = 2`n"
        Add-Asset 'widget/0.0.0/Catzc.Gadget/gadget.yml' 'gadget: 1'
    }

    It 'returns every command contract of the draft as a typed record, in asset order' {
        $commands = @(Get-CommandContract -RepositoryRoot $script:root)
        $commands | Should -BeOfType ([Catzc.Base.Contracts.ContractCommand])
        $commands.Name | Should -Be @('Get-Gadget', 'Get-Widget', 'Set-Widget')
        $commands[1].Asset.AssetPath | Should -Be 'contracts/widget/0.0.0/Catzc.Widget/Get-Widget.command.yml'
        $commands[1].Signature | Should -Be 'Path: string!, Strict: switch -> string'
        $commands[2].parameters.Count | Should -Be 0
        $commands[2].output | Should -Be 'void'
    }

    It 'narrows by command name and by module, with wildcards' {
        @(Get-CommandContract -Name 'Get-*' -RepositoryRoot $script:root).Name | Should -Be @('Get-Gadget', 'Get-Widget')
        @(Get-CommandContract -Module Catzc.Widget -RepositoryRoot $script:root).Name | Should -Be @('Get-Widget', 'Set-Widget')
        @(Get-CommandContract Set-Widget -RepositoryRoot $script:root).Name | Should -Be 'Set-Widget'
        @(Get-CommandContract -Name Get-Sprocket -RepositoryRoot $script:root).Count | Should -Be 0
    }

    It 'throws naming the asset when a contract is not written in the contract language' {
        Add-Asset 'widget/0.0.0/Catzc.Gadget/Get-Gadget.command.yml' "parameters:`n  Count: number`n"
        { Get-CommandContract -RepositoryRoot $script:root } |
            Should -Throw "*'contracts/widget/0.0.0/Catzc.Gadget/Get-Gadget.command.yml': command contract validation failed*type 'number' is not one of*"
    }
}
