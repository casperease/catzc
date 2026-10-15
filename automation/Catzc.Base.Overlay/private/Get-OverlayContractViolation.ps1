<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Overlay/private/Get-OverlayContractViolation.ps1
    kind: private-function
    module: Catzc.Base.Overlay
    visibility: private
    adrs:
      - ADR-AUTO-OVERLAY
---
#>

<#
.SYNOPSIS
    Returns every way an override file breaks the contract of the function it replaces.
.DESCRIPTION
    The bundle keeps calling the function as before, so an override may add optional parameters but no mandatory one.
.PARAMETER Original
    The loaded function the override replaces.
.PARAMETER Path
    The override file.
.PARAMETER RelativePath
    The override file as the messages show it.
.OUTPUTS
    [string] One message per break; nothing when the contract holds.
#>
function Get-OverlayContractViolation {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [System.Management.Automation.FunctionInfo] $Original,

        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $RelativePath
    )

    $tokens = $null
    $parseErrors = $null
    $syntaxTree = [System.Management.Automation.Language.Parser]::ParseFile($Path, [ref] $tokens, [ref] $parseErrors)
    $definition = $syntaxTree.Find({ param($node) $node -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $false)
    if ($null -eq $definition) {
        return   # the shape check (Get-FunctionFileViolation) reports a file that defines no function
    }

    $common = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($name in @([System.Management.Automation.Cmdlet]::CommonParameters) + @([System.Management.Automation.Cmdlet]::OptionalCommonParameters)) {
        [void] $common.Add($name)
    }
    $isMandatory = {
        param($attributes)
        foreach ($attribute in @($attributes)) {
            if ($attribute -is [System.Management.Automation.Language.AttributeAst] -and $attribute.TypeName.GetReflectionType() -eq [System.Management.Automation.ParameterAttribute]) {
                foreach ($argument in $attribute.NamedArguments) {
                    if ($argument.ArgumentName -ieq 'Mandatory' -and ($argument.ExpressionOmitted -or "$($argument.Argument.SafeGetValue())" -ieq 'True')) {
                        return $true
                    }
                }
            }
        }
        $false
    }

    $declared = @{}
    $parameters = @(if ($definition.Body.ParamBlock) {
            $definition.Body.ParamBlock.Parameters
        }
        elseif ($definition.Parameters) {
            $definition.Parameters
        })
    foreach ($parameter in $parameters) {
        $declared[$parameter.Name.VariablePath.UserPath] = $parameter
    }

    foreach ($name in $Original.Parameters.Keys) {
        if ($common.Contains($name)) {
            continue
        }
        $originalType = $Original.Parameters[$name].ParameterType
        if (-not $declared.ContainsKey($name)) {
            "${RelativePath}: drops parameter -$name of $($Original.Name); an override keeps every parameter the original declares"
            continue
        }
        $overrideType = $declared[$name].StaticType
        if ($overrideType -ne $originalType) {
            "${RelativePath}: declares -$name as [$($overrideType.FullName)], but $($Original.Name) declares [$($originalType.FullName)]"
        }
    }

    foreach ($name in $declared.Keys) {
        $originalMandatory = $Original.Parameters.ContainsKey($name) -and @($Original.Parameters[$name].Attributes |
                Where-Object { $_ -is [System.Management.Automation.ParameterAttribute] -and $_.Mandatory }).Count -gt 0
        if (-not $originalMandatory -and (& $isMandatory $declared[$name].Attributes)) {
            "${RelativePath}: makes -$name mandatory, which $($Original.Name) does not; the bundle's own callers do not pass it"
        }
    }

    $originalOutput = [string[]] @($Original.OutputType | ForEach-Object { $_.Name } | Sort-Object -Unique)
    $outputAttributes = @($definition.Body.ParamBlock | Where-Object { $_ } | ForEach-Object { $_.Attributes } |
            Where-Object { $_.TypeName.GetReflectionType() -eq [System.Management.Automation.OutputTypeAttribute] })
    $declaredOutput = @(foreach ($attribute in $outputAttributes) {
            foreach ($argument in $attribute.PositionalArguments) {
                if ($argument -is [System.Management.Automation.Language.TypeExpressionAst]) {
                    $type = $argument.TypeName.GetReflectionType()
                    if ($type) {
                        $type.FullName
                    }
                    else {
                        $argument.TypeName.FullName
                    }
                }
                elseif ($argument -is [System.Management.Automation.Language.StringConstantExpressionAst]) {
                    $argument.Value
                }
                else {
                    $argument.Extent.Text
                }
            }
        })
    $overrideOutput = [string[]] @($declaredOutput | Sort-Object -Unique)
    if (($originalOutput -join ',') -ne ($overrideOutput -join ',')) {
        "${RelativePath}: declares [OutputType($($overrideOutput -join ', '))], but $($Original.Name) declares [OutputType($($originalOutput -join ', '))]"
    }
}
