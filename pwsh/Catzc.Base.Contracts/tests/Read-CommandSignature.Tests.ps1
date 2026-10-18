Describe 'Read-CommandSignature' -Tag 'L0', 'logic', 'ADR-REPO-CMDCONTRACT#4' {
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

    It 'throws when the file defines no function of that name' {
        { Read-Fixture "function Get-Gadget {`n    param([string] `$Path)`n}`n" } | Should -Throw "*defines no function 'Get-Widget'*"
    }

    It 'throws when the file does not parse' {
        { Read-Fixture "function Get-Widget {`n    param([string] `$Path`n" } | Should -Throw '*does not parse*'
    }
}
