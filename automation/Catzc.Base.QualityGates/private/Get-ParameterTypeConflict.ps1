<#
.SYNOPSIS
    Finds the parameter names that carry more than one type across the given function files.
.DESCRIPTION
    The logic behind Test-ParameterConsistency: parses each file, reads every function's declared parameters, and...
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-ParameterTypeConflict.ps1.md#comment1)
.PARAMETER Path
    The .ps1 files to read (absolute paths).
.OUTPUTS
    [pscustomobject] { Name; Types } per conflicting name, by name — Types one { Type; Functions } per element type, by
    type, Functions the declaring functions sorted ordinally.
.EXAMPLE
    Get-ParameterTypeConflict -Path (Get-ChildItem automation/Catzc.Widget -Filter *.ps1).FullName
#>
function Get-ParameterTypeConflict {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyCollection()]
        [string[]] $Path
    )

    $isFunction = {
        param($node)
        $node -is [System.Management.Automation.Language.FunctionDefinitionAst]
    }
    $declarations = foreach ($file in $Path) {
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($file, [ref] $null, [ref] $null)
        foreach ($function in $ast.FindAll($isFunction, $false)) {
            if ($null -eq $function.Body.ParamBlock) {
                continue
            }
            foreach ($parameter in $function.Body.ParamBlock.Parameters) {
                $constraint = $parameter.Attributes | Where-Object { $_ -is [System.Management.Automation.Language.TypeConstraintAst] } |
                    Select-Object -First 1
                if (-not $constraint) {
                    continue
                }
                # Resolve through.NET where the type is loaded, so an accelerator and its full name are one type...
                # [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Get-ParameterTypeConflict.ps1.md#comment2)
                $reflected = $constraint.TypeName.GetReflectionType()
                if ($reflected -and $reflected.IsArray) {
                    $reflected = $reflected.GetElementType()
                }
                if ($reflected -in [object], [psobject]) {
                    continue
                }
                $element = if ($reflected) {
                    $reflected.FullName
                }
                else {
                    $constraint.TypeName.FullName -replace '\[\]$', ''
                }
                $element = $element -replace '^System\.', ''
                [pscustomobject]@{ Name = $parameter.Name.VariablePath.UserPath; Element = $element.ToLowerInvariant(); Function = $function.Name }
            }
        }
    }
    foreach ($group in @($declarations | Group-Object Name | Sort-Object Name)) {
        $types = @($group.Group | Group-Object Element | Sort-Object Name)
        if ($types.Count -lt 2) {
            continue
        }
        [pscustomobject]@{
            Name  = $group.Name
            Types = @(foreach ($type in $types) {
                    $functions = [System.Collections.Generic.SortedSet[string]]::new([string[]] @($type.Group.Function), [System.StringComparer]::Ordinal)
                    [pscustomobject]@{ Type = $type.Name; Functions = @($functions) }
                })
        }
    }
}
