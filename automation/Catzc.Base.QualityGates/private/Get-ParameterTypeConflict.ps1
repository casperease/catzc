<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-ParameterTypeConflict.ps1
    folder: private
    name: get-parameter-type-conflict
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    page: docs/references/automation/catzc-base-qualitygates/private/Get-ParameterTypeConflict.ps1.md
    test: automation/Catzc.Base.QualityGates/tests/Get-ParameterTypeConflict.Tests.ps1
---
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
