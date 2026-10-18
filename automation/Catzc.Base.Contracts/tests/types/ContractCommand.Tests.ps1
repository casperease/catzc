Describe 'ContractCommand' -Tag 'L0', 'logic', 'ADR-REPO-CMDCONTRACT#2' {
    BeforeAll {
        function New-Command {
            param([string] $Yaml)
            [Catzc.Base.Contracts.ContractCommand]::new(($Yaml | ConvertFrom-Yaml -Ordered))
        }
    }

    Context 'the contract language' {
        It 'parses one string per parameter and the output type' {
            $command = New-Command "parameters:`n  Path: string!`n  Strict: switch`n  Engine: string = auto`n  Item: string[]! pipeline`noutput: Catzc.Widgets.Widget`n"
            $command.parameters.Count | Should -Be 4
            $command.parameters[0].Name | Should -Be 'Path'
            $command.parameters[0].Type | Should -Be 'string'
            $command.parameters[0].Mandatory | Should -BeTrue
            $command.parameters[0].IsList | Should -BeFalse
            $command.parameters[0].Default | Should -BeNullOrEmpty
            $command.parameters[0].Pipeline | Should -BeFalse
            $command.parameters[1].Type | Should -Be 'switch'
            $command.parameters[1].Mandatory | Should -BeFalse
            $command.parameters[2].Default | Should -Be 'auto'
            $command.parameters[3].IsList | Should -BeTrue
            $command.parameters[3].Mandatory | Should -BeTrue
            $command.parameters[3].Pipeline | Should -BeTrue
            $command.output | Should -Be 'Catzc.Widgets.Widget'
        }

        It 'declares the defaults once: optional, no default, not from the pipeline, void output' -Tag 'ADR-AUTO-DEFAULT#6' {
            $command = New-Command "parameters:`n  Path: string`n"
            $command.parameters[0].Mandatory | Should -BeFalse
            $command.parameters[0].Default | Should -BeNullOrEmpty
            $command.parameters[0].Pipeline | Should -BeFalse
            $command.output | Should -Be 'void'
            [Catzc.Base.Contracts.ContractCommand]::new($null).parameters.Count | Should -Be 0
            [Catzc.Base.Contracts.ContractCommand]::new(@{}).output | Should -Be 'void'
        }

        It 'reads a parameter back as its spec' {
            [Catzc.Base.Contracts.ContractParameter]::Parse('Item', "string[]! = 'a b' pipeline").Spec | Should -Be "string[]! = 'a b' pipeline"
            [Catzc.Base.Contracts.ContractParameter]::Parse('Engine', 'string = auto').Spec | Should -Be 'string = auto'
            [Catzc.Base.Contracts.ContractParameter]::Parse('Strict', 'switch').Spec | Should -Be 'switch'
        }

        It 'takes an empty default as no default, on both sides' {
            [Catzc.Base.Contracts.ContractParameter]::Parse('Name', "string = ''").Default | Should -BeNullOrEmpty
            [Catzc.Base.Contracts.ContractParameter]::new('Name', 'string', $false, $false, '', $false).Spec | Should -Be 'string'
        }

        It 'names the command from its asset and renders the signature as one line' -Tag 'ADR-REPO-CMDCONTRACT#3' {
            $asset = [Catzc.Base.Contracts.ContractAsset]::new('widget', '0.0.0', 'Catzc.Widget', 'Get-Widget.command.yml',
                [Catzc.Base.Contracts.ContractAssetKind]::Command, 'automation/Catzc.Widget/Get-Widget.ps1',
                [Catzc.Base.Contracts.ContractDirection]::Provided, $false)
            $command = [Catzc.Base.Contracts.ContractCommand]::new($asset, ("parameters:`n  Path: string!`n  Strict: switch`noutput: string`n" | ConvertFrom-Yaml -Ordered))
            $command.Name | Should -Be 'Get-Widget'
            $command.Asset.AssetPath | Should -Be 'contracts/widget/0.0.0/Catzc.Widget/Get-Widget.command.yml'
            $command.Signature | Should -Be 'Path: string!, Strict: switch -> string'
            [Catzc.Base.Contracts.ContractCommand]::new($asset, $null).Signature | Should -Be 'no parameters'
            (New-Command "parameters:`n  Path: string`n").Name | Should -Be ''
            $fragment = [Catzc.Base.Contracts.ContractAsset]::new('widget', '0.0.0', 'Catzc.Widget', 'widget.yml',
                [Catzc.Base.Contracts.ContractAssetKind]::Fragment, 'widget.yml', [Catzc.Base.Contracts.ContractDirection]::DependedOn, $false)
            { [Catzc.Base.Contracts.ContractCommand]::NameOf($fragment) } | Should -Throw '*is not a command contract*'
        }

        It 'collects every violation into one error' {
            $raw = @{
                gadget     = 1
                parameters = [ordered]@{ Path = 'text!'; 'bad name' = 'string'; Strict = 'switch = true'; Item = 'string pipe' }
                output     = 'string!'
            }
            { [Catzc.Base.Contracts.ContractCommand]::new($raw) } |
                Should -Throw "*unknown key 'gadget'*type 'text' is not one of*'bad name': the name is not an identifier*a switch has no default*'string pipe' is not a spec*output 'string!' is not void*"
        }

        It 'rejects parameters that are not a map' {
            { [Catzc.Base.Contracts.ContractCommand]::new(@{ parameters = 'Path' }) } | Should -Throw '*parameters must be a map*'
        }

        It 'takes void, a contract type or a list of one as the output' {
            [Catzc.Base.Contracts.ContractCommand]::IsOutputType('void') | Should -BeTrue
            [Catzc.Base.Contracts.ContractCommand]::IsOutputType('int[]') | Should -BeTrue
            [Catzc.Base.Contracts.ContractCommand]::IsOutputType('Catzc.Widgets.Widget[]') | Should -BeTrue
            [Catzc.Base.Contracts.ContractCommand]::IsOutputType('string!') | Should -BeFalse
            [Catzc.Base.Contracts.ContractCommand]::IsOutputType('object') | Should -BeFalse
        }
    }

    Context 'the type map' -Tag 'ADR-REPO-CMDCONTRACT#4' {
        It 'maps <Name> to <Type> (list: <List>)' -ForEach @(
            @{ Name = 'string'; Type = 'string'; List = $false }
            @{ Name = 'System.String[]'; Type = 'string'; List = $true }
            @{ Name = 'int'; Type = 'int'; List = $false }
            @{ Name = 'Int64'; Type = 'int'; List = $false }
            @{ Name = 'bool'; Type = 'bool'; List = $false }
            @{ Name = 'switch'; Type = 'switch'; List = $false }
            @{ Name = 'System.Management.Automation.SwitchParameter'; Type = 'switch'; List = $false }
            @{ Name = 'Catzc.Base.Widgets.Widget[]'; Type = 'Catzc.Base.Widgets.Widget'; List = $true }
            @{ Name = 'System.Collections.IDictionary'; Type = $null; List = $false }
            @{ Name = 'object'; Type = $null; List = $false }
        ) {
            $isList = $false
            [Catzc.Base.Contracts.ContractParameter]::NormalizeType($Name, [ref] $isList) | Should -Be $Type
            $isList | Should -Be $List
        }
    }

    Context 'the comparison' -Tag 'ADR-REPO-CMDCONTRACT#4' {
        It 'has no finding when the command declares what the contract says' {
            $text = "parameters:`n  Path: string!`n  Engine: string = auto`n  Item: string[] pipeline`noutput: int`n"
            [Catzc.Base.Contracts.ContractCommand]::Compare((New-Command $text), (New-Command $text)) | Should -BeNullOrEmpty
        }

        It 'finds: <Finding>' -ForEach @(
            @{ Contract = "parameters:`n  Path: string!`n"; Command = "parameters:`n  Path: string!`n  Name: string`n"; Finding = "parameter 'Name' is in the command but not in the contract" }
            @{ Contract = "parameters:`n  Path: string!`n  Name: string`n"; Command = "parameters:`n  Path: string!`n"; Finding = "parameter 'Name' is in the contract but not in the command" }
            @{ Contract = "parameters:`n  Path: string`n"; Command = "parameters:`n  Path: string[]`n"; Finding = "parameter 'Path': the contract says string, the command declares string[]" }
            @{ Contract = "parameters:`n  Path: string!`n"; Command = "parameters:`n  Path: string`n"; Finding = "parameter 'Path': the contract says mandatory, the command declares optional" }
            @{ Contract = "parameters:`n  Path: string`n"; Command = "parameters:`n  Path: string pipeline`n"; Finding = "parameter 'Path': the contract says no pipeline, the command declares pipeline" }
            @{ Contract = "parameters:`n  Engine: string = auto`n"; Command = "parameters:`n  Engine: string`n"; Finding = "parameter 'Engine': the contract's default is 'auto', the command's is none" }
            @{ Contract = "output: void`n"; Command = "output: string`n"; Finding = 'output: the contract says void, the command declares string' }
        ) {
            [Catzc.Base.Contracts.ContractCommand]::Compare((New-Command $Contract), (New-Command $Command)) | Should -Be @($Finding)
        }

        It 'does not compare a default the command computes' {
            $computed = [Catzc.Base.Contracts.ContractParameter]::new('Root', 'string', $false, $false, [Catzc.Base.Contracts.ContractParameter]::ComputedDefault, $false)
            $command = [Catzc.Base.Contracts.ContractCommand]::new([Catzc.Base.Contracts.ContractParameter[]] @($computed), 'void')
            [Catzc.Base.Contracts.ContractCommand]::Compare((New-Command "parameters:`n  Root: string = here`n"), $command) | Should -BeNullOrEmpty
        }
    }
}
