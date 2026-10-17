<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Contracts/private/Read-CommandSignature.ps1
    folder: private
    name: read-command-signature
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.Contracts/tests/Read-CommandSignature.Tests.ps1
    cites:
      - ADR-REPO-CMDCONTRACT#4
  config:
    synopsis: Reads a PowerShell command's signature from its file, without loading it, as a ContractCommand.
    description: |-
      The PowerShell checker's reading side
      ([ADR-REPO-CMDCONTRACT#4](/docs/adr/repository/command-contracts.md#rule-adr-repo-cmdcontract4)): the file is parsed,
      never run or imported, and the named function's parameter block becomes one ContractParameter per parameter, in the
      same shape a contract parses to, so ContractCommand.Compare can hold the two against each other.
      - The type is the parameter's type constraint, mapped to the contract's closed set (string, int, bool, switch, a
        Catzc.* type, '[]' for an array); a type outside the set keeps its own name, so the comparison names it, and an
        untyped parameter is 'object'.
      - Mandatory and pipeline come from the Parameter attribute's Mandatory and ValueFromPipeline arguments, bare or
        set to $true.
      - A constant default (a string, a number, $true or $false) is its text; $null is no default; any other expression
        is ContractParameter.ComputedDefault, which the comparison does not compare.
      - The output is the first type the OutputType attribute names, mapped the same way; no attribute is void.
      A file that does not parse, or defines no function of the name, throws a message naming the file.
    parameters:
      Path: The absolute path of the command's file.
      Name: The function's name, Verb-Noun.
    outputs: '[Catzc.Base.Contracts.ContractCommand] The signature as read.'
    examples:
      - Read-CommandSignature -Path $file -Name Get-Widget
---
#>

function Read-CommandSignature {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Contracts.ContractCommand])]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $Name
    )

    $tokens = $null
    $errors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseFile($Path, [ref] $tokens, [ref] $errors)
    if ($errors.Count -gt 0) {
        throw "the command's file '$Path' does not parse: $($errors[0].Message)"
    }
    $function = $ast.Find({
            param($node)
            $node -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $node.Name -ceq $Name
        }, $false)
    if (-not $function) {
        throw "the file '$Path' defines no function '$Name'"
    }

    $parameters = [System.Collections.Generic.List[Catzc.Base.Contracts.ContractParameter]]::new()
    $output = [Catzc.Base.Contracts.ContractCommand]::DefaultOutput
    $block = $function.Body.ParamBlock
    if ($block) {
        foreach ($parameter in $block.Parameters) {
            $typeName = 'object'
            $mandatory = $false
            $pipeline = $false
            foreach ($attribute in $parameter.Attributes) {
                if ($attribute -is [System.Management.Automation.Language.TypeConstraintAst]) {
                    $typeName = $attribute.TypeName.FullName
                }
                elseif ($attribute -is [System.Management.Automation.Language.AttributeAst] -and $attribute.TypeName.Name -cin 'Parameter', 'ParameterAttribute') {
                    foreach ($argument in $attribute.NamedArguments) {
                        $isOn = $argument.ExpressionOmitted -or
                        ($argument.Argument -is [System.Management.Automation.Language.VariableExpressionAst] -and $argument.Argument.VariablePath.UserPath -ieq 'true')
                        if ($argument.ArgumentName -ieq 'Mandatory') {
                            $mandatory = $isOn
                        }
                        elseif ($argument.ArgumentName -ieq 'ValueFromPipeline') {
                            $pipeline = $isOn
                        }
                    }
                }
            }
            $isList = $false
            $type = [Catzc.Base.Contracts.ContractParameter]::NormalizeType($typeName, [ref] $isList)
            if (-not $type) {
                $isList = $typeName.EndsWith('[]')
                $type = $isList ? $typeName.Substring(0, $typeName.Length - 2) : $typeName
            }
            $default = $null
            $value = $parameter.DefaultValue
            if ($value -is [System.Management.Automation.Language.StringConstantExpressionAst]) {
                $default = $value.Value
            }
            elseif ($value -is [System.Management.Automation.Language.ConstantExpressionAst]) {
                $default = [System.Convert]::ToString($value.Value, [System.Globalization.CultureInfo]::InvariantCulture)
            }
            elseif ($value -is [System.Management.Automation.Language.VariableExpressionAst]) {
                $variable = $value.VariablePath.UserPath
                if ($variable -iin 'true', 'false') {
                    $default = $variable.ToLowerInvariant()
                }
                elseif ($variable -ine 'null') {
                    $default = [Catzc.Base.Contracts.ContractParameter]::ComputedDefault
                }
            }
            elseif ($null -ne $value) {
                $default = [Catzc.Base.Contracts.ContractParameter]::ComputedDefault
            }
            $parameters.Add([Catzc.Base.Contracts.ContractParameter]::new($parameter.Name.VariablePath.UserPath, $type, $isList, $mandatory, $default, $pipeline))
        }

        foreach ($attribute in $block.Attributes) {
            if ($attribute -is [System.Management.Automation.Language.AttributeAst] -and $attribute.TypeName.Name -cin 'OutputType', 'OutputTypeAttribute' -and $attribute.PositionalArguments.Count -gt 0) {
                $first = $attribute.PositionalArguments[0]
                $outputName = if ($first -is [System.Management.Automation.Language.TypeExpressionAst]) {
                    $first.TypeName.FullName
                }
                else {
                    [string] $first.Value
                }
                $isList = $false
                $type = [Catzc.Base.Contracts.ContractParameter]::NormalizeType($outputName, [ref] $isList)
                $output = $type ? ($type + ($isList ? '[]' : '')) : $outputName
                break
            }
        }
    }

    [Catzc.Base.Contracts.ContractCommand]::new($parameters, $output)
}
