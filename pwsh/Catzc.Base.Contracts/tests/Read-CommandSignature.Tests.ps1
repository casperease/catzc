Describe 'Read-CommandSignature' -Tag 'L0', 'logic', 'ADR-REPO-CMDCONTRACT-CHECKERPERLANGUAGE' {
    BeforeAll {
        function Read-Fixture {
            param([string] $Body, [string] $Name = 'Get-Widget')
            $file = Join-Path $TestDrive ("$([guid]::NewGuid().ToString('n')).ps1")
            [System.IO.File]::WriteAllText($file, $Body)
            InModuleScope Catzc.Base.Contracts -Parameters @{ Path = $file; Name = $Name } {
                param($Path, $Name)
                Read-CommandSignature -Path $Path -Name $Name
            }
        }
    }

    It 'reads each parameter: type, list, mandatory, pipeline and a constant default' {
        $command = Read-Fixture @'
function Get-Widget {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Contracts.ContractAsset[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [Parameter(ValueFromPipeline)]
        [string[]] $Item,

        [Parameter(Mandatory = $true)]
        [int] $Count,

        [switch] $Strict,

        [string] $Engine = 'auto',

        [int] $Depth = 2,

        [bool] $Fast = $true
    )
}
'@
        $command | Should -BeOfType ([Catzc.Base.Contracts.ContractCommand])
        $command.parameters.Name | Should -Be @('Path', 'Item', 'Count', 'Strict', 'Engine', 'Depth', 'Fast')
        $command.parameters[0].Spec | Should -Be 'string!'
        $command.parameters[1].Spec | Should -Be 'string[] pipeline'
        $command.parameters[2].Spec | Should -Be 'int!'
        $command.parameters[3].Spec | Should -Be 'switch'
        $command.parameters[4].Spec | Should -Be 'string = auto'
        $command.parameters[5].Spec | Should -Be 'int = 2'
        $command.parameters[6].Spec | Should -Be 'bool = true'
        $command.output | Should -Be 'Catzc.Base.Contracts.ContractAsset[]'
    }

    It 'reads a default the command computes as computed, and no parameter block as none' {
        $command = Read-Fixture @'
function Get-Widget {
    param(
        [string] $Root = (Get-Location).Path,
        [string] $Name = $null
    )
}
'@
        $command.parameters[0].Default | Should -Be ([Catzc.Base.Contracts.ContractParameter]::ComputedDefault)
        $command.parameters[1].Default | Should -BeNullOrEmpty
        $command.output | Should -Be 'void'

        $bare = Read-Fixture "function Get-Widget {`n    'gadget'`n}`n"
        $bare.parameters.Count | Should -Be 0
        $bare.output | Should -Be 'void'
    }

    It 'keeps a type outside the contract set by its own name, so the comparison names it' {
        $command = Read-Fixture @'
function Get-Widget {
    [OutputType('System.String')]
    param(
        [System.Collections.IDictionary] $Map,
        $Loose
    )
}
'@
        $command.parameters[0].Type | Should -Be 'System.Collections.IDictionary'
        $command.parameters[1].Type | Should -Be 'object'
        $command.output | Should -Be 'string'
    }

    It 'reads parameter sets: the sets a parameter names, every set when it names none, and the default set' -Tag 'ADR-REPO-CMDCONTRACT-CONTRACTLANGUAGE' {
        $command = Read-Fixture @'
function Get-Widget {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param(
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Id')]
        [string] $Id,

        [Parameter(ParameterSetName = 'All')]
        [Parameter(ParameterSetName = 'Random')]
        [switch] $Spare,

        [Parameter()]
        [switch] $Quiet,

        [int] $Depth
    )
}
'@
        $command.parameters[0].Spec | Should -Be 'string! in Id'
        $command.parameters[1].Spec | Should -Be 'switch in All,Random'
        $command.parameters[2].Spec | Should -Be 'switch'
        $command.parameters[3].Spec | Should -Be 'int'
        $command.default_set | Should -Be 'All'
    }

    It 'refuses a parameter that is mandatory in one set and optional in another' -Tag 'ADR-REPO-CMDCONTRACT-CONTRACTLANGUAGE' {
        {
            Read-Fixture @'
function Get-Widget {
    param(
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Parameter(ParameterSetName = 'All')]
        [string] $Id
    )
}
'@
        } | Should -Throw "*parameter 'Id' of 'Get-Widget' is mandatory in some parameter sets and optional in others*"
    }

    It 'throws when the file defines no function of that name' {
        { Read-Fixture "function Get-Gadget {`n    param([string] `$Path)`n}`n" } | Should -Throw "*defines no function 'Get-Widget'*"
    }

    It 'throws when the file does not parse' {
        { Read-Fixture "function Get-Widget {`n    param([string] `$Path`n" } | Should -Throw '*does not parse*'
    }
}
