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
